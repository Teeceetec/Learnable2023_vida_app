// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {vida} from "../src/vida.sol";
import {Deployvida} from "../script/DeployvidaToken.s.sol";

contract vidaTokenTest is Test {
    /*//////////////////////////////////////////////////////////////
                           VARIABLE STATES 
    //////////////////////////////////////////////////////////////*/
    string constant TOKEN_NAME = "vida";
    string constant TOKEN_SYMBOL = "VD";
    uint256 constant AMOUNT = 5000 * 10 ** 18;
    uint8 constant DECIMALS = 18;
    uint256 constant TOTAL_SUPPLY = 70000000;
    address public USER1 = makeAddr("user1");
    address public USER2 = makeAddr("user2");
    address public USER3 = makeAddr("user3");
    uint256 public constant STARTING_USERBALANCE = 1000000 ether;
    uint256 public id = 1;
    uint256 public i_d = 2;
    string public reviews = "Nice app, worth 5 star rating";
    uint8 public rating_score = 4;

    /*//////////////////////////////////////////////////////////////
                           INTERFACE
    //////////////////////////////////////////////////////////////*/

    vida public vidatoken;
    Deployvida public deployer;

    function setUp() public {
        deployer = new Deployvida();
        vidatoken = deployer.run();

        vm.deal(USER1, STARTING_USERBALANCE);
    }

    function testNameIsCorrect() public view {
        assert(keccak256(abi.encodePacked(TOKEN_NAME)) == keccak256(abi.encodePacked(vidatoken.getName())));

        console.log("TEST_NAME", TOKEN_NAME);
        console.log("CONTRACT_NAME", vidatoken.getName());
    }

    function testSymbol() public view {
        assert(keccak256(abi.encodePacked(TOKEN_SYMBOL)) == keccak256(abi.encodePacked(vidatoken.getSymbol())));
        console.log("CONTRACT_SYMBOL", vidatoken.getSymbol());
        console.log("TEST_SYMBOL", TOKEN_SYMBOL);
    }

    function testDecimals() public view {
        assert(vidatoken.getDecimals() == DECIMALS);
        console.log("TEST_DECIMALS", DECIMALS);
        console.log("CONTRACT_DECIMALS", vidatoken.getDecimals());
    }

    function testTokenM() public {
        vm.startPrank(msg.sender);
        vidatoken.mint();
        vm.stopPrank();

        assert(vidatoken.getBalanceof(msg.sender) == vidatoken.getTotalSupply());
        console.log("USER_BALANCE", vidatoken.getBalanceof(msg.sender));
    }

    function testConstructorAggs() public {
        vm.startBroadcast();
        vidatoken = new vida(TOKEN_NAME, TOKEN_SYMBOL, DECIMALS, TOTAL_SUPPLY);
        vm.stopBroadcast();
    }

    function testClaimToken() public {
        uint256 amount = 2000;
        vm.startPrank(USER2);
        uint256 initialBalance = vidatoken.getBalanceof(USER2);
        vidatoken.claimToken();
        uint256 newBalance = vidatoken.getBalanceof(USER2);

        assertEq(newBalance, initialBalance + newBalance);
        assertEq(newBalance, amount);
        console.log("USER2_BALANCE", vidatoken.getBalanceof(USER2));
    }

    function testTransferFromTokens() public {
        uint256 amount = 10000;
        vm.startPrank(msg.sender);
        vidatoken.mint();
        vidatoken.transferfrom(msg.sender, USER2, amount);

        vm.stopPrank();

        assert(vidatoken.getBalanceof(USER2) == amount);

        console.log("USER2_BALANCE", vidatoken.getBalanceof(USER2));
    }

    function testSubmitReviewRevert() public {
        vm.startPrank(USER1);
        vm.expectRevert();
        vidatoken.submitReview(reviews, 0);

        vm.stopPrank();
    }

    function testSubmitReviewRevert2() public {
        vm.startPrank(USER1);
        vm.expectRevert();

        vidatoken.submitReview(reviews, 6);
        vm.stopPrank();
    }

    function testPu() public {
        vm.startPrank(msg.sender);
        vidatoken.mint();
        vm.stopPrank();

        vm.prank(USER1);
        vidatoken.submitReview(reviews, 4);
        uint256 reviewed = vidatoken.userReviewsCount(USER1);

        (address user, string memory comment, uint256 ratings, uint256 timestamp) = vidatoken.getReviewById(0);

        assert(USER1 == user);
        assert(keccak256(abi.encodePacked(comment)) == keccak256(abi.encodePacked(reviews)));
        assert(ratings == 4);
        assert(timestamp == block.timestamp);
        assertEq(reviewed, 0);
    }

    function testsetReward() public {
        vm.prank(msg.sender);
        vidatoken.setRewardAmount(5000);

        uint256 newprice = vidatoken.getRewardAmount();

        assert(newprice == 5000);
    }

    function testDeleteReviews() public {
        vm.startPrank(msg.sender);
        vidatoken.mint();
        vm.stopPrank();

        vm.prank(USER1);
        vidatoken.submitReview(reviews, 4);

        vm.prank(msg.sender);
        vidatoken.deleteReview(0);
    }
}
