import { defineConfig } from "@wagmi/cli";
import { foundry } from "@wagmi/cli/plugins";

export default defineConfig({
  out: "../abi/src/set-protocol-v2-abis.ts",
  plugins: [
    foundry({
      project: "./",
      include: [
        "SetToken.sol/**",
        "Controller.sol/**",
        "SetTokenCreator.sol/**",
        "BasicIssuanceModule.sol/**",
        "StreamingFeeModule.sol/**",
        "WildcardAmmAdapter.sol/**",
        "IntegrationRegistry.sol/**",
        "WildcardAmmAdapter.sol/**",
        "ProtocolViewer.sol/**",
        "ERC20Viewer.sol/**",
        "SetTokenViewer.sol/**",
        "SlippageIssuanceModule.sol/**",
        "VfController.sol/**",
      ],
    }),
  ],
});
