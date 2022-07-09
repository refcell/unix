// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

/// @title Echo
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Wrapper for Echo <https://www.gnu.org/software/echo/manual/html_node/echo-commands-list.html>
contract Echo is Command {
  /// @notice The text to print to standard out
  string public out;

  /// @notice Set the output string
  function stdout(string memory _out) public returns (Echo) {
    out = _out;
    return this;
  }

  /// @notice Makes the output
  function n() public returns (Echo) {
    options.push("-n");
    return this;
  }

  /// @notice Overrides the churning to append the output text
  function churn() public override returns (string memory) {
    return string.concat(get_ty(), " ", flatten(), " ", out);
  }
}
