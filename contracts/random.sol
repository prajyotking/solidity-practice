// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract myContract{
    uint[3] public myArr = [10,20,30];


    function storageArr() external{
        uint[3] storage stoArr = myArr;
        stoArr[0] = 1;
    }

    function memoryArr() external view{
        uint[3] memory memoArr = myArr;
        memoArr[0] = 1;
    }
}