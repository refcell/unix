// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

contract sed is Script {
  using Unix for *;

  function setUp() public {}

  function run() public {
      // (uint256 success, bytes memory data) = "sed s/\\/// .gitignore".run();
      // require(success == 1, "SED_CMD_FAILED");
      // console2.log(string.concat("\n--> gitignore contents\n", string(data)));
  }
}
