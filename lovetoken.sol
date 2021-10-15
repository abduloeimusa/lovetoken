// SPDX-License-Identifier: MIT

/**
 * 
 * Abdule ERC20  Smartcontract
 * Contact: Dome C. <abduloeimusa@gmail.com>
 *          Abdule Inc
 *          1 Sheikh Mohammed bin Rashid Blvd - Downtown Dubai
 *          Dubai - United Arab Emirates
 *          9440
 * 
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AbduleERC20Cap is ERC20, AccessControl, Ownable {
    IERC20 public Token;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    uint256 private _cap;

    constructor(address _admin,uint256 cap_) ERC20("LOVE TOKEN", "LOVE") {

        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(MINTER_ROLE, _admin);
        _setupRole(BURNER_ROLE, _admin);
        require(cap_ > 0, "ERC20Capped: cap is 0");
        _cap = cap_;        
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        _mint(to, amount);
    }

    function burnfrom(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    } 
    function claimToken(IERC20 token) public  {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

}
