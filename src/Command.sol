// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

/// @title Command
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Generalized Shell Command
contract Command {
  using Unix for *;

  /// @notice Options to append to the command
  string[] public options;

  /// @dev Command Types
  enum CommandType { ECHO, CAT, GREP, PWD, RM, SED, WGET, PIPE }

  /// @notice The command Type
  CommandType internal ty;

  /// @notice Stringifies the command
  function churn() public virtual returns (string memory) {
    return string.concat(get_ty(), flatten());
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

  // Common flags

  /// @notice Appends the version option to sed
  function version() public returns (Command) {
    options.push("--version");
    return this;
  }

}
