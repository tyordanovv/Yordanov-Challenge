import { Transaction } from "@mysten/sui/transactions";
import { suiToMist } from "../../lib/utils";

export const buyHero = (packageId: string, listHeroId: string, priceInSui: string) => {
  const tx = new Transaction();
  
  const priceInMist = suiToMist(priceInSui);
  
  const [paymentCoin] = tx.splitCoins(tx.gas, [tx.pure.u64(priceInMist)]);
  
  tx.moveCall({
    target: `${packageId}::marketplace::buy_hero`,
    arguments: [
      tx.object(listHeroId),
      paymentCoin
    ],
  });
    
  return tx;
};