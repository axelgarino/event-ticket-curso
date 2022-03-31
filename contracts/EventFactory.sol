// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./EventTickets.sol";
import "./DefaultEventTickets.sol";

contract EventFactory {

    uint256 public quantity;

    /*
        Create a struct called "EventData".
        The struct has 4 fields: description, manager, timestamp, eventTickets
        Choose the appropriate variable type for each field.
    */
    struct EventData {
        string description;
        address manager;
        uint256 timestamp;
        EventTickets eventTickets;
    }

    /*
        Create a mapping to track the events.
     */
    mapping(uint256 => EventData) events;

    /*
        Define a function called createEvent().
        This function receive event data to create and deploy the new event.
    */
    function createEvent(
        string memory _description,
        string memory _url,
        uint256 _totalTickets,
        uint256 _TICKET_PRICE
    ) public { 
        EventData storage data = events[quantity];
        data.description = _description;
        data.manager = msg.sender;
        data.timestamp = block.timestamp;
        data.eventTickets = new DefaultEventTickets(
            _description,
            _url,
            _totalTickets,
            _TICKET_PRICE
        );

        quantity++;
    }

    /*
        Define a function called addEvent().
        This function receive event ticket contract compatible to
        add the contract to the mapping storage variable (events).
    */
    function addEvent(
        EventTickets eventTickets) 
    external { 
        (
            string memory description, 
            , 
            , 
            , 
            ,
            
        ) = eventTickets.readEvent();
        // TODO
        // queda añadir este evento que estamos leyendo al mapping de eventos
        // pista en el createEvent
        EventData storage data = events[quantity];
        data.description = description;
        data.manager = msg.sender;
        data.timestamp = block.timestamp;
        data.eventTickets = eventTickets;
        quantity++;
    }

    /*
        Define a function called getEvent().
        This function receive the event id and returns 
        the event data struct.
    */
    function getEvent(uint256 id) external view returns (EventData memory) { 
        return events[id];
    }
}
