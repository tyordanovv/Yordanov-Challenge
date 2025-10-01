import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading, Separator } from "@radix-ui/themes";
import { useState } from "react";
import { WalletStatus } from "./components/WalletStatus";
import { CreateHero } from "./components/CreateHero";
import { OwnedObjects } from "./components/OwnedObjects";
import SharedObjects from "./components/SharedObjects";
import Arenas from "./components/Arenas";
import EventsHistory from "./components/EventsHistory";
import { CreateRandomHero } from "./components/CreateRandomHero";

function App() {
  const [refreshKey, setRefreshKey] = useState(0);
  return (
    <>
      {/* Header */}
      <Flex
        position="sticky"
        px="4"
        py="3"
        justify="between"
        align="center"
        style={{
          borderBottom: "1px solid var(--gray-a2)",
          background: "var(--color-background)",
          zIndex: 10,
        }}
      >
        <Box>
          <Heading size="6">Hero NFT Marketplace</Heading>
        </Box>

        <Box>
          <ConnectButton />
        </Box>
      </Flex>

      {/* Main Content */}
      <Container size="4" style={{ padding: "24px" }}>
        <Flex direction="column" gap="8">
          {/* Wallet Status Section */}
          <Box>
            <WalletStatus />
          </Box>

          <Separator size="4" />

          {/* Create Hero Section */}
          <Flex gap="4">
            <Box style={{ flex: 1 }}>
              <CreateHero refreshKey={refreshKey} setRefreshKey={setRefreshKey} />
            </Box>
            <Box style={{ flex: 1 }}>
              <CreateRandomHero refreshKey={refreshKey} setRefreshKey={setRefreshKey} />
            </Box>
          </Flex>

          <Separator size="4" />

          {/* Owned Heroes Section */}
          <Box>
            <OwnedObjects
              refreshKey={refreshKey}
              setRefreshKey={setRefreshKey}
            />
          </Box>

          <Separator size="4" />

          {/* Marketplace Section */}
          <Box>
            <SharedObjects
              refreshKey={refreshKey}
              setRefreshKey={setRefreshKey}
            />
          </Box>

          <Separator size="4" />

          {/* Battle Arena Section */}
          <Box>
            <Arenas refreshKey={refreshKey} setRefreshKey={setRefreshKey} />
          </Box>

          <Separator size="4" />

          {/* Events History Section */}
          <Box>
            <EventsHistory />
          </Box>
        </Flex>
      </Container>
    </>
  );
}

export default App;
