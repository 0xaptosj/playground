import React from "react";
import { Box, Flex, HStack, Link, Text } from "@chakra-ui/react";
import { WalletButtons } from "./WalletButtons";

export const NavBar = () => {
  return (
    <Flex
      bg="teal.600"
      color="white"
      px={16}
      py={4}
      justifyContent="space-between"
      alignItems="center"
    >
      <Box>
        <Text fontSize="xl" fontWeight="bold">
          Playground
        </Text>
      </Box>
      <HStack>
        <Link
          href="/"
          // passHref
          px={4}
          py={4}
          rounded={"md"}
          fontWeight={"bold"}
          _hover={{ textDecoration: "none", bg: "teal.600" }}
        >
          Home
        </Link>
      </HStack>
      <WalletButtons />
    </Flex>
  );
};
