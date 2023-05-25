// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/access/Ownable.sol";


contract Box is Ownable {
    //declare a  state valuble

    uint256 private value;

    event ValueChanged(uint256 newValue);


    function  store(uint256  newValue) public  onlyOwner{
        value = newValue;

        emit ValueChanged(newValue);

    }
    function retrive ()public view  returns (uint256){
        return  value;
    }
}