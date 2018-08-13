pragma solidity 0.4.23;

// This is test contract invoked by TxProxy
// It can only record message and last sender
contract MessageBox {

    string public message;
    address public sender;
    address public relay;
    mapping(address => bool) public approvers;

    modifier onlyAuthorized() {
        require(msg.sender == relay || checkMessageData(msg.sender));
        _;
    }

    function MessageBox(string initialMessage, address _relayAddress) public {
        message = initialMessage;
        relay = _relayAddress;
    }

    function setMessage(address claimedSender, string newMessage) public {
        require(approvers[claimedSender]);
        message = newMessage;
        sender = claimedSender;
    }

    function delegate(address claimedSender) public onlyAuthorized {
        approvers[claimedSender] = true;
    }

    //Checks that address a is the first input in msg.data.
    //Has very minimal gas overhead.
    function checkMessageData(address a) private pure returns (bool t) {
        if (msg.data.length < 36) return false;
        assembly {
            let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            t := eq(a, and(mask, calldataload(4)))
        }
    }
}
