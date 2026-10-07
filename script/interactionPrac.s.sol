// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract Subs is Script{

function run() public{}

function createSubConfig() public returns(uint256,address){


   HelperConfig helper = new HelperConfig();
   Config config = helper.Config;
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