#!/usr/bin/env node

const readline = require("readline");
const { exec } = require("child_process");

readline.emitKeypressEvents(process.stdin);
process.stdin.setRawMode(true);

let branches = [];
let selectedBranchIdx = -1;

getBranchesAndSetState(printBranches);

function getBranchesAndSetState(callback) {
  exec("git branch -a", (error, stdout, stderr) => {
    if (hasErrors(error, stderr)) return;

    // Process raw input from command
    branches = processStdout(stdout).map(processRawBranchName);
    // Move local branches to the top, so they will have precedence over remotes in the next step
    branches.sort((b1, b2) =>
      b1.isRemote === b2.isRemote ? 0 : b1.isRemote && !b2.isRemote ? 1 : -1
    );
    // Remove branches having local-remote pairs
    branches = branches.filter(
      (b, idx) => branches.findIndex((c) => c.name === b.name) === idx
    );
    // Set current branch to be selected first
    selectedBranchIdx = branches.findIndex((b) => b.isCurrent);
    callback();
  });
}

function hasErrors(error, stderr) {
  if (error) {
    console.log(`error: ${error.message}`);
    return true;
  }
  if (stderr) {
    console.log(`stderr: ${stderr}`);
    return true;
  }
  return false;
}

function processStdout(stdout) {
  return stdout
    .trim()
    .split("\n")
    .map((b) => b.trim());
}

function processRawBranchName(rawBranchName) {
  const regexp = /^(?<currentFlag>\*\s)?(?<remoteTag>remotes\/origin\/)?(?<name>.*)$/;
  const match = regexp.exec(rawBranchName);
  return {
    isCurrent: match.groups.currentFlag ? true : false,
    isRemote: match.groups.remoteTag ? true : false,
    name: match.groups.name,
  };
}

function printBranches() {
  console.clear();
  branches.forEach((b, idx) => {
    console.log(
      `${selectedBranchIdx === idx ? " > " : "   "}${
        b.isCurrent ? "* " : "  "
      }${b.isRemote ? "[R] " : ""}${b.name}`
    );
  });
}

function doCheckout() {
  const branchName = branches[selectedBranchIdx].name;

  exec(`git checkout ${branchName}`, (error, stdout, stderr) => {
    hasErrors(error, false);
    console.log(`Switched to branch '${branchName}'`);
    process.exit();
  });
}

process.stdin.on("keypress", (str, key) => {
  if (key.ctrl && key.name === "c") {
    process.exit();
  } else if (key.name === "up") {
    if (selectedBranchIdx > 0) selectedBranchIdx--;
  } else if (key.name === "down") {
    if (selectedBranchIdx < branches.length - 1) selectedBranchIdx++;
  } else if (key.name === "return") {
    doCheckout();
  }
  printBranches();
});
