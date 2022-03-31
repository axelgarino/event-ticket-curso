// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import {EventTickets} from "./EventTickets.sol";

// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/access/Ownable.sol";


/* The EventTickets contract keeps track of the details and ticket sales of one event. */

contract DefaultEventTickets is EventTickets, Ownable{
    /*
        Create a public state variable called owner.
        Use the appropriate keyword to create an associated getter function.
        Use the appropriate keyword to allow ether transfers.
     */

    //address payable public owner;

    // TODO: refactor: Ticket price sea variable
    // uint256 TICKET_PRICE = 100 wei;

    /*
        Create a struct called "Event".
        The struct has 6 fields: description, website (URL), totalTickets, sales, buyers, and isOpen.
        Choose the appropriate variable type for each field.
        The "buyers" field should keep track of addresses and how many tickets each buyer purchases.
    */

    struct Event {
        string description;
        string website;
        uint256 totalTickets;
        uint256 sales;
        mapping(address => uint256) buyers;
        bool isOpen;
        uint256 TICKET_PRICE;

    }

    Event myEvent;

    /*
        Define 3 logging events.
        LogBuyTickets should provide information about the purchaser and the number of tickets purchased.
        LogGetRefund should provide information about the refund requester and the number of tickets refunded.
        LogEndSale should provide infromation about the contract owner and the balance transferred to them.
    */

    event LogBuyTickets(address buyer, uint256 numTickets);
    event LogGetRefund(address accountRefunded, uint256 numTickets);
    event LogEndSale(address owner, uint256 balance);

    /*
        Create a modifier that throws an error if the msg.sender is not the owner.
        TODO: refactoring; use openzeppelin Ownable contract.
        (https://docs.openzeppelin.com/contracts/4.x/api/access#Ownable)
        (https://docs.openzeppelin.com/learn/developing-smart-contracts#importing_openzeppelin_contracts)
    */

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Not owner");
    //     _;
    // }

    /*
        Define a constructor.
        The constructor takes 3 arguments, the description, the URL and the number of tickets for sale.
        Set the owner to the creator of the contract.
        Set the appropriate myEvent details.
    */

    constructor(
        string memory _description,
        string memory _url,
        uint256 _totalTickets,
        uint256 _TICKET_PRICE
    ) {
        transferOwnership(msg.sender);
        myEvent.description = _description;
        myEvent.website = _url;
        myEvent.totalTickets = _totalTickets;
        myEvent.TICKET_PRICE = _TICKET_PRICE;
        myEvent.isOpen = true;
    }

    /*
        Define a function called readEvent() that returns the event details.
        This function does not modify state, add the appropriate keyword.
        The returned details should be called description, website, uint totalTickets, uint sales, bool isOpen in that order.
    */
    function readEvent()
        external
        view
        returns (
            string memory description,
            string memory website,
            uint256 totalTickets,
            uint256 TICKET_PRICE,
            uint256 sales,
            bool isOpen
        )
    {
        return (
            myEvent.description,
            myEvent.website,
            myEvent.totalTickets,
            myEvent.TICKET_PRICE,
            myEvent.sales,
            myEvent.isOpen
        );
    }

    /*
        Define a function called getBuyerTicketCount().
        This function takes 1 argument, an address and
        returns the number of tickets that address has purchased.
    */

    function getBuyerTicketCount(address buyer)
        external
        view
        returns (uint256)
    {
        return myEvent.buyers[buyer];
    }

    /*
        Define a function called buyTickets().
        This function allows someone to purchase tickets for the event.
        This function takes one argument, the number of tickets to be purchased.
        This function can accept Ether.
        Be sure to check:
            - That the event isOpen
            - That the transaction value is sufficient for the number of tickets purchased
            - That there are enough tickets in stock
        Then:
            - add the appropriate number of tickets to the purchasers count
            - account for the purchase in the remaining number of available tickets
            - refund any surplus value sent with the transaction
            - emit the appropriate event
    */
    function buyTickets(uint256 quantity) external payable {
        require(myEvent.isOpen == true, "Event already closed");
        require(msg.value >= (quantity * myEvent.TICKET_PRICE), "Funds not enough");
        require(
            quantity <= (myEvent.totalTickets - myEvent.sales),
            "Out of stock"
        );

        myEvent.buyers[msg.sender] += quantity;
        myEvent.sales += quantity;
        myEvent.totalTickets -= quantity;

        uint256 totalPrice = quantity * myEvent.TICKET_PRICE;
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }

        emit LogBuyTickets(msg.sender, quantity);
    }

    /*
        Define a function called getRefund().
        This function allows someone to get a refund for tickets for the account they purchased from.
        TODO:
            - Check that the requester has purchased tickets.
            - Make sure the refunded tickets go back into the pool of avialable tickets.
            - Transfer the appropriate amount to the refund requester.
            - Emit the appropriate event.
    */

    function getRefund(uint256 toRefund) external {
        // TODO
        require(this.getBuyerTicketCount(msg.sender) >= 1 ,"Sin tickets");
        require(this.getBuyerTicketCount(msg.sender) >= toRefund, "No puede devolver esa cantidad de tickets");
        require(toRefund > 0, "Debe devolver 1 o mas tickets");

        myEvent.totalTickets += toRefund;
        myEvent.sales -= toRefund; 

        myEvent.buyers[msg.sender] -= toRefund;

        uint256 totalRefund = toRefund * myEvent.TICKET_PRICE;
        payable(msg.sender).transfer(totalRefund);

        emit LogGetRefund(msg.sender, toRefund);

    }

    /*
        Define a function called endSale().
        This function will close the ticket sales.
        This function can only be called by the contract owner.
        TODO:
            - close the event
            - transfer the contract balance to the owner
            - emit the appropriate event
    */

    function endSale() external onlyOwner {
        // TODO
        // require(myEvent.isOpen == false, "Already closed");
        myEvent.isOpen = false;

        uint256 balance = myEvent.sales * myEvent.TICKET_PRICE;
        payable(msg.sender).transfer(balance);

        emit LogEndSale(msg.sender, balance);

    }
}
