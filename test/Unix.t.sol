// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Test} from "forge-std/Test.sol";

contract UnixTest is Test {
  using Unix for *;

  function setUp() public {}

  function testEcho() public {
    (uint256 success, bytes memory data) = "echo Hello World".run();

    assertEq(success, 1);
    assertEq(string(data), "Hello World");
  }

  function testRemove() public {
    // Create the test file
    vm.writeFile("__test.txt", "DATA DATA DATA");

    // Remove the file
    (uint256 success, bytes memory data) = "rm __test.txt".run();
    assertEq(success, 1);
    assertEq(string(data), "__test.txt");

    // If we try to remove again, it should fail
    (success, data) = "rm __test.txt".run();
    assertEq(success, 0);
    assertEq(string(data), "FILE_NOT_FOUND");
  }
}
