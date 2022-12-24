// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedConsumer {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Polygon
     * Aggregator: MATIC/USD
     * Address: 0xab594600376ec9fd91f8e885dadf0ce036862de0
     */

    constructor() {
        // MATIC % USD
        priceFeed = AggregatorV3Interface(0xab594600376ec9fd91f8e885dadf0ce036862de0);
    }

   function getLatestPrice() public view returns (int) {
    (
      uint80 roundID,
      int price,
      uint startedAt,
      uint timeStamp,
      uint80 answeredInRound
    ) = priceFeed.latestRoundData();
    // for MATIC / USD price is scaled up by 10 ** 8
    return price / 1e8;
  }
}

interface AggregatorV3Interface {
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int answer,
      uint startedAt,
      uint updatedAt,
      uint80 answeredInRound
    );
}