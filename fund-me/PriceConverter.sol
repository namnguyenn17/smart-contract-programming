// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// connect your smart contracts to the real-world market prices of assets.
// retrieve the latest pricing data of an asset in a single call.
library PriceConverter {

  function getPrice() internal view returns(uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    (, int price, , ,) = priceFeed.latestRoundData();
    return uint256(price * 1e10);
  }

  function getConvertionPrice(uint256 ethAmount) internal view returns (uint256) {
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
    return ethAmountInUsd;
  }
}