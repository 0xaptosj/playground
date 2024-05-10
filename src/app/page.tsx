import { Run } from "@/components/Run";
import { getNftMintingEvents } from "@/utils/aptos";

export default async function Page() {
  await getNftMintingEvents();
  return <Run />;
}
