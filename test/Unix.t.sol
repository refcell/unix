// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Test} from "forge-std/Test.sol";

contract UnixTest is Test {
  using Unix for *;

  function setUp() public {}

  function testEcho() public {
    (uint256 success, bytes memory data) = "echo \"Hello World!\"".run();

    assertEq(success, 1);
    assertEq(string(data), 'Hellow World!');
  }
}
