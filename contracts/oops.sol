// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Book {
    uint length;
    uint breadth;
    uint height;


    function setDimension(uint _length, uint _breadth, uint _height) public {
        length = _length;
        breadth = _breadth;
        height = _height;
    }


    function getDimension() public view returns (uint, uint, uint) {
        return (length, breadth, height);
    }
}


contract D {
    Book obj = new Book();


    function getInstance() public view returns (Book) {
        return obj;
    }


    function writeDimension(uint _length, uint _breadth, uint _height) public {
        obj.setDimension(_length, _breadth, _height);
    }


    function readDimension() public view returns (uint, uint, uint) {
        return obj.getDimension();
    }
}
