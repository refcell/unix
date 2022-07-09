// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

contract mkdir is Script {
  using Unix for *;

  function setUp() public {}

  function run() public {
    (uint256 success, bytes memory data) = "mkdir test-dir".run();
    require(success == 1, "MKDIR_CMD_FAILED");
    console2.log(string.concat("\nDirectory created: ","test-dir"));
  }
}
