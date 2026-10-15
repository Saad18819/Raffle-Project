// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {RafflePrac} from "../src/RafflePrac.sol";
import {deployScript} from "../script/DeployScript.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract RaffleTesting is Test{

RafflePrac public raffy;
HelperConfig public helpy;

uint256 public entranceFee;
uint256 public interval;
address public vrf



address public SAAD = makeAddr("KHAN");

function setUp() public{
    deployScript dep = new deployScript();
    (raffy,helpy) = dep.deployLogic();

HelperConfig.Config memory confy = helpy.getConfig();
entranceFee = confy.entranceFee;
interval = confy.interval;
vrf = confy.vrfCoordinator;
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
    raffy.enterRaffle{value:entranceFee}();

      vm.warp(block.timestamp + interval + 1);
vm.roll(block.number + 1);
raffy.performUpkeep("");

(bool upkeep,) = checkUpkeep("");
assert(!upkeep);
}



function testPerformUpkeepRunsWhenCheckUpKeepTrue() public{
      vm.prank(SAAD);
    raffy.enterRaffle{value:entranceFee}();

      vm.warp(block.timestamp + interval + 1);
vm.roll(block.number + 1);
raffy.performUpkeep("");

}


function testPerformUpkeepRevertWhenCheckUpkeepFalse() public{
  uint256 initial_balance = 0;
  uint256 initial_length = 0;
  vm.prank(SAAD);
   raffy.enterRaffle{value:entranceFee}();
uint256 final_balance = initial_balance + entranceFee;
uint256 final_length = initial_length + 1;
uint256 raffleState = uint256(raffy.getRaffleState());

vm.expectRevert(abi.encodeWithSelector(raffy.raffle_checkUpKeepFailed.selector, final_balance, final_length,raffleState));
raffy.performUpkeep("");


}

function testPerformUpKeepEmitsReqId() public{

  vm.prank(SAAD);
  raffy.enterRaffle{value:entranceFee}();
  vm.warp(block.timestamp + interval + 1);
  vm.roll(block.number + 1);

  vm.recordLogs();
  raffy.performUpkeep("");
  vm.Log[] memory entries = vm.getRecordedLogs();
  bytes32 reqId = entries[1].topics[1];
  assert(uint256(reqId)>0);

}


function testFulfillRandomWordsRevertIfCalledMaliciously(uint256 reqId) public{
  vm.expectRevert(VRFCoordinatorV2_5Mock.InvalidRequest.selector);
  VRFCoordinatorV2_5Mock(vrf).fulfillRandomWords(reqId,address(raffy));
}



function testGiantEndToEnd() public{
  vm.prank(SAAD);
   raffy.enterRaffle{value:entranceFee}();
   vm.warp(block.timestamp + interval + 1);
  vm.roll(block.number + 1);

uint256 startingIndex = 1;
uint256 noOfEntry = 3;

for(uint256 i = startingIndex; i<(noOfEntry+1);i++){
  address players = address(uint160(i));
  hoax(players,5 ether);
raffy.enterRaffle{value:entranceFee}();
}

vm.recordLogs();
raffy.performUpkeep("");
vm.Log[] memory entries = vm.getRecordedLogs();
bytes32 reqId = entries[1].topics[1];

  VRFCoordinatorV2_5Mock(vrf).fulfillRandomWords(uint256(reqId),address(raffy));



}


}
