// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.13 <0.9.0;

// import "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";
import {strings} from "strings/strings.sol";

// Abstractions
import {Command} from "src/Command.sol";
import {Runner} from "src/Runner.sol";

// Commands
import {Sed} from "src/commands/Sed.sol";
import {Echo} from "src/commands/Echo.sol";

/// @title Unix
/// @author Andreas Bigger <https://github.com/abigger87>
/// @notice An abstraction for executing unix shell commands.
library Unix {
  using strings for *;

  /// @notice Creates a runner backend
  function runner() public returns (Runner) {
    return new Runner();
  }

  /// @notice Returns a new instance of Sed
  function sed() public returns (Sed) {
    return new Sed();
  }

  /// @notice Returns a new instance of Echo
  function echo() public returns (Echo) {
    return new Echo();
  }

  /// @notice Registers a new command with a new runner
  /// @notice To execute the runner, call `run()` on the returned Runner
  function register(Command cm) public returns (Runner) {
    return new Runner().register(cmd);
  }

  /// @notice Runs a command with a new runner
  function run(Command cm) public returns (Runner) {
    return new Runner().register(cmd).run();
  }
}
