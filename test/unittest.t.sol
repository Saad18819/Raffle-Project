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
    
}


}
