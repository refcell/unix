// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

/// @title Sed
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Wrapper for sed <https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html>
contract Sed is Command {
  // TODO: Add Commands...

  constructor() {
    ty = CommandType.SED;
  }

  /// @notice `-i` flag
  function i() public returns (Sed) {
    options.push("-i");
    return this;
  }
}
