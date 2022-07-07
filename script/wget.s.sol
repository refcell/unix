// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

contract wget is Script {
  using Unix for *;

  function setUp() public {}

  function run() public {
    // Fetch an image, then delete it
    string memory img = "https://picsum.photos/id/10/2500/1667.jpg";
    (uint256 success, bytes memory data) = string.concat("wget ", img).run();
    require(success == 302, "WGET_CMD_FAILED");
    console2.log(string.concat("\n--> wget\n", string(data), "\nRemoving the downloaded file..."));
    removeFile(string(data));
  }

  function removeFile(string memory file) public {
    (uint256 success,) = string.concat("rm ", file).run();
    require(success == 1, "RM_CMD_FAILED");
    console2.log(string.concat("\nRemoved ", file));
  }
}
