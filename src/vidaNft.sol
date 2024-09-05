// SPDX-License-Identifier: UNLICENSED

/**
 * @title vida contract: This contract allows the owner to mint an Erc20 , transfer it to the contract and reward it to users after completing each task.
 * @author Tochukwu Onyia
 * @notice this contract is for Erc20 Minting!!.
 *
 *
 */

/**
 * Imports from openzeppelin contracts
 */
pragma solidity ^0.8.25;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract vidaNft is ERC721, Ownable(msg.sender) {
    using Strings for uint256;
    /*//////////////////////////////////////////////////////////////
                           ERRORS
    //////////////////////////////////////////////////////////////*/

    error ERC721Metadata_URI_QueryFor_NonExistenToken();
    error Exceeded_Number_Of_Entries();
    error YOU_HAVE_MINTED_THE_NFT_ALREADY();
    error MINTING_IS_PAUSED();

    /*//////////////////////////////////////////////////////////////
                           TYPE DATA
     //////////////////////////////////////////////////////////////*/

    enum Vidaswitch {
        VIDASHOE,
        VIDACAP
    }

    mapping(uint256 id => address users) public s_nftaddress;

    mapping(uint256 id => Vidaswitch) public s_vidaswitch;

    mapping(address => bool) public s_hasMinted;

    event CreatedNft(uint256 id);

    /*//////////////////////////////////////////////////////////////
                           URI
    //////////////////////////////////////////////////////////////*/
    string private i_vidaCapUri;
    string private i_vidaShoeUri;

    /**
     * ID
     */
    uint256 public i_tokenCounter;

    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
     //////////////////////////////////////////////////////////////*/
    uint16 private s_magicNumber = 250;
    uint256 public s_maxTokenId = 500;

    bool private paused;

    constructor(string memory vidaShoeUri, string memory vidaCapUri) ERC721("VIDANFT", "VD") {
        i_vidaShoeUri = vidaShoeUri;
        i_vidaCapUri = vidaCapUri;
        i_tokenCounter = 0;
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    function mint() public {
        if (i_tokenCounter > s_maxTokenId) {
            revert Exceeded_Number_Of_Entries();
        }

        if (s_hasMinted[msg.sender]) {
            revert YOU_HAVE_MINTED_THE_NFT_ALREADY();
        }

        uint256 tokenCounter = i_tokenCounter;
        _safeMint(msg.sender, tokenCounter);

        s_vidaswitch[tokenCounter] = Vidaswitch.VIDACAP;
        s_nftaddress[tokenCounter] = msg.sender;
        s_hasMinted[msg.sender] = true;

        i_tokenCounter++;

        //_flipMode(tokenCounter);
        emit CreatedNft(tokenCounter);
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata_URI_QueryFor_NonExistenToken();
        }

        string memory baseURI = tokenId <= s_magicNumber ? i_vidaShoeUri : i_vidaCapUri;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _flipMode(uint256 tokenId) public {
        for (uint256 i = 0; i < i_tokenCounter; i++) {
            if (i_tokenCounter > s_magicNumber) {
                s_vidaswitch[tokenId] = Vidaswitch.VIDACAP;
            } else {
                s_vidaswitch[tokenId] = Vidaswitch.VIDASHOE;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                           SETTER  FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    function setTokenCounter(uint256 counter) public {
        i_tokenCounter = counter;
    }

    function setCapURI1(string memory _newURI) public onlyOwner {
        i_vidaCapUri = _newURI;
    }

    function setShoeURI(string memory _newURI) public onlyOwner {
        i_vidaShoeUri = _newURI;
    }

    function togglePause() public onlyOwner {
        paused = !paused;
    }

    /*//////////////////////////////////////////////////////////////
                           GETTER FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    function getvidaCapUri() external view returns (string memory) {
        return i_vidaCapUri;
    }

    function getvidaPoloUri() external view returns (string memory) {
        return i_vidaShoeUri;
    }

    function getTokenCounter() external view returns (uint256) {
        return i_tokenCounter;
    }

    /**
     * this function is used to get the total number of NFT ID
     */
    function getMaxTokenId() external view returns (uint256) {
        return s_maxTokenId;
    }

    /**
     *
     */
    function getMagicNumber() external view returns (uint256) {
        return s_magicNumber;
    }

    /**
     * This function return the addresses of users by thier NFT ID..
     */
    function getUserAddress(uint256 tokenId) external view returns (address) {
        return s_nftaddress[tokenId];
    }

    function getMintStat(address user) external view returns (bool) {
        return s_hasMinted[user];
    }
}
