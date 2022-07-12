// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

import "forge-std/console2.sol";
import {strings} from "strings/strings.sol";

// Abstractions
import {Command} from "src/Command.sol";
import {Runner} from "src/Runner.sol";

// Commands
import {Sed} from "src/commands/Sed.sol";
import {Echo} from "src/commands/Echo.sol";
import {Rm} from "src/commands/Rm.sol";

/// @title Unix
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice An abstraction for executing unix shell commands.
library Unix {
  using strings for *;

  /// @notice Creates a runner backend
  function runner() public returns (Runner) {
    return new Runner();
  }

  /// @notice Internal Helper for Comparing Strings
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @notice Converts raw string into a command
  function from(string memory input) public returns (Command) {
    // TODO: parse expressive commands

    // Grab the first command from the input
    strings.slice memory s = input.toSlice();
    strings.slice memory delim = " ".toSlice();
    uint256 delim_count = s.count(delim) + 1;
    string memory command = s.split(delim).toString();

    // Merge the rest of the input into the cmd args
    string memory args = "";
    for (uint i = 1; i < delim_count; i++) {
      if (i + 1 == delim_count) {
        args = string.concat(args, s.split(delim).toString());
      } else {
        args = string.concat(args, s.split(delim).toString(), " ");
      }
    }

    // Match on commands
    if (compareStrings(command, "echo")) {
      if (args.toSlice().contains("-n".toSlice())) {
        return new Echo().n().stdout(args.toSlice().beyond("-n".toSlice()).toString());
      } else {
        return new Echo().stdout(args);
      }
    }
    if (compareStrings(command, "rm")) {
      console2.log("Created RM Command");
      return new Rm().stdout(args);
    }
    if (compareStrings(command, "sed")) {
      return new Sed().i(); // .stdout(args);
    }
    // if (compareStrings(command, "pwd")) {
    //   return exec("pwd");
    // }
    // if (compareStrings(command, "wget")) {
    //   return exec("wget", args);
    // }
    // if (compareStrings(command, "grep")) {
    //   return exec("grep", args);
    // }

    Command new_cmd = new Command();
    new_cmd.setRaw(input);
    return new_cmd;
  }

  /// @notice Returns a new instance of Sed
  function sed() public returns (Sed) {
    return new Sed();
  }

  /// @notice Returns a new instance of Echo
  function echo() public returns (Echo) {
    return new Echo();
  }

  /// @notice Returns a new instance of Rm
  function rm() public returns (Rm) {
    return new Rm();
  }

  /// @notice Registers a new command with a new runner
  /// @notice To execute the runner, call `run()` on the returned Runner
  function register(Command cmd) public returns (Runner) {
    return new Runner().register(cmd);
  }

  /// @notice Runs a command with a new runner
  function run(Command cmd) public returns (uint256, bytes memory) {
    return new Runner().register(cmd).run();
  }

  /// @notice Runs a raw command
  function run(string memory raw) public returns (uint256, bytes memory) {
    return new Runner().register(from(raw)).run();
  }
}
