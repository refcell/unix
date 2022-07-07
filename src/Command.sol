// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

/// @title Command
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Generalized Shell Command
contract Command {
  /// @notice Options to append to the command
  string[] public options;

  /// @dev Command Types
  enum CommandType { ECHO, CAT, GREP, PWD, RM, SED, WGET }

  /// @notice The command Type
  CommandType internal ty;

  /// @notice The unix library to call back to
  Unix public unix;

  constructor(Unix inlined_unix) public {
    unix = inlined_unix;
  }

  /// @notice Appends the version option to sed
  function version() public returns (Command) {
    options.push("--version");
    return this;
  }

  /// @notice Gets the command type
  function get_ty() public view returns (string memory) {
    return string(ty);
  }
}
