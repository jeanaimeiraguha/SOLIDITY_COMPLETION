// PaymentGateway.sol
pragma solidity ^0.8.0;

interface IPaymentGateway {
    function processPayment(address payable recipient, uint amount) external payable;
}

contract PaymentGateway is IPaymentGateway {
    function processPayment(address payable recipient, uint amount) external payable override {
        require(msg.value == amount, "Incorrect payment amount");
        recipient.transfer(amount);
    }
}
