// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";

import {Unix} from "src/Unix.sol";
import {strings} from "strings/strings.sol";

/// @title Command
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Generalized Shell Command
contract Command {
  using Unix for *;
  using strings for *;

  Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

  /// @notice Options to append to the command
  string[] public options;

  /// @dev Command Types
  enum CommandType { ECHO, CAT, GREP, PWD, RM, SED, WGET, PIPE }

  /// @notice The command Type
  CommandType internal ty;

  /// @notice The raw command as a string
  string internal raw;

  /// @notice Stringifies the command
  function churn() public virtual returns (string memory) {
    return string.concat(get_ty(), flatten());
  }

  /// @notice Gets the raw representation of the command as a string
  function inner() public returns (string memory) {
    if (bytes(raw).length == 0) {
      string memory new_raw = churn();
      raw = new_raw;
      return new_raw;
    }
    return raw;
  }

  /// @notice Gets the command type
  function get_ty() public view returns (string memory) {
    if (ty == CommandType.ECHO) {
      return "echo";
    }
    if (ty == CommandType.CAT) {
      return "cat";
    }
    if (ty == CommandType.GREP) {
      return "grep";
    }
    if (ty == CommandType.PWD) {
      return "pwd";
    }
    if (ty == CommandType.RM) {
      return "rm";
    }
    if (ty == CommandType.SED) {
      return "sed";
    }
    if (ty == CommandType.WGET) {
      return "wget";
    }
    if (ty == CommandType.PIPE) {
      return "|";
    }

    revert("Failed to match on type");
  }

  /// @notice Flattens the options into a string
  function flatten() internal view returns (string memory) {
    // Merge the options into a single string
    string memory args = "";
    for (uint i = 0; i < options.length; i++) {
      args = string.concat(args, options[i]);
      if (i + 1 == options.length) {
        args = string.concat(args, " ");
      }
    }
    return args;
  }

  /// @notice Sets the raw command
  function setRaw(string memory newraw) public {
    raw = newraw;
  }

  /// @notice Executes a subcommand and cast encodes the result
  function exec(function(string[] memory) external returns (bytes memory) ffi) internal virtual returns (bytes memory) {
    uint256 success = 1;
    string[] memory cmds = new string[](1);
    cmds[0] = string.concat("cast abi-encode response(uint256,string) 1 $(", inner(), ")");
    return ffi(cmds);
  }

  /// @notice Decodes the command script response into (uint256, bytes)
  function decode(bytes memory data) internal virtual view returns (uint256, bytes memory) {
    (uint256 success, bytes memory s) = abi.decode(data, (uint256, bytes));
    return (success, s);
  }

  /// @notice Executes a command and returns the decoded result
  /// @notice Not intended to be overridden since both exec and decode are virtual
  function run() public returns (uint256, bytes memory) {
    return decode(exec(vm.ffi));
  }

  // Common flags

  /// @notice Appends the version option to sed
  function version() public returns (Command) {
    options.push("--version");
    return this;
  }

}
