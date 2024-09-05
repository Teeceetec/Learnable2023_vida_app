
# VIDA NFT Smart Contract

## Overview

The **VIDA NFT** smart contract is a Solidity-based implementation of the ERC721 standard that allows users to mint Non-Fungible Tokens (NFTs). This contract includes features for dynamically assigning different metadata based on predefined criteria and ensures that each user can only mint one NFT. 

The contract also provides the owner with control over certain functionalities such as updating URIs and toggling the minting state.

## Features

- **Minting NFTs**: Users can mint a unique NFT, subject to certain restrictions.
- **Dynamic Metadata**: Each NFT can either have a "VIDAShoe" or "VIDACap" metadata URI based on the token ID.
- **Minting Limits**: The total number of NFTs that can be minted is capped at 500, and each user can mint only once.
- **Pause/Resume Minting**: The contract owner can pause and resume the minting process.
- **Access Control**: Ownership restrictions are applied to sensitive functions, ensuring only the owner can update important state variables.

## Contract Details

- **Contract Name**: VIDA NFT
- **Symbol**: VD
- **License**: UNLICENSED
- **Solidity Version**: ^0.8.25
- **Author**: Tochukwu Onyia

## Smart Contract Components

### Structs & Enums

- **Vidaswitch**: Enum representing two types of NFTs:
  - `VIDASHOE`
  - `VIDACAP`

### Mappings

- `mapping(uint256 id => address users) public s_nftaddress;`: Maps the token ID to the owner address.
- `mapping(uint256 id => Vidaswitch) public s_vidaswitch;`: Maps token ID to the type of NFT (`VIDASHOE` or `VIDACAP`).
- `mapping(address => bool) public s_hasMinted;`: Tracks whether a user has already minted an NFT.

### State Variables

- `uint16 private s_magicNumber = 250;`: Determines the token ID threshold for switching between `VIDASHOE` and `VIDACAP`.
- `uint256 public s_maxTokenId = 500;`: The maximum number of NFTs that can be minted.
- `bool private paused;`: Tracks whether the minting process is paused or active.
- `uint256 public i_tokenCounter;`: Tracks the total number of minted NFTs.
- `string private i_vidaCapUri;`: URI for the "VIDACap" NFTs.
- `string private i_vidaShoeUri;`: URI for the "VIDAShoe" NFTs.

## Events

- **`CreatedNft(uint256 id)`**: Emitted when a new NFT is minted.

## Functions

### Public Functions

1. **`mint()`**: 
   - Mints an NFT to the caller's address. Checks if the user has already minted and whether the minting limit has been reached.
   - **Errors**:
     - `Exceeded_Number_Of_Entries`: If the total minted NFTs exceed the maximum token ID.
     - `YOU_HAVE_MINTED_THE_NFT_ALREADY`: If the user has already minted an NFT.
     - `MINTING_IS_PAUSED`: If minting is currently paused.
     
2. **`tokenURI(uint256 tokenId)`**: 
   - Returns the metadata URI for a given token ID, either `i_vidaShoeUri` or `i_vidaCapUri` depending on the token ID.

3. **`getUserAddress(uint256 tokenId)`**: 
   - Returns the owner's address for a specific token ID.

4. **`getMintStat(address user)`**: 
   - Returns whether a user has already minted an NFT.

### Owner-Only Functions

1. **`setTokenCounter(uint256 counter)`**: 
   - Allows the owner to manually set the token counter.
   
2. **`setCapURI(string memory _newURI)`**: 
   - Updates the URI for "VIDACap" NFTs.

3. **`setShoeURI(string memory _newURI)`**: 
   - Updates the URI for "VIDAShoe" NFTs.

4. **`togglePause()`**: 
   - Pauses or resumes the minting process.

## Deployment & Setup

### Prerequisites

- A Solidity development environment like Hardhat, Truffle, or Remix.
- Access to OpenZeppelin's ERC721, Ownable, and utility libraries.

### Steps

1. **Contract Deployment**:
   - Deploy the `vidaNft` contract, providing the URIs for `VIDAShoe` and `VIDACap` NFTs in the constructor.
   
   ```solidity
   constructor(string memory vidaShoeUri, string memory vidaCapUri) ERC721("VIDANFT", "VD") {
       i_vidaShoeUri = vidaShoeUri;
       i_vidaCapUri = vidaCapUri;
       i_tokenCounter = 0;
   }


   
   
   # VIDA ERC20 Token Contract

## Overview

The **VIDA Token** contract is an ERC20-compatible smart contract that allows the contract owner to mint tokens, transfer them, and reward users for completing tasks. The contract includes various functionalities such as minting tokens, managing balances, transferring tokens, and claiming rewards. This contract also introduces several security checks to ensure proper access control and prevent unauthorized transfers.

## Features

- **Minting Tokens**: The contract owner can mint additional tokens to the total supply.
- **Reward Mechanism**: Users can claim a predefined amount of tokens as a reward for completing tasks.
- **Token Transfers**: Users can transfer tokens between addresses.
- **Burning Tokens**: The contract allows burning (destroying) tokens, reducing the total supply.
- **Allowance Mechanism**: Implements basic ERC20 allowance features for token approvals.
- **Access Control**: Sensitive functions like minting and setting the reward amount are restricted to the contract owner.

## Contract Details

- **Contract Name**: `vidaToken`
- **License**: UNLICENSED
- **Solidity Version**: ^0.8.25
- **Author**: Tochukwu Onyia

## Smart Contract Components

### Mappings

- `mapping(address user => uint256 amount) private userbalance;`: Tracks balances of users claiming rewards.
- `mapping(address => uint256) private balances;`: Tracks token balances of each user.
- `mapping(address => mapping(address => uint256)) private allowance;`: Tracks approved allowances for token transfers.

### State Variables

- `string private s_name;`: The token's name.
- `string private s_symbol;`: The token's symbol.
- `uint8 private s_decimals;`: Number of decimal places for the token (usually 18 for ERC20 tokens).
- `uint256 private s_totalSupply;`: Total supply of tokens in circulation.
- `address public s_owner;`: The owner of the contract.
- `uint256 private s_rewardamount = 2000;`: Default reward amount that users receive after completing a task.

## Events

- **`Transfer(address indexed from, address indexed to, uint256 value)`**: Emitted when tokens are transferred from one account to another.
- **`Approval(address indexed owner, address spender, uint256 value)`**: Emitted when an allowance is set for token transfers.

## Modifiers

- **`error INSUFFICIENT_BALANCE()`**: Thrown when a user tries to transfer more tokens than they have.
- **`error ERC20InvalidReceiver()`**: Thrown when a transfer is attempted to the zero address.
- **`error ERC20InvalidSender()`**: Thrown when a transfer is attempted from the zero address.
- **`error NOT_THE_OWNER()`**: Thrown when a non-owner tries to call restricted functions.

## Functions

### Public Functions

1. **`claimToken()`**:
   - Allows users to claim a reward of 2000 tokens.
   - Transfers tokens from the owner to the user.
   - **Errors**:
     - `INSUFFICIENT_BALANCE`: If the owner's balance is insufficient for the reward transfer.
   
2. **`transferfrom(address from, address to, uint256 value)`**:
   - Transfers `value` amount of tokens from `from` to `to`.
   - **Errors**:
     - `ERC20InvalidSender`: If `from` is the zero address.
     - `ERC20InvalidReceiver`: If `to` is the zero address.
   
3. **`mint()`**:
   - Mints 70,000,000 tokens and adds them to the owner's balance.
   - **Errors**:
     - `NOT_THE_OWNER`: If the caller is not the contract owner.

4. **`approve(address _spender, uint256 _value)`**:
   - Approves another address to spend `_value` tokens on behalf of the caller.

### Internal Functions

1. **`_update(address from, address to, uint256 value)`**:
   - Internal function that handles updating balances during transfers or mints/burns.
   - **Errors**:
     - `INSUFFICIENT_BALANCE`: If `from` does not have enough tokens for the transfer.

2. **`_transfer(address from, address to, uint256 value)`**:
   - Handles token transfers and emits the `Transfer` event.
   - **Errors**:
     - `ERC20InvalidSender`: If `from` is the zero address.
     - `ERC20InvalidReceiver`: If `to` is the zero address.

3. **`_mint(address account, uint256 value)`**:
   - Mints `value` tokens and assigns them to the `account`.
   - **Errors**:
     - `ERC20InvalidReceiver`: If `account` is the zero address.

4. **`burn(address account, uint256 value)`**:
   - Burns `value` tokens from `account`, reducing the total supply.
   - **Errors**:
     - `ERC20InvalidSender`: If `account` is the zero address.

### Owner-Only Functions

1. **`setRewardAmount(uint256 _amount)`**:
   - Updates the reward amount for the `claimToken` function.
   - **Errors**:
     - `NOT_THE_OWNER`: If the caller is not the contract owner.

### Getter Functions

1. **`getTotalSupply()`**:
   - Returns the total supply of tokens in circulation.

2. **`getBalanceof(address user)`**:
   - Returns the token balance of a specific `user`.

3. **`getName()`**:
   - Returns the name of the ERC20 token.

4. **`getSymbol()`**:
   - Returns the symbol of the ERC20 token.

5. **`getDecimals()`**:
   - Returns the number of decimals for the ERC20 token.

6. **`getUserBalances(address user)`**:
   - Returns the reward balance of a specific `user`.

7. **`getRewardAmount()`**:
   - Returns the current reward amount.

## Deployment & Setup

### Prerequisites

- A Solidity development environment (e.g., Hardhat, Truffle, Remix).
- Install OpenZeppelin ERC20 libraries for industry-standard token functionalities.

### Steps for Deployment

1. **Deploy the `vidaToken` contract**:
   - The constructor requires the token name, symbol, decimals, and the initial supply to be provided.

   ```solidity
   constructor(string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) {
       // Initialization logic
   }



# VIDA_REVIEWS_AND_FEEDBACK Smart Contract

## Overview
The VIDA smart contract is a Solidity-based implementation that extends the functionality of the `vidaToken` contract. It provides a system for submitting, managing, and retrieving reviews, along with token distribution mechanisms.

### Features
- Review submission with ratings and comments
- Review retrieval and management
- User review tracking
- Token distribution for reviewers

## Contract Details

- **License**: UNLICENSED
- **Solidity Version**: ^0.8.25
- **Author**: Tochukwu Onyia

## Main Components

### Structs
- **Review**: Represents a user review with fields for user address, comment, rating, and timestamp.

### Mappings
- **reviews**: Stores `Review` structs indexed by review ID.
- **hasReviewed**: Tracks whether an address has submitted a review.
- **userReviewsCount**: Counts the number of reviews submitted by each user.
- **hasReceievdToken**: Tracks token distribution to reviewers.
- **addressList**: Purpose not clear from the provided code.

### State Variables
- **i_reviewCount**: Tracks the total number of reviews submitted.
- **s_reviewSubmitted**: Boolean flag indicating if a review has been submitted.

### Events
- **ReviewSubmitted**: Emitted when a new review is submitted.

## Main Functions

### `submitReview`
Allows users to submit a review with a comment and rating.

**Parameters**:
- `_comment`: The review comment (string).
- `_ratings`: The review rating (uint8, 1-5).

**Constraints**:
- Rating must be between 1 and 5.
- Comment length must be less than 1000 characters.

### `getReviews`
Retrieves a review by its ID.

### `getReviewById`
Returns detailed information about a review by its ID.

### `getRatingCount`
Returns the number of ratings submitted by a specific user.

### `deleteReview`
Allows the contract owner to delete a review.

### `getAddressList`
Returns a value associated with a user address from the `addressList` mapping.

### `getReviewSubmittedStatus`
Checks if a user has submitted a review.

### `getReviewSubmitted`
Returns the value of `s_reviewSubmitted`.

### `getReviewCount`
Returns the total number of reviews submitted.

## Inheritance
This contract inherits from `vidaToken`, extending its functionality with review-related features.

## Setup and Deployment
The contract constructor takes the following parameters:
- `_name`: Token name
- `symbol`: Token symbol
- `decimals`: Number of decimal places for the token
- `_initialSupply`: Initial token supply

These parameters are passed to the `vidaToken` constructor.

## Security Considerations
- The contract uses access control for certain functions (e.g., `deleteReview` is restricted to the contract owner).
- Input validation is implemented for review submissions to prevent invalid ratings or excessively long comments.

## Development and Testing
To work with this contract:
1. Ensure you have a Solidity development environment set up (e.g., Truffle, Hardhat, Foundry).
2. Deploy the `vidaToken` contract first, as it is a dependency.
3. Deploy the `vida` contract, providing the necessary constructor parameters.
4. Interact with the contract using a web3 library or through a blockchain explorer.


## License
This project is currently unlicensed. Please contact the author for permission before using or distributing this code.

For more information or inquiries, please contact the author, Tochukwu Onyia.


vidanft address:    0x774Fe69EC937FbB5b9319b8f11fAf49A79a82Bf9;
vidaToken address:  0x605F7e437eDdAc4522b57869441Fc545F4129594;
