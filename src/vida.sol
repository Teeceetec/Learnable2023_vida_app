// SPDX-License-Identifier: UNLICENSED

/**
 * @author Tochukwu Onyia
 *
 *
 */
pragma solidity ^0.8.25;

import {vidaToken} from "./vidaToken.sol";

contract vida is vidaToken {
    /*//////////////////////////////////////////////////////////////
                           ERRORS
    //////////////////////////////////////////////////////////////*/
    error YOUR_RATING_IS_TOO_LOW();
    error YOUR_RATING_SHOULD_NOT_EXCEED_FIVE();
    error COMMENT_TOO_LARGE();
    error REVIEW_DOES_NOT_EXIST();

    /*//////////////////////////////////////////////////////////////
                           Type declarations
    //////////////////////////////////////////////////////////////*/

    struct Review {
        address user;
        string comment;
        uint256 ratings;
        uint256 timestamp;
    }

    mapping(uint256 => Review) private reviews;
    mapping(address => bool) private hasReviewed;
    mapping(address => uint256) public userReviewsCount;
    mapping(address => bool) private hasReceievdToken;
    mapping(address => uint256) private addressList;

    /*//////////////////////////////////////////////////////////////
                           State variables
    //////////////////////////////////////////////////////////////*/

    uint256 public i_reviewCount;
    bool private s_reviewSubmitted;

    /*//////////////////////////////////////////////////////////////
                           Events
    //////////////////////////////////////////////////////////////*/

    event ReviewSubmitted(address indexed user, uint256 ratings, uint256 timestamp);

    constructor(string memory _name, string memory symbol, uint8 decimals, uint256 _initialSupply)
        vidaToken(_name, symbol, decimals, _initialSupply)
    {
        i_reviewCount = 0;
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function submitReview(string calldata _comment, uint8 _ratings) public {
        if (_ratings < 1 || _ratings > 5) {
            revert(_ratings < 1 ? "RATING_TOO_LOW" : "RATING_TOO_HIGH");
        }

        uint256 commentLength = bytes(_comment).length;
        if (commentLength >= 1000) {
            revert("COMMENT_TOO_LARGE");
        }

        uint256 reviewId = i_reviewCount;
        unchecked {
            ++i_reviewCount;
        }

        reviews[reviewId] = Review({user: msg.sender, comment: _comment, ratings: _ratings, timestamp: block.timestamp});

        hasReviewed[msg.sender] = true;
        userReviewsCount[msg.sender] = reviewId;

        emit ReviewSubmitted(msg.sender, _ratings, block.timestamp);
    }

    /*//////////////////////////////////////////////////////////////
                           GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getReviews(uint256 id) external view returns (Review memory) {
        return reviews[id];
    }

    function getReviewById(uint256 id)
        external
        view
        returns (address user, string memory comment, uint256 ratings, uint256 timestamp)
    {
        Review storage review = reviews[id];
        return (review.user, review.comment, review.ratings, review.timestamp);
    }

    function getRatingCount(address _user) external view returns (uint256 rating) {
        return userReviewsCount[_user];
    }

    function deleteReview(uint256 id) external {
        if (s_owner != msg.sender) {
            revert NOT_THE_OWNER();
        }

        Review storage review = reviews[id];
        if (review.user == address(0)) {
            revert REVIEW_DOES_NOT_EXIST();
        }

        delete hasReviewed[review.user];

        delete reviews[id];
    }

    function getAddressList(address user) external view returns (uint256) {
        return addressList[user];
    }

    function getReviewSubmittedStatus(address user) external view returns (bool) {
        return hasReviewed[user];
    }

    function getReviewSubmitted() external view returns (bool) {
        return s_reviewSubmitted;
    }

    function getReviewCount() external view returns (uint256) {
        return i_reviewCount;
    }
}
