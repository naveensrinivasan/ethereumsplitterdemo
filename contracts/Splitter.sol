pragma solidity ^0.4.23;
import "./Destructible.sol";


contract Splitter is Destructible {
    using SafeMath for uint256;

    uint256 public constant TOTAL = 100;
    uint256 public totalWithdrawn = 0;

    mapping(address => uint256) public percentOwned;
    mapping(address => uint256) public released;
    address[] public receivers;

    event AmountWithDrawn(address receiver, uint256 amount);    
    constructor (address _receiver1, address _receiver2) public payable {
        addReciever(_receiver1, 50);
        addReciever(_receiver2, 50);
    }

    function () public payable {}

    function withdraw() public {
      address receiver = msg.sender;

      uint256 totalReceived = address(this).balance.add(totalWithdrawn);
      uint256 payment=totalReceived.mul(percentOwned[receiver]).div(TOTAL).sub(released[receiver]);

      require(payment != 0);
      require(address(this).balance >= payment);

      released[receiver] = released[receiver].add(payment);
      totalWithdrawn = totalWithdrawn.add(payment);

      receiver.transfer(payment);

      emit AmountWithDrawn(receiver, payment);
    }

    function addReciever(address _reciever, uint256 _percent) internal {
      require(_reciever != address(0));
      require(_percent > 0);
      require(percentOwned[_reciever] == 0);

      receivers.push(_reciever);
      percentOwned[_reciever] = _percent;
    }
} 