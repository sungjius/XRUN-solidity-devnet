import { readFile } from "fs/promises";
import Web3 from "web3";
import Contract from "web3-eth-contract";
async function createConnectionGethConsole(
  host = "http://localhost:5006",
  compoileFileDir
) {
  let web3 = new Web3(Web3.givenProvider || host);
  //  web3.setProvider(new web3.providers.HttpProvider("http://localhost:5006"));
  //   const source = await readFile(compoileFileDir);
  // return { web3, source };
  return { web3 };
}

(async function main() {
  // const { web3 } = await createConnectionGethConsole("http://localhost:5006");
  const source = await readFile("./solFolder/ERC20.json");
  // console.log(contract);
  ///////////////////////////////////
  const { abi, bytecode } = JSON.parse(source)["contract"];

  const web3_test = new Web3("http://127.0.0.1:5006");
  const address = "0x6b5e69f64D88550A5A529A9c5D081e9b947FfDfA";

  // const frombalanceOf2 = await web3_test.eth.getBalance(
  //   "0xdaa6ac628dcbae26812d78ac369db387403f79b7"
  // );
  // const tobalanceOf = await web3_test.eth.getBalance(
  //   "0x6697ac35c8a3fe614d4b8bb3d6e4b377a6fa992d"
  // );
  // console.log("===============Before Balncce Of================");
  // console.log(`fromBalanceOf >> ${frombalanceOf2}`);
  // console.log(`toBalanceOf  >> ${tobalanceOf}  `);
  const contract = new web3_test.eth.Contract(abi, address);
  // contract.methods.get;
  try {
    await web3_test.eth.personal.unlockAccount(
      "0xdaa6ac628dcbae26812d78ac369db387403f79b7",
      "1234"
    );
    console.log();
    // const transferBalance = await contract.methods
    //   .transfer("0x48c9c7d36c64f20a05ebff6c234fd4de93192a7a", 1000000000000000)
    //   .send({
    //     from: "0xdaa6ac628dcbae26812d78ac369db387403f79b7",
    //     gas: 912421,
    //   });
    const contractName = await contract.methods.name().call();
    const contractOwnerAddress = await contract.methods.owner().call();
    // console.log(transferBalance);
    console.log(contractOwnerAddress);
    console.log(contractName);
    //   console.log("===============After Balncce Of================");
    //   const frombalanceOf = await web3_test.eth.getBalance(
    //     "0xa3738ac9f9dfdb5819f677c728e708899712eac1"
    //   );
    //   const tobalanceOf1 = await web3_test.eth.getBalance(
    //     "0x6697ac35c8a3fe614d4b8bb3d6e4b377a6fa992d"
    //   );
    //   console.log(frombalanceOf);
    //   console.log(tobalanceOf1);
  } catch (error) {
    console.log(error);
  }

  // console.log(`fromBalanceOf1 >> ${frombalanceOf1}`);
  // console.log(`toBalanceOf1  >> ${tobalanceOf1}  `);
})();
