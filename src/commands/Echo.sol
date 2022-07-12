// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import "forge-std/console2.sol";
import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

/// @title Echo
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice A Wrapper for Echo <https://www.gnu.org/software/echo/manual/html_node/echo-commands-list.html>
contract Echo is Command {
  /// @notice The text to print to standard out
  string public out;

  constructor() {
    ty = CommandType.ECHO;
  }

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

  /// @notice Executes a subcommand and cast encodes the result
  function exec(function(string[] memory) external returns (bytes memory) ffi) internal override returns (bytes memory) {
    string[] memory cmds = new string[](3);
    cmds[0] = "./src/scripts/encode.sh";
    cmds[1] = "response(string)";
    cmds[2] = inner();
    return ffi(cmds);
  }

  /// @notice Decodes the command script response into (uint256, bytes)
  function decode(bytes memory data) internal override view returns (uint256, bytes memory) {
    if (keccak256(data) != keccak256(abi.encode(out))) {
      return (0, bytes("ECHO_FAILED"));
    }
    return (1, bytes(out));
  }
}
