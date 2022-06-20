const { ethers } = require("hardhat")
const { assert, expect } = require("chai")

describe("SimpleStorage", () => {
    let simpleStorage, simpleStorageFactory
    beforeEach(async () => {
        simpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
        simpleStorage = await simpleStorageFactory.deploy()
    })

    it("Should start with a value of 0", async () => {
        const currentValue = await simpleStorage.retrieve()
        const expectedValue = "0"

        assert.equal(currentValue.toString(), expectedValue)
    })

    it("Should be able to update the value", async () => {
        const expectedValue = "7"
        const transactionResponse = await simpleStorage.store(expectedValue)
        await transactionResponse.wait()
        const currentValue = await simpleStorage.retrieve()

        assert.equal(currentValue.toString(), expectedValue)
    })

    it("Should work correctly with the people struct and array", async () => {
        const expectedPersonName = "Nam"
        const expectedValue = "17"
        const transactionResponse = await simpleStorage.addPerson(
            expectedPersonName,
            expectedValue
        )
        await transactionResponse.wait()

        const { favoriteNumber, name } = await simpleStorage.people(0)

        assert.equal(name, expectedPersonName)
        assert.equal(favoriteNumber.toString(), expectedValue)
    })
})
