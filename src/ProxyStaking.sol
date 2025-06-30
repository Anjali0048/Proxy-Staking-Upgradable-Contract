// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

contract ProxyStaking is Ownable(msg.sender) {

    address public impl;

    constructor(address _impl) {
        impl = _impl;
    }

    function setImplementation(address _impl) external onlyOwner {
        impl = _impl;
    }

    fallback() external payable {
        (bool success, ) = impl.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }
}

contract StakingContractImplV1 {
    address public owner;
    address public impl;
    mapping(address => uint) public balances;
    uint public totalStaked;

    function stake(uint _amount) public payable {
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value == _amount, "Incorrect Ether sent");
        balances[msg.sender] += _amount;
        totalStaked += _amount;
    }

    function unstake(uint _amount) public payable {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        payable(msg.sender).transfer(_amount / 2);
        balances[msg.sender] -= _amount; 
        totalStaked -= _amount;
    }

}