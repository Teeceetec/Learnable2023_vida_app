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

/*//////////////////////////////////////////////////////////////
                           Imports
    //////////////////////////////////////////////////////////////*/

contract vidaToken {
    /*//////////////////////////////////////////////////////////////
                           ERRORS
    //////////////////////////////////////////////////////////////*/

    error INSUFFICIENT_BALANCE();
    error ERC20InvalidReceiver();
    error ERC20InvalidSender();
    error NOT_THE_OWNER();

    /*//////////////////////////////////////////////////////////////
                           Type declarations
    //////////////////////////////////////////////////////////////*/

    mapping(address user => uint256 amount) private userbalance;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowance;

    /*//////////////////////////////////////////////////////////////
                           State variables
    //////////////////////////////////////////////////////////////*/

    string private s_name;
    string private s_symbol;
    uint8 private s_decimals;
    uint256 private s_totalSupply;
    address public s_owner;
    uint256 private s_rewardamount = 2000;

    /*//////////////////////////////////////////////////////////////
                           Events
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexedowner, address spender, uint256 value);
    /*//////////////////////////////////////////////////////////////
                           Modifiers
    //////////////////////////////////////////////////////////////*/

    constructor(string memory name, string memory symbol, uint8 decimals, uint256 initialSuply) {
        s_name = name;
        s_symbol = symbol;
        s_decimals = decimals;
        s_totalSupply = initialSuply * 10 * uint256(decimals);
        s_owner = msg.sender;

        balances[msg.sender] = s_totalSupply;

        _mint(msg.sender, s_totalSupply);
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Moves 'value' amount oof tokens from the caller's account to the user
     *
     * Returns a boolean value indicating wheteher the operation succeeded
     *
     * Emits {Transfer} event.
     */
    function claimToken() public returns (bool) {
        //require(s_totalSupply > 0, "No tokens available to claim");

        uint256 rewardAmount = s_rewardamount;
        userbalance[msg.sender] += rewardAmount;

        _transfer(s_owner, msg.sender, rewardAmount);

        return true;
    }

    function transferfrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);

        return true;
    }

    function mint() public {
        if (s_owner != msg.sender) {
            revert NOT_THE_OWNER();
        }

        _mint(msg.sender, 70000000 * 10 ** 18);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            s_totalSupply += value;
        } else {
            uint256 fromBalance = balances[from];
            if (fromBalance < value) {
                revert INSUFFICIENT_BALANCE();
            }
            unchecked {
                //Overflow not possible: value <= fromBalance <= totalsuply
                balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible
                s_totalSupply -= value;
            }
        } else {
            unchecked {
                //Overflow not possible: balance + value is at most totalsupply, which we know fits into a uint256
                balances[to] += value;
            }
        }
        emit Transfer(from, to, value);
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender();
        }

        if (to == address(0)) {
            revert ERC20InvalidReceiver();
        }
        _update(from, to, value);
    }

    /**
     * @dev Creates a "value" amount of tokens and assigns them to "accont", by transferring it from address(0).
     *
     * Relies on the "_update" mechanism
     *
     * Emits a {Transfer} event with "from" set to the zero address.
     *
     * Note: thi function is not virtual , {_update} should be overriden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver();
        }

        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a "value" amount of tokens from 'account', lowering the total supply.
     *
     * Emits a {Transfer} event with "to" set to the zero address.
     *
     *
     */
    function burn(address account, uint256 value) public {
        if (account == address(0)) {
            revert ERC20InvalidSender();
        }

        _update(account, address(0), value);
    }

    function setRewardAmount(uint256 _amount) public {
        if (s_owner != msg.sender) {
            revert NOT_THE_OWNER();
        }
        s_rewardamount = _amount;
    }

    /*//////////////////////////////////////////////////////////////
                           GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Returns the totalSupply of Tokens in existence
     */
    function getTotalSupply() external view returns (uint256) {
        return s_totalSupply;
    }

    /**
     * @dev Returns the value of tokens owned by"account"
     */
    function getBalanceof(address user) public view returns (uint256) {
        return balances[user];
    }

    /**
     * @dev Returns the name of the ERC20 token.
     */
    function getName() public view returns (string memory) {
        return s_name;
    }

    /**
     * @dev  Returns the symbol of the ERC20 Token.
     */
    function getSymbol() public view returns (string memory) {
        return s_symbol;
    }

    /**
     * @dev Returns the number of decimals ...
     */
    function getDecimals() public view returns (uint256) {
        return s_decimals;
    }

    function getUserBalances(address user) external view returns (uint256) {
        return userbalance[user];
    }

    function getRewardAmount() external view returns (uint256) {
        return s_rewardamount;
    }
}
