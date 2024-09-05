//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {vidaNft} from "../src/vidaNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployvidaNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (vidaNft) {
        //if (block.chainid == 31337) {
        //   deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        // } else {
        //     deployerKey = vm.envUint("PRIVATE_KEY");
        // }

        string memory vidaCap = "ipfs://QmV4N5K485w1cGJ6aV7KNJbTQYdt6pqZdTWTfSAjSaG8Sm/?filename=vidaCap.json";
        string memory vidaShoe = "ipfs://QmVpL9v6rngjBJkWo4ahwFqtDB3uye4ZZWp4mJw2fhjUZD/?filename=vida.json";

        /**
         *
         * @param  link path to the svg.
         */
        //string memory vidaShoe = vm.readFile("./img/vidaNft/vidaShoe.svg");
        // string memory vidaCap = vm.readFile("./img/vidaNft/vidaCap.svg");
        //svgToimageUri(vidaShoe);

        vm.startBroadcast();
        vidaNft vidanft = new vidaNft(vidaShoe, vidaCap);
        vm.stopBroadcast();
        return vidanft;
    }

    /**
     *
     * @dev function created to endcode the svg, if provided..
     */
    function svgToimageUri(string memory svg) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));

        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
