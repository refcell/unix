// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";
import {Command} from "src/Command.sol";

import "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {strings} from "strings/strings.sol";

contract TypedTest is Test {
  using Unix for *;

  function setUp() public {}

  function testTypedEcho() public {
    Command echo = Unix.echo().n().stdout("Hello World");
    (uint256 success, bytes memory data) = Unix.run(echo);
    assertEq(success, 1);
    assertEq(string(data), "Hello World");
    console2.log(string.concat("\nEchoed: \"", string(data), "\""));
  }
}
