defmodule EWalletAPI.V1.TransactionRequestConsumptionSerializerTest do
  use EWalletAPI.SerializerCase, :v1
  alias EWalletDB.TransactionRequestConsumption
  alias EWalletAPI.V1.JSON.TransactionRequestConsumptionSerializer
  alias EWallet.Web.Date

  describe "serialize/1 for single transaction request consumption" do
    test "serializes into correct V1 transaction_request consumption format" do
      request = insert(:transaction_request_consumption)
      consumption = TransactionRequestConsumption.get(request.id, preload: [:minted_token])

      expected = %{
        object: "transaction_request_consumption",
        id: consumption.id,
        status: consumption.status,
        amount: consumption.amount,
        minted_token: %{
          object: "minted_token",
          id: consumption.minted_token.friendly_id,
          name: consumption.minted_token.name,
          subunit_to_unit: consumption.minted_token.subunit_to_unit,
          symbol: consumption.minted_token.symbol
        },
        correlation_id: consumption.correlation_id,
        idempotency_token: consumption.idempotency_token,
        transaction_id: consumption.transfer_id,
        user_id: consumption.user_id,
        account_id: nil,
        transaction_request_id: consumption.transaction_request_id,
        address: consumption.balance_address,
        created_at: Date.to_iso8601(consumption.inserted_at),
        updated_at: Date.to_iso8601(consumption.updated_at)
      }

      assert TransactionRequestConsumptionSerializer.serialize(consumption) == expected
    end
  end
end
