import solc from "solc";
import { readFile } from "fs/promises";

(async function compileFunc() {
  const compileFile = await readFile("./solFolder/Dummy.sol", "utf8");
  console.log(compileFile);
  var input = {
    language: "Solidity",
    sources: {
      "test.sol": {
        content: `${compileFile}`,
      },
    },
    settings: {
      outputSelection: {
        "*": {
          "*": ["*"],
        },
      },
    },
  };
  var output = JSON.parse(solc.compile(JSON.stringify(input)));
  console.log(input);
  console.log(output);
  // for (var contractName in output.contracts["test.sol"]) {
  //   console.log(
  //     contractName +
  //       ": " +
  //       output.contracts["test.sol"][contractName].evm.bytecode.object
  //   );
  // }
})();
