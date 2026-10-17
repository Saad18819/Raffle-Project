// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig,DataConstant} from "./HelperConfig.s.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract Subs is Script{

function run() public returns(uint256,address){

return createSubConfig();

}

function createSubConfig() public returns(uint256,address){


   HelperConfig helper = new HelperConfig();
  HelperConfig.Config memory config = helper.getConfig();
   address vrf = config.vrfCoordinator;
   return createSubLogic(vrf);

}

function createSubLogic(address vrfCoordinator) public returns(uint256,address){

vm.startBroadcast();
uint256 SubId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
vm.stopBroadcast();
return (SubId , vrfCoordinator);
}



}



contract FundSubs is Script,DataConstant{

uint256 public constant FUND_AMOUNT = 3 ether;

function run() public{

   fundconfig();

}



function fundconfig() public{

HelperConfig helperconfi = new HelperConfig();
HelperConfig.Config memory config = helperconfi.getConfig();
address vrf = config.vrfCoordinator;
address link = config.linktoken;
uint256 sub = config.subId;

createFundLogic(vrf,sub,link);

}

   function createFundLogic(address vrfCoordinator , uint256 subId , address linktoken) public{
if(block.chainid == LOCAL_CHAIN_ID){

   vm.startBroadcast();
   VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(subId,FUND_AMOUNT*100);
vm.stopBroadcast();

}
else{

   vm.startBroadcast();
   LinkToken(linktoken).transferAndCall(vrfCoordinator, FUND_AMOUNT ,abi.encode(subId));
  vm.stopBroadcast();
}
   }





   }


contract consumerAdd is Script{


   function run() public{
   address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("RafflePrac",block.chainid);
   consumerConfig(mostRecentDeployed);
   }

  function consumerConfig(address contractConsumer) public{
    HelperConfig helperconfi = new HelperConfig();
HelperConfig.Config memory config = helperconfi.getConfig();
address vrf = config.vrfCoordinator;
uint256 sub = config.subId;
consumerLogic(vrf,sub,contractConsumer);
   }


   function consumerLogic(address vrf , uint256 sub ,address contractConsumer) public{
      vm.startBroadcast();
       VRFCoordinatorV2_5Mock(vrf).addConsumer( sub, contractConsumer);
  vm.stopBroadcast();
   }

}





