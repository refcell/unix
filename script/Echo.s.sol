// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import {Unix} from "src/Unix.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Echo is Script {
    using Unix for *;

    function setUp() public {}

    function run() public {
        (uint256 success, bytes memory data) = "echo \"Hello World!\"".run();
        console.log("success:", success);
        console.log("output:", string(data));
    }
}
