// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import "forge-std/console2.sol";
import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

/// @title Rm
/// @notice A wrapper for the `rm` command
/// @author Andreas Bigger <https://github.com/abigger87>
contract Rm is Command {
  /// @notice The file to remove
  string public file;

  constructor() {
    ty = CommandType.RM;
  }

  /// @notice Overrides the churning to append the output text
  function churn() public override view returns (string memory) {
    return string.concat(get_ty(), " ", flatten(), " ", file);
  }

  /// @notice Set the output string
  function stdout(string memory _file) public returns (Rm) {
    file = _file;
    return this;
  }

  /// @notice Ignore nonexistent files and arguments, never prompt
  function f() public returns (Rm) {
    options.push("-f");
    return this;
  }

  /// @notice Remove directories and their contents recursively
  function r() public returns (Rm) {
    options.push("-r");
    return this;
  }

  /// @notice Remove empty directories
  function d() public returns (Rm) {
    options.push("-d");
    return this;
  }

  /// @notice Dashed (if file starts with a '-')
  function dashed() public returns (Rm) {
    options.push("--");
    return this;
  }

  /// @notice Executes a subcommand and cast encodes the result
  function exec(function(string[] memory) external returns (bytes memory) ffi) internal override returns (bytes memory) {
    // If the file doesn't exist, return unsuccessfully
    string[] memory checkcmds = new string[](2);
    checkcmds[0] = "./src/scripts/check.sh";
    checkcmds[1] = file;
    bytes memory res = ffi(checkcmds);
    if (keccak256(res) != keccak256(bytes(hex"01"))) {
      return res;
    }

    // Otherwise, remove the file
    string[] memory rmcmds = new string[](2);
    rmcmds[0] = "./src/scripts/command.sh";
    rmcmds[1] = inner();
    ffi(rmcmds);

    // If the file exists, return unsuccessfully (hex"00")
    res = ffi(checkcmds);
    if (keccak256(res) != keccak256(bytes(hex"00"))) {
      return bytes(hex"00");
    }

    return bytes(hex"01");
  }

  /// @notice Decodes the command script response into (uint256, bytes)
  function decode(bytes memory data) internal override view returns (uint256, bytes memory) {
    if (keccak256(data) != keccak256(bytes(hex"01"))) {
      return (0, bytes("FAILED_TO_RM"));
    }
    return (1, bytes(file));
  }
}
