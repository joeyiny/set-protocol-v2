import { defineConfig } from "@wagmi/cli";
import { foundry } from "@wagmi/cli/plugins";

export default defineConfig({
  out: "abis/generated.ts",
  plugins: [
    foundry({
      project: "./",
      include: [
        "SetTokenCreator.sol/**",
        "Controller.sol/**",
        "BasicIssuanceModule.sol/**",
        "StreamingFeeModule.sol/**",
        "SetToken.sol/**",
      ],
    }),
  ],
});
