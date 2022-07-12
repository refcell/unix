// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

contract grep is Script {
  using Unix for *;

  function setUp() public {}

  function run() public {
    // (uint256 success, bytes memory data) = "grep foundry README.md".run();
    // require(success == 1, "GREP_CMD_FAILED");
    // console2.log(string.concat("\nGREP:\n", string(data)));
  }
}
