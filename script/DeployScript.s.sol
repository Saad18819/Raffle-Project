// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RafflePrac} from "../src/RafflePrac.sol";

contract deployScript is Script{

function run() public {
deployLogic();
}

function deployLogic() public{
HelperConfig helper = new HelperConfig();
Config memory config = helper.localConfig;

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
}
// uint256 entranceFee, uint256 interval ,bytes32 gasLane,uint32 callBackLim , address vrfCoordinator, uint256 subId