import { Transaction } from "@mysten/sui/transactions";

export const transferObject = (objectId: string, to: string) => {
  const tx = new Transaction();
  
  tx.transferObjects([
    tx.object(objectId)
  ], tx.pure.address(to));

  return tx;
};