// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

/// @title Sed
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Wrapper for sed <https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html>
contract Sed {
  /// @notice Options to append to the sed command
  string[] private options;

  /// @notice The unix library to call back to
  Unix public unix;

  constructor(Unix inlined_unix) public {
    unix = inlined_unix;
  }

  /// @notice Appends the version option to sed
  function version() public returns (Sed) {
    options.push("--version");
    return this;
  }
}
