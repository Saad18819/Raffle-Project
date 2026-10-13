// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {RafflePrac} from "../src/RafflePrac.sol";
import {deployScript} from "../script/DeployScript.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Test} from "forge-std/Test.sol";

contract RaffleTesting is Test{

RafflePrac public raffy;
HelperConfig public helpy;

uint256 public entranceFee;
uint256 public interval;



address public SAAD = makeAddr("KHAN");

function setUp() public{
    deployScript dep = new deployScript();
    (raffy,helpy) = dep.deployLogic();

HelperConfig.Config memory confy = helpy.getConfig();
entranceFee = confy.entranceFee;
interval = confy.interval;
vm.deal(SAAD,10 ether);

}

function testInsuffbalance() public{

vm.prank(SAAD);
raffy.enterRaffle{value:entranceFee}();
assert(SAAD.balance , entranceFee);


}

function testRaffleStateOpenInitially() public{

assert(raffy.getRaffleState() == RafflePrac.raffleState.open);

}


function testPlayersAddingToArray() public{

vm.prank(SAAD);
raffy.enterRaffle{value:entranceFee}();
address user = raffy.s_RafflePlayer(0);
assert(user , SAAD);
}

event enterRaff(address indexed player);

function testEmitEnterRaffle() public{
vm.prank(SAAD);

vm.expectEmit(true,false,false,false,address(raffy));
emit enterRaff(SAAD);

raffy.enterRaffle{value:entranceFee}();
    
}


function testEnterRaffleFailedWhenRaffleStateClosed() public{

vm.prank(SAAD);
raffy.enterRaffle{value:entranceFee}();
vm.warp(block.timestamp + interval + 1);
vm.roll(block.number + 1);

raffy.performUpkeep("");

vm.prank(SAAD);
vm.expectRevert(raffy.raffle_Closed.selector);
raffy.enterRaffle{value:entranceFee}();

}


function testcheckUpkeepisFalseWhenNoBalance() public{

  vm.warp(block.timestamp + interval + 1);
vm.roll(block.number + 1);

(bool upkeep,) = checkUpkeep("");

assert(!upkeep);

}


function testcheckUpKeepisFalseWhenStateClose() public{
    vm.prank(SAAD);
    
}




}
