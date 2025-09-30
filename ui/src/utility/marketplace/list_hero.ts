import { Transaction } from "@mysten/sui/transactions";
import { suiToMist } from "../../lib/utils";

export const listHero = (
  packageId: string,
  heroId: string,
  priceInSui: string,
) => {
  const tx = new Transaction();

  const priceInMist = suiToMist(priceInSui);

  tx.moveCall({
    target: `${packageId}::marketplace::list_hero`,
    arguments: [
      tx.object(heroId),
      tx.pure.u64(priceInMist)
    ],
  });

  return tx;
};
