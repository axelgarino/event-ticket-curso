// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface EventTickets {
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
        );

    function getBuyerTicketCount(address buyer) external view returns (uint256);

    function buyTickets(uint256 quantity) external payable;

    function getRefund(uint256 toRefund) external;

    function endSale() external;
}
