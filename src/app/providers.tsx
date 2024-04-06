"use client";

import { modalTheme } from "@/components/theme/modal";
import { tooltipTheme } from "@/components/theme/tooltip";
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
import { CacheProvider } from "@chakra-ui/next-js";
import { ChakraProvider } from "@chakra-ui/react";

import { extendTheme } from "@chakra-ui/react";
import { PetraWallet } from "petra-plugin-wallet-adapter";

const colors = {
  background: {
    main: "#020617",
    overlay: "rgba(2, 6, 23, 0.7)",
  },
  primary: {
    lighter: "#E0F1FB",
    light: "#C2EAFF",
    main: "#89D1F6",
    dark: "#5ABAEC",
    darker: "#2B8BBD",
    background: "#335068",
  },
  gray: {
    900: "#0A101E",
    800: "#1E2535",
    700: "#334155",
    600: "#707E94",
    500: "#8A99AE",
    400: "#B7C1CD",
    100: "#F8FAFC",
  },
};

export const theme = extendTheme({
  colors,
  components: { Modal: modalTheme, Tooltip: tooltipTheme },
});

export function Providers({ children }: { children: React.ReactNode }) {
  const wallets = [new PetraWallet()];

  return (
    <CacheProvider>
      <ChakraProvider theme={theme}>
        <AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
          {children}
        </AptosWalletAdapterProvider>
      </ChakraProvider>
    </CacheProvider>
  );
}
