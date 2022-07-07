// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

// import "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";
import {strings} from "strings/strings.sol";

// Commands
import {Command} from "src/Command.sol";
import {Sed} from "src/commands/Sed.sol";

library Unix {
  using strings for *;

  Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

  /// @notice Internal Helper for Comparing Strings
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @notice Returns a new instance of Sed
  function sed() public view returns (Sed) {
    return new Sed();
  }

  /// @notice Runs a command
  function run(Command inner) public returns (uint256, bytes memory) {
    // combine the sed options into a string
    return exec(string.concat(inner.get_ty(), flatten(inner.options())));
  }

  /// @notice Executes a command with provided options
  function exec(string memory command, string[] memory options) internal returns (uint256, bytes memory) {
    string memory args = flatten(options);
    return exec(command, args);
  }

  /// @notice Flattens arguments into a single string
  function flatten(string[] memory options) internal returns (string memory) {
    // Merge the options into a single string
    string memory args = "";
    for (uint i = 0; i < options.length; i++) {
      args = string.concat(args, options[i]);
      if (i + 1 == options.length) {
        args = string.concat(args, " ");
      }
    }
    return args;
  }

  /// @notice Encodes an image at a url into a base64 string
  function run(string memory input) internal returns (uint256 success, bytes memory data) {
    return exec(input);
  }

  /// @notice Executes a script with no args
  function exec(string memory args) internal returns (uint256, bytes memory) {
    string[] memory cmds = new string[](2);
    cmds[0] = string.concat("./src/command.sh");
    cmds[1] = args;
    return decode(vm.ffi(cmds));
  }

  /// @notice Decodes the command script response into (uint256, bytes)
  function decode(bytes memory data) internal pure returns (uint256, bytes memory) {
    (uint256 success, bytes memory s) = abi.decode(data, (uint256, bytes));
    return (success, s);
  }
}
