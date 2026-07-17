// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EventTicketingPlatform {
    enum EventType {
        None,
        Conference,
        Workshop,
        Hackathon,
        Meetup,
        Webinar,
        Summit
    }

    enum TicketTier {
        Standard,
        Premium,
        VIP
    }

    struct Ticket {
        uint256 ticketId;
        address buyer;
        string eventName;
        uint256 purchaseAmount;
        uint256 purchaseTimestamp;
        uint256 eventTimestamp;
        EventType eventType;
        TicketTier ticketTier;
    }

    mapping(uint256 => Ticket) public tickets;

    mapping(uint256 => bool) public ticketUsed;

    uint256 public totalTicketsSold;

    address public owner;

    error EventTicketingPlatform_UnauthorizedAccess();
    error EventTicketingPlatform_InvalidAmount();
    error EventTicketingPlatform_EventNotSelected();
    error EventTicketingPlatform_InvalidEventDate();
    error  EventTicketingPlatform_TicketUsed();

    modifier onlyOwner() {
        // Check if the caller is the owner
        if(msg.sender != owner){         //Better Alternative Than Require, "revert with error in if-else"
            revert EventTicketingPlatform_UnauthorizedAccess();
        }

        // require(msg.sender == owner, "Unauthorized Access"); Also works but consumes a lot of Gas!!

        _;    // If the check passes, execute the rest of the function "_;" here
    }


    
    constructor() {
        owner = msg.sender;
    }

    function purchaseTicket
    ( 
         uint256 _ticketId,
         string calldata _eventName,
         uint256 _eventTimestamp,
         EventType _eventType,
         TicketTier _ticketTier
  ) external payable
  {
    if(msg.value == 0){
        revert  EventTicketingPlatform_InvalidAmount();
    }

    if(_eventType == EventType.None){
        revert  EventTicketingPlatform_EventNotSelected();

    }

    if(_eventTimestamp < block.timestamp){
        revert  EventTicketingPlatform_InvalidEventDate();
    }

    if(ticketUsed[_ticketId]== true){
        revert EventTicketingPlatform_TicketUsed();
    }

    tickets[_ticketId] = Ticket({
         ticketId:_ticketId,
         buyer: msg.sender,
         eventName: _eventName,
         purchaseAmount: msg.value,
         purchaseTimestamp: block.timestamp,
         eventTimestamp: _eventTimestamp,
         eventType: _eventType,
         ticketTier: _ticketTier
    });

    ticketUsed[_ticketId] == true;

    totalTicketsSold++;

    //  emit TicketPurchased(
    //         _ticketId,
    //         msg.sender,
    //         _eventName,
    //         msg.value,
    //         _eventType
    //     );

   
  }

}
