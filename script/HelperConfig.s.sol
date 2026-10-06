// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{

    struct Config{
        uint256 entranceFee;
         uint256 interval;
         bytes32 gasLane;
         uint32 callBackLim ; 
         address vrfCoordinator;
         uint256 subId
    }
    Config private localConfig;

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

   function getSepolia() public view returns(memory Config){
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

    function getAnvil() public view returns(memory Config){
        
    }
}
