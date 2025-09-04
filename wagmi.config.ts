import { defineConfig } from "@wagmi/cli";
import { foundry } from "@wagmi/cli/plugins";

export default defineConfig({
  out: "abis/generated.ts",
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
      ],
    }),
  ],
});
