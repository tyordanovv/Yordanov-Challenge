export const formatTimestamp = (timestamp: string) => {
  return new Date(Number(timestamp)).toLocaleString();
};

export const formatAddress = (address: string) => {
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
};

export const formatPrice = (price: string) => {
  return (Number(price) / 1_000_000_000).toFixed(2);
};

export const suiToMist = (suiAmount: number | string): bigint => {
  return BigInt(Math.floor(Number(suiAmount) * 1_000_000_000));
};