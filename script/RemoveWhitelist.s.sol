// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

// import { Script } from "forge-std/Script.sol";
import { BatchScript } from "./helpers/BatchScript.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

interface IAlchemixToken {
    function setWhitelist(address minter, bool state) external;
    function pauseMinter(address minter, bool state) external;
    function setLimits(address _bridge, uint256 _mintingLimit, uint256 _burningLimit) external;
}
contract RemoveWhitelist is BatchScript {
    bool ONLY_SIMULATE = true;
    struct Data {
        Asset[] assets;
        Network[] networks;
    }
    struct Network {
        string name;
        string rpcUrl;
        address safeAddress;
    }
    struct Asset {
        string networkName;
        address token;
        address[] whitelisted;
    }
    function run() public {
        Data memory data = getData();
        for (uint256 i = 0; i < data.networks.length; i++) {
            Network memory network = data.networks[i];
            vm.createSelectFork(network.rpcUrl);
            runOnNetwork(network, data.assets);
        }
    }
    function runOnNetwork(Network memory network, Asset[] memory assets) public isBatch(network.safeAddress) {
        for (uint256 j = 0; j < assets.length; j++) {
            Asset memory asset = assets[j];
            if (Strings.equal(asset.networkName, network.name)) {
                for (uint256 k = 0; k < asset.whitelisted.length; k++) {
                    address whitelisted = asset.whitelisted[k];
                    addToBatch(
                        asset.token,
                        0,
                        abi.encodeWithSelector(IAlchemixToken.setWhitelist.selector, whitelisted, false)
                    );
                    addToBatch(
                        asset.token,
                        0,
                        abi.encodeWithSelector(IAlchemixToken.pauseMinter.selector, whitelisted, false)
                    );
                    addToBatch(
                        asset.token,
                        0,
                        abi.encodeWithSelector(IAlchemixToken.setLimits.selector, whitelisted, 1, 1)
                    );
                }
            }
        }
    
        executeBatch(!ONLY_SIMULATE);
    }
    function getData() public view returns (Data memory) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/removeWhitelist.json");
        string memory json = vm.readFile(path);
        bytes memory jsonBytes = vm.parseJson(json);
        Data memory data = abi.decode(jsonBytes, (Data));
        return data;
    }
}
