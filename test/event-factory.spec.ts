import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { EventFactory } from "../typechain";

describe("EventFactory Contract", function () {
    let EventFactory;
    let eventFactory: EventFactory;
    let owner: SignerWithAddress;
    let addr1: SignerWithAddress;
    let addr2: SignerWithAddress;
    let addrs: SignerWithAddress[];

    beforeEach(async () => {
        EventFactory = await ethers.getContractFactory("EventFactory");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        eventFactory = (await EventFactory.deploy()) as EventFactory;
    });

    it('should be deployed', () => {
        expect(eventFactory).to.be.not.null;
    })

});