// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {strings} from "strings/strings.sol";

library Unix {
  using strings for *;

  Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

  /// @notice Internal Helper for Comparing Strings
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @notice Encodes an image at a url into a base64 string
  function run(string memory input) internal returns (uint256 success, bytes memory data) {
    // Grab the first command from the input
    strings.slice memory s = input.toSlice();
    strings.slice memory delim = " ".toSlice();
    uint256 delim_count = s.count(delim) + 1;
    string memory command = s.split(delim).toString();

    // Merge the rest of the input into the cmd args
    string memory args = "";
    for (uint i = 1; i < delim_count; i++) {
      if (i + 1 == delim_count) {
        args = string.concat(args, s.split(delim).toString());
      } else {
        args = string.concat(args, s.split(delim).toString(), " ");
      }
    }

    // Match on commands
    if (compareStrings(command, "echo")) {
      return exec("echo", args);
    }
    if (compareStrings(command, "rm")) {
      return exec("rm", args);
    }
    if (compareStrings(command, "pwd")) {
      return exec("pwd");
    }
    if (compareStrings(command, "wget")) {
      return exec("wget", args);
    }
    if (compareStrings(command, "sed")) {
      return exec("sed", args);
    }

    // Otherwise, fail with unsupported command
    return (0, abi.encode("FAILURE: Command ", command, " not found!"));
  }

  /// @notice Executes a script with no args
  function exec(string memory script) internal returns (uint256, bytes memory) {
    string[] memory cmds = new string[](2);
    cmds[0] = string.concat("./src/", script, ".sh");
    return decode(vm.ffi(cmds));
  }

  /// @notice Executes a bash script by name with one param
  function exec(string memory script, string memory params) internal returns (uint256, bytes memory) {
    string[] memory cmds = new string[](2);
    cmds[0] = string.concat("./src/", script, ".sh");
    cmds[1] = params;
    return decode(vm.ffi(cmds));
  }

  function decode(bytes memory data) internal pure returns (uint256, bytes memory) {
    (uint256 success, bytes memory s) = abi.decode(data, (uint256, bytes));
    return (success, s);
  }
}
