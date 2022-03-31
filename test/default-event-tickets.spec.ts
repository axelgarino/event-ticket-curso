import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { DefaultEventTickets } from "../typechain";

describe("DefaultEventTickets Contract", function () {
    let DefaultEventTickets;
    let defaultEventTickets: DefaultEventTickets;
    let owner: SignerWithAddress;
    let addr1: SignerWithAddress;
    let addr2: SignerWithAddress;
    let addrs: SignerWithAddress[];

    beforeEach(async () => {
        DefaultEventTickets = await ethers.getContractFactory("DefaultEventTickets");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        defaultEventTickets = (await DefaultEventTickets.deploy("Curso blockchain", "url.com", 100, 1)) as DefaultEventTickets;
    });

    it('should be deployed', () => {
        expect(defaultEventTickets).to.be.not.null;
    })

    it('Setear owner correcto', async() => {
        expect(await defaultEventTickets.owner()).to.equal(owner.address);
    })

    it('comprar un ticket', async () => {
        await defaultEventTickets.connect(addr1).buyTickets(1, {value: 1});
        expect(await defaultEventTickets.getBuyerTicketCount(addr1.address)).to.equal(1);
    })

    it('No se permiten compras si el evento esta cerrado', async() => {
        await defaultEventTickets.connect(owner).endSale();
        await expect(defaultEventTickets.connect(addr1).buyTickets(1, {value:1})).to.be.revertedWith('Event already closed');
    })

    it('No se permiten compras si no tiene fondos suficientes', async() => {
        await expect(defaultEventTickets.connect(addr1).buyTickets(1)).to.be.revertedWith('Funds not enough');
    })

    it('No se permiten compras si no hay mas tickets en stock', async() => {
        await expect(defaultEventTickets.connect(addr1).buyTickets(101,{value:101})).to.be.revertedWith('Out of stock');
        // await defaultEventTickets.connect(addr1).buyTickets(101,{value:100});
        // await expect(defaultEventTickets.connect(addr2).buyTickets(100,{value:100})).to.be.revertedWith('Out of stock');
    })

    it('Se le permite devolver tickects', async() => {
        await defaultEventTickets.connect(addr1).buyTickets(1, {value: 1});
        await expect(defaultEventTickets.connect(addr1).getRefund(1));

    })

    it('No se pueden devolver tickets si no se tienen', async() => {
        await expect(defaultEventTickets.connect(addr1).getRefund(1)).to.be.revertedWith('Sin tickets');
    })

    it('No se pueden devolver esta cantidad de tickets si no se tienen', async() => {
        await defaultEventTickets.connect(addr1).buyTickets(1, {value: 1});
        await expect(defaultEventTickets.connect(addr1).getRefund(2)).to.be.revertedWith('No puede devolver esa cantidad de tickets');
    })

    it('No se pueden devolver esta cantidad de tickets si no se tienen', async() => {
        await defaultEventTickets.connect(addr1).buyTickets(1, {value: 1});
        await expect(defaultEventTickets.connect(addr1).getRefund(0)).to.be.revertedWith('Debe devolver 1 o mas tickets');
    })

    it('No se le permite cerrar el evento si no es el propietario', async() => {
        await expect(defaultEventTickets.connect(addr1).endSale()).to.be.revertedWith('Ownable: caller is not the owner');
    })

    it('Se le permite cerrar el evento solo al owner', async() => {
        await expect(defaultEventTickets.connect(owner).endSale());
    })

    











});