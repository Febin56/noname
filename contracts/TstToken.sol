pragma solidity ^0.4.18;

import "./StandardToken.sol";
import "./SafeMath.sol";

/// @title Token contract - Implements Standard Token Interface with TST features.
/// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
/// @author Alexey Bashlykov - <alexey@etherionlab.com>
contract TstToken is StandardToken, SafeMath {

    /*
     * External contracts
     */
    address public minter;

    /*
     * Token meta data
     */
    string constant public name = "tstToken";
    string constant public symbol = "TST";
    uint8 constant public decimals = 8;

    // Address of the founder of TST.
    address public founder = 0x58B219a8Fd3897303D3C106031736df26Ad3A406;

    // Multisig address of the founders
    address public multisig = 0x8ad3D6998c0A293Ce7f0f179217Dc8cB882437f6;

    // Address where all tokens created during ICO stage initially allocated
    address constant public allocationAddressICO = 0x1111111111111111111111111111111111111111;

    // Address where all tokens created during preICO stage initially allocated
    address constant public allocationAddressPreICO = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    // 31 820 314 tokens were minted during preICO
    uint constant public preICOSupply = mul(15000000, 100000000);

    // 131 038 286 tokens were minted during ICO
    uint constant public ICOSupply = mul(35000000, 100000000);

    // Max number of tokens that can be minted
    uint public maxTotalSupply;

    /*
     * Modifiers
     */
    modifier onlyFounder() {
        // Only founder is allowed to do this action.
        if (msg.sender != founder) {
            throw;
        }
        _;
    }

    modifier onlyMinter() {
        // Only minter is allowed to proceed.
        if (msg.sender != minter) {
            throw;
        }
        _;
    }

    /*
     * Contract functions
     */

    /// @dev Crowdfunding contract issues new tokens for address. Returns success.
    /// @param _for Address of receiver.
    /// @param tokenCount Number of tokens to issue.
    function issueTokens(address _for, uint tokenCount)
        external
        payable
        onlyMinter
        returns (bool)
    {
        if (tokenCount == 0) {
            return false;
        }

        if (add(totalSupply, tokenCount) > maxTotalSupply) {
            throw;
        }

        totalSupply = add(totalSupply, tokenCount);
        balances[_for] = add(balances[_for], tokenCount);
        Issuance(_for, tokenCount);
        return true;
    }

    /// @dev Function to change address that is allowed to do emission.
    /// @param newAddress Address of new emission contract.
    function changeMinter(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        // Forbid previous emission contract to distribute tokens minted during ICO stage
        delete allowed[allocationAddressICO][minter];

        minter = newAddress;

        // Allow emission contract to distribute tokens minted during ICO stage
        allowed[allocationAddressICO][minter] = balanceOf(allocationAddressICO);
    }

    /// @dev Function to change founder address.
    /// @param newAddress Address of new founder.
    function changeFounder(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        founder = newAddress;
    }

    /// @dev Function to change multisig address.
    /// @param newAddress Address of new multisig.
    function changeMultisig(address newAddress)
        public
        onlyFounder
        returns (bool)
    {
        multisig = newAddress;
    }

    /// @dev Contract constructor function sets initial token balances.
    function TstToken(address founderAddress)
    {   
        // Set founder address
        founder = founderAddress;

        // Allocate all created tokens during ICO stage to allocationAddressICO.
        balances[allocationAddressICO] = ICOSupply;

        // Allocate all created tokens during preICO stage to allocationAddressPreICO.
        balances[allocationAddressPreICO] = preICOSupply;

        // Allow founder to distribute tokens minted during preICO stage
        allowed[allocationAddressPreICO][founder] = preICOSupply;

        // Give 14 percent of all tokens to founders.
        balances[multisig] = div(mul(ICOSupply, 14), 86);

        // Set correct totalSupply and limit maximum total supply.
        totalSupply = add(ICOSupply, balances[multisig]);
        totalSupply = add(totalSupply, preICOSupply);
        maxTotalSupply = mul(totalSupply, 5);
    }
}
