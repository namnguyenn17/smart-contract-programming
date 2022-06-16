// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
  using PriceConverter for uint256;

  mapping(address => uint256) public addressToAmountFunded;
  address[] public funders;

  address public owner;
  uint256 public constant MINIMUM_USD = 50 * 1e18;

  constructor() {
    owner = msg.sender;
  }

  function fund() public payable {
    require(msg.value.getConvertionPrice() >= MINIMUM_USD, "Minimum USD amount is 50");
    addressToAmountFunded[msg.sender] += msg.value;
    funders.push(msg.sender);
  }

  function getVersion() public view returns (uint256){
      AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
      return priceFeed.version();
  }

  modifier onlyOwner() {
    if (msg.sender != owner) revert NotOwner();
    _;
  }

  function withdraw() payable onlyOwner public {
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      addressToAmountFunded[funder] = 0;
    }
    funders = new address[](0);

    (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
  }

  receive() payable external {
    fund();
  }

  fallback() payable external  {
    fund();
  }

}