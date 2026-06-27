// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct OrderInfo{
    uint256 orderId;
    address seller;
    uint256 numberOfTokensToSell;
    bool isActive;
}