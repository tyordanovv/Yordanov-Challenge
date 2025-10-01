import { Transaction } from "@mysten/sui/transactions";

export const createRandomHero = (
  packageId: string,
  name: string,
  imageUrl: string
) => {
  const tx = new Transaction();

  tx.moveCall({
    target: `${packageId}::hero::create_hero_random_power`,
    arguments: [
      tx.object.random(),
      tx.pure.string(name),
      tx.pure.string(imageUrl),
    ],
  });

  return tx;
};
