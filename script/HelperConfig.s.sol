// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

/*
  uint96 _baseFee,
    uint96 _gasPrice,
    int256 _weiPerUnitLink

    */

   abstract contract DataConstant{
     uint96 constant BASE_FEE = 0.25 ether;
    uint96 constant GAS_PRICE = 1e9 wei;
    int256 constant WEI_PER_UNIT_LINK = 4e15;
uint256 constant SEPOLIA_CHAINID = 11155111;
uint256 constant MAINNET_CHAINID = 1;
uint256 public constant LOCAL_CHAIN_ID = 31337;
   }

contract HelperConfig is DataConstant, Script{

error invalid_CHAINID();

    struct Config{
        uint256 entranceFee;
         uint256 interval;
         bytes32 gasLane;
         uint32 callBackLim ; 
         address vrfCoordinator;
         uint256 subId
    }

    Config private localConfig;


mapping(uint256 chainId => Config config) public networkConfig;

constructor() {
    if (block.chainid == SEPOLIA_CHAINID) {
        networkConfigs[SEPOLIA_CHAINID] = getSepoliaEthConfig();
    } else if (block.chainid == MAINNET_CHAINID) {
        networkConfigs[MAINNET_CHAINID] = getMainnetEthConfig();
    }
}


function getConfigByChainId(uint256 chainId) public view returns(memory Config){
if(networkConfig[chainId].vrfCoordinator != address(0)){
    return networkConfig[chainId];
}
else if(chainId ==LOCAL_CHAIN_ID){
    return getAnvil();
}else{
revert invalid_CHAINID();
}
}

function getConfig() public returns(memory Config){
    return getConfigByChainId(block.chainid);
}


    function getSepolia() public view returns(memory Config){
        localConfig = Config({
      entranceFee:5 ether,
interval:30,
gasLane:0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
callBackLim:5000,
vrfCoordinator:0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
subId:0
        });
        return localConfig;
    }

   function getMainnet() public view returns(memory Config){
        localConfig = Config({
      entranceFee:5 ether,
interval:30,
gasLane:0x88d615f702f69213554d32e012e8e97a221f153ee0d3ea089ea4a3b75a1c0d4a,
callBackLim:5000,
vrfCoordinator:0xd7f86b4b8cae7d942340ff628f82735b7a20893a,
subId:0
        });
        return localConfig;
    } 

    function getAnvil(uint256 chainId) public view returns(memory Config){

if(networkConfig[chainId].vrfCoordinator != address(0)){
    return networkConfig[chainId];
}

vm.startBroadcast();
VRFCoordinatorV2_5Mock mock = new VRFCoordinatorV2_5Mock(BASE_FEE, GAS_PRICE, WEI_PER_UNIT_LINK);
vm.stopBroadcast();

 localConfig = Config({
      entranceFee:5 ether,
interval:30,
gasLane:0x88d615f702f69213554d32e012e8e97a221f153ee0d3ea089ea4a3b75a1c0d4a,
callBackLim:5000,
vrfCoordinator:address(mock),
subId:0
        });
        return localConfig;


    }
}
