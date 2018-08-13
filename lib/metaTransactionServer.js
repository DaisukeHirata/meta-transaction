const Transaction = require('./transaction');

class MetaTransactionServer  {

  /**
   * Create encoded method call and sign transaction
   * @param abi
   * @param sig
   * @param to
   * @param from
   * @param data
   * @param wrapperTx
   * @param privateKey
   * @returns {Promise<*>}
   */
  static async createRawTxToRelay(abi, sig, to, data, wrapperTx, privateKey) {

    return Transaction.createTx(abi, "relayMetaTx",
      [ sig.v,
        Transaction.add0x(sig.r.toString('hex')),
        Transaction.add0x(sig.s.toString('hex')),
        Transaction.add0x(to),
        Transaction.add0x(data)
      ], wrapperTx, privateKey);
  };

}

module.exports = MetaTransactionServer;

