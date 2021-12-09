// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Token {
    mapping(address => uint64) public balances;
    string public name;

    constructor(string memory _name) {
        name = _name;
    }

    // virtual is used to mark if function is created to override
    function mint() virtual public {
        // tx represents address which started chain of transactions (here creator of wallet)
        balances[tx.origin]++;
    }
}

// is keyword is used to inherit
contract TokenX is Token {
    string public symbol;
    uint64 counter;

    constructor(string memory _name, string memory _symbol) Token(_name) {
        symbol = _symbol;
        counter = 0;
    }

    // override marks what we do
    function mint() override public {
        super.mint();
        counter++;
    }
}

contract Wallet {
    // payable allows to send ether to address / function
    address payable wallet;
    address public token;

    // events allows to subscribe to changes, follow the async natue of blockchain
    event Purchase(
        address buyer,
        uint256 amount
    );

    constructor(address payable _wallet, address _token) {
        wallet = _wallet;
        token = _token;
    }

    // receive funtion is being called when contract receives ether
    receive() external payable {
        buyToken();
    }

    // external keyword is used to mark function as usable only outside contract
    // fallback function is being called when receives calldata or indetifier has not been found
    fallback() external payable {
        buyToken();
    }

    function buyToken() public payable {
        Token(address(token)).mint();
        emit Purchase(msg.sender, 1);
    }
}
