// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {strings} from "strings/strings.sol";

import {Command} from "src/Command.sol";

/// @title Runner
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A backend runner for arbitrary unix shell commands.
/// @notice Uses Foundry's ffi cheatcode <https://book.getfoundry.sh/cheatcodes/ffi.html>
contract Runner {
  using strings for *;

  /// @notice An internal store of commands
  /// @notice If there is no connector between commands, the runner will merge stdout.
  Command[] public commands;

  Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

  /// @notice Internal Helper for Comparing Strings
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @notice Registers a new command with the existing runner
  function register(Command cmd) public returns (Runner) {
    commands.push(cmd);
    return this;
  }

  /// @notice Runs a single command
  function run(Command inner) public returns (uint256, bytes memory) {
    return exec(inner.churn());
  }

  /// @notice Runs an arbitrary string input
  function run(string memory input) internal returns (uint256 success, bytes memory data) {
    return exec(input);
  }

  /// @notice Runs all registered commands
  function run() public returns (uint256 success, bytes memory data) {
    // TODO: properly group commands
    return exec(flatten());
  }

  /// @notice Executes a command with provided options
  function exec(string memory command, string[] memory options) internal returns (uint256, bytes memory) {
    string memory args = flatten(options);
    return exec(string.concat(command, " ", args));
  }

  /// @notice Executes a script with no args
  function exec(string memory args) internal returns (uint256, bytes memory) {
    string[] memory cmds = new string[](2);
    cmds[0] = string.concat("./src/command.sh");
    cmds[1] = args;
    return decode(vm.ffi(cmds));
  }

  /// @notice Flattens arguments into a single string
  function flatten(string[] memory options) internal returns (string memory) {
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

  /// @notice Decodes the command script response into (uint256, bytes)
  function decode(bytes memory data) internal pure returns (uint256, bytes memory) {
    (uint256 success, bytes memory s) = abi.decode(data, (uint256, bytes));
    return (success, s);
  }
}
