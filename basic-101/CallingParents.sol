// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {
  event Log(string message); 
  function foo() public {
    emit Log("A.foo was called");
  }
}