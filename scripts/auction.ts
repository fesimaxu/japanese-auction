import { ethers } from "hardhat";

async function main() {
  
  const [deployer] = await ethers.getSigners();
  console.log(`Address deploying the contract --> ${deployer.address}`);

  const vaultAmount = ethers.utils.parseEther("30");

  const auction = await ethers.getContractFactory("japaneseAuction");
  const _Auction = await auction.deploy(
    "0x209e639a0EC166Ac7a1A4bA41968fa967dB30221",
    1,
    "0x2DBdd859D9551b7d882e9f3801Dbb83b339bFFD7",
    vaultAmount,
    1,
    ["0xD89d0C24c44440e1c960403a53Fc73e947c1e9D5",
    "0x9ee15CF9EC4B3830bBedA501d85F5329Ea3C595C",
    "0x85f20a6924A61904AB44243C7e2c771B3bE46734",
    "0x85f20a6924A61904AB44243C7e2c771B3bE46734"
    ]
  );

  await _Auction.deployed();

  console.log("Vault of 1 ETH deployed to:", _Auction.address);

  let result = await _Auction.bid(
  )

  let response = (await result.wait());

 console.log("factory cloned successfully", response);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
