// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {strings} from "strings/strings.sol";

contract UnixTest is Test {
  using Unix for *;
  using strings for *;

  function setUp() public {}

  function testEcho() public {
    (uint256 success, bytes memory data) = "echo Hello World".run();
    assertEq(success, 1);
    assertEq(string(data), "Hello World");
    console2.log(string.concat("Echoed: \"", string(data), "\""));
  }

  function testRemove() public {
    // Create the test file
    vm.writeFile("__test.txt", "DATA DATA DATA");

    // Remove the file
    (uint256 success, bytes memory data) = "rm __test.txt".run();
    assertEq(success, 1);
    assertEq(string(data), "__test.txt");
    console2.log(string.concat("Successfully deleted: ", string(data)));

    // If we try to remove again, it should fail
    (success, data) = "rm __test.txt".run();
    assertEq(success, 0);
    assertEq(string(data), "FILE_NOT_FOUND");
  }

  function testPwd() public {
    // Get the current working directory
    (uint256 success, bytes memory data) = "pwd".run();
    assertEq(success, 1);
    console2.log(string.concat("Current working directory: ", string(data)));

    // Verify that we are in the unix dir
    strings.slice memory s = string(data).toSlice();
    strings.slice memory delim = "/".toSlice();
    uint256 delim_count = s.count(delim) + 1;
    string memory last_dir;
    for (uint i = 0; i < delim_count; i++) {
      last_dir = s.split(delim).toString();
    }
    assertEq(last_dir, "unix");
  }

  function testWget() public {
    // Fetch an image, then delete it
    string memory img = "https://picsum.photos/id/10/2500/1667.jpg";
    (uint256 success, bytes memory data) = string.concat("wget ", img).run();

    // Expect response of 302 since the resource is at a different url
    assertEq(success, 302);
    assertEq(string(data), "1667.jpg");
    console2.log(string.concat("Successful wget: ", string(data)));

    // Delete the image file
    console2.log("Removing the downloaded file...");
    (success,) = string.concat("rm ", string(data)).run();
    assertEq(success, 1);
    console2.log("Removed 1667.jpg");
  }

  function testSed() public {
    // Write a single phrase to a temp file
    vm.writeFile("__sed__test.txt", "Hello World");

    // Sed the temp file
    (uint256 success, bytes memory data) = string.concat("sed s/World/Unix/ __sed__test.txt").run();
    assertEq(success, 1);
    assertEq(string(data), "Hello Unix");
    console2.log(string.concat("Substituted text: \"", string(data), "\""));

    // Delete the temp file
    (success,) = string.concat("rm __sed__test.txt").run();
    assertEq(success, 1);
  }
}
