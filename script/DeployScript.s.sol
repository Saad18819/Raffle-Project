// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RafflePrac} from "../src/RafflePrac.sol";
import {Subs,FundSubs,consumerAdd} from "./interactionPrac.s.sol";

contract deployScript is Script{

function run() public {
deployLogic();
}

function deployLogic() public{
HelperConfig helper = new HelperConfig();
Config memory config = helper.localConfig;

if(config.subId == 0){
    Subs subid = new Subs();
  (config.subId ,config.vrfCoordinator) = subid.createSubConfig();

  FundSubs fundySub = new FundSubs();
fundySub.fundconfig();

}

vm.startBroadcast();
RafflePrac raffy = new RafflePrac(
config.entranceFee,
config.interval
config.gasLane
config.callBackLim
config.vrfCoordinator
config.subId
);
vm.stopBroadcast();
}

consumerAdd consume = new consumerAdd();
consume.consumerConfig(address(raffy));



}
// uint256 entranceFee, uint256 interval ,bytes32 gasLane,uint32 callBackLim , address vrfCoordinator, uint256 subId