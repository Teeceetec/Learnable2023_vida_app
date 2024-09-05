// SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DeployvidaNft} from "../script/DeployvidaNft.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {vidaNft} from "../src/vidaNft.sol";

contract vidaNftTest is Test {
    string constant NFT_NAME = "VIDANFT";
    string constant NFT_SYMBOL = "VD";
    vidaNft public vidanft;
    DeployvidaNft public deployer;
    address public deployerAddress;
    bool mint = true;

    string constant VIDA_CAP = "ipfs://QmV4N5K485w1cGJ6aV7KNJbTQYdt6pqZdTWTfSAjSaG8Sm/?filename=vidaCap.json0";
    string constant VIDA_SHOE = "ipfs://QmVpL9v6rngjBJkWo4ahwFqtDB3uye4ZZWp4mJw2fhjUZD/?filename=vida.json0";

    address public USER1 = makeAddr("USER1");
    uint256 public AMOUNT; //10000 ether;

    function setUp() public {
        deployer = new DeployvidaNft();
        vidanft = deployer.run();
        vm.deal(USER1, AMOUNT);
    }

    function testNftName() public view {
        assert(keccak256(abi.encodePacked(NFT_NAME)) == keccak256(abi.encodePacked(vidanft.name())));
        console.log("TESTING_NAME", NFT_NAME);
        console.log("CONTRACT_NAME", vidanft.name());
    }

    function testNftSymbol() public view {
        assert(keccak256(abi.encodePacked(NFT_SYMBOL)) == keccak256(abi.encodePacked(vidanft.symbol())));

        console.log("TESTING_SYMBOL", NFT_SYMBOL);
        console.log("CONTRACT_SYMBOL", vidanft.symbol());
    }

    function testMintingReverts() public {
        vm.startPrank(USER1);
        vidanft.setTokenCounter(vidanft.s_maxTokenId() + 1);
        vm.expectRevert(vidaNft.Exceeded_Number_Of_Entries.selector);
        vidanft.mint();

        vm.stopPrank();
    }

    function testMinted() public {
        //Arrange
        uint256 inititialTokenCounter = vidanft.i_tokenCounter();

        //Acts
        vm.startPrank(USER1);
        vidanft.mint();
        vm.stopPrank();

        uint256 newtokenCounter = vidanft.i_tokenCounter();

        //Asserts
        assert(newtokenCounter == inititialTokenCounter + 1);
        assert(keccak256(abi.encodePacked(vidanft.tokenURI(0))) == keccak256(abi.encodePacked(VIDA_SHOE)));

        assert(vidanft.s_vidaswitch(newtokenCounter) == vidaNft.Vidaswitch.VIDASHOE);
    }

    // function testSetMint() public {
    //  vm.prank(USER1);
    //vidanft.setMint(mint);

    //bool stat = vidanft.getMintStat();

    //assertTrue(stat);
    //}

    function testSetTokenCounter() public {
        vm.prank(USER1);
        vidanft.setTokenCounter(500);

        uint256 count = vidanft.getTokenCounter();

        assertEq(count, 500);
    }

    function testMaxTokenId() public {
        vm.prank(USER1);
        uint256 token = vidanft.getMaxTokenId();

        assertEq(token, 500);
    }

    function testflipMode() public {
        uint256 magic = 250;
        vm.startPrank(USER1);

        vidanft.mint();
        uint256 counter = vidanft.getTokenCounter();
        vidanft.setTokenCounter(magic);

        vidanft._flipMode(counter);
        vidanft.tokenURI(0);
        vm.stopPrank();

        //assert(keccak256(abi.encodePacked(vidanft.tokenURI(0))) == keccak256(abi.encodePacked(VIDA_CAP_URI)));
    }
}
