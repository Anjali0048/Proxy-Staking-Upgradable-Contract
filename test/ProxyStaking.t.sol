// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "src/ProxyStaking.sol";
import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract ProxyStakingTest is Test {

    ProxyStaking p;

    function setUp() public {
        p = new ProxyStaking();
        vm.deal(address(this), 100 ether);
    } 

    function test_Stake() public {
        uint amt = 10 ether;
        
        p.stake{value: amt}(amt);

        assertEq(address(p).balance, amt);
        assertEq(p.balances(address(this)), amt);
        assertEq(p.totalStaked(), amt);
    }

    function test_RevertStake() public {
        vm.expectRevert();
        uint amt = 10 ether;
        p.stake(amt);
    }

    // receive() external payable {}

    function test_Unstake() public {
        uint amt = 10 ether;
        address user = address(0x1234567890123456789012345678901234567890);

        vm.startPrank(user);
        vm.deal(address(user), amt);
        p.stake{value: amt}(amt);
        p.unstake(amt);
        vm.stopPrank();

        assertEq(p.totalStaked(), 0);
        assertEq(p.balances(address(this)), 0);
        // assertEq(address(this).balance, 0);
    }

}