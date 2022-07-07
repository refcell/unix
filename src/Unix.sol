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
      // Run the echo command
      string[] memory echo = new string[](2);
      echo[0] = "./src/echo.sh";
      echo[1] = args;
      bytes memory res = vm.ffi(echo);
      (success, data) = abi.decode(res, (uint256, bytes));
      return (success, data);
    }

    // Otherwise, fail
    return (0, abi.encode("FAILURE: Command ", command, " not found!"));
  }
}
