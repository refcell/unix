// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";

library Sh {

  Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

  /// @notice Internal Helper for Comparing Strings
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @notice Encodes an image at a url into a base64 string
  function run(string memory input) internal pure returns (uint256 success, bytes memory data) {
    // Grab the first command from the input
    strings.slice memory s = input.toSlice();
    strings.slice memory delim = " ".toSlice();
    string memory command = s.split(delim).toString();

    // Merge the rest of the input into the cmd args
    string memory args = "";
    for (uint i = 1; i < parts.length; i++) {
      args = string.concat(args, s.split(delim).toString());
    }

    // Match on commands
    if (compareStrings(command, "echo")) {
      // Run the echo command
      string[] memory echo = new string[](2);
      echo[0] = "./src/echo.sh";
      echo[1] = args;
      return vm.ffi(echo);
    }

    // Otherwise, fail
    return (0, abi.encode("FAILURE: Command ", command, " not found!"));
  }
}
