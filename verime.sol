pragma solidity ^0.4.11;
import './iERC20.sol';
import './SafeMath.sol';

contract VERIME is iERC20 {
    uint public _totalSupply = 1000000000000000000000000000;

    string public constant symbol = "VRM";
    string public constant name = "Verime Mobile";
    uint8 public constant decimals = 18;

    address owner;
    bool freeTransfer = false;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function VERIME(address _multisig) {
        balances[_multisig] = _totalSupply;
        owner = _multisig;
    }

    modifier ownerOrEnabledTransfer() {
        require(freeTransfer || msg.sender == owner);
        _;
    }

    function enableTransfer() ownerOrEnabledTransfer() {
        freeTransfer = true;
    }

    function totalSupply() constant returns (uint256 totalSupply){
        return _totalSupply;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) ownerOrEnabledTransfer public returns (bool) {
        require(
        balances[msg.sender]>= _value
        && _value > 0
        );
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) ownerOrEnabledTransfer public returns (bool success) {
        require(
        allowed[_from][msg.sender]  >= _value
        && balances[_from] >= _value
        && _value > 0
        );
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require(_value == 0 || allowed[msg.sender][_spender] == 0);
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

}
