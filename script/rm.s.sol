// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

contract rm is Script {
  using Unix for *;

  function setUp() public {}

  function run() public {
    // Create the file
    createFile("__test.txt");

    // Remove the file
    (uint256 success, bytes memory data) = "rm __test.txt".run();
    require(success == 1, "FAILED_TO_REMOVE_FILE");
    console2.log(string.concat("\nSuccessfully deleted: ", string(data)));
  }

  function createFile(string memory file) public {
    vm.writeFile(file, "DATA DATA DATA");
  }
}
