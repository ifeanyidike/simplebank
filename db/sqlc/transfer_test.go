package db

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/ifeanyidike/simple_bank/util"
	"github.com/stretchr/testify/require"
)

func createRandomTransfer(t *testing.T) Transfer {
	account1 := createRandomAccount(t)
	account2 := createRandomAccount(t)
	arg := CreateTransferParams{
		FromAccountID: account1.ID,
		ToAccountID:   account2.ID,
		Amount:        util.RandomMoney(),
	}

	transfer, err := testQueries.CreateTransfer(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, transfer)

	require.Equal(t, arg.FromAccountID, transfer.FromAccountID)
	require.Equal(t, arg.ToAccountID, transfer.ToAccountID)
	require.Equal(t, arg.Amount, transfer.Amount)

	require.NotZero(t, transfer.FromAccountID)
	require.NotZero(t, transfer.ToAccountID)
	require.NotZero(t, transfer.CreatedAt)

	return transfer
}

func TestCreateTransfer(t *testing.T) {
	createRandomTransfer(t)
}

func TestGetTransfer(t *testing.T) {
	Transfer1 := createRandomTransfer(t)
	Transfer2, err := testQueries.GetTransfer(context.Background(), Transfer1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, Transfer2)

	require.Equal(t, Transfer1.ID, Transfer2.ID)
	require.Equal(t, Transfer1.FromAccountID, Transfer2.FromAccountID)
	require.Equal(t, Transfer1.ToAccountID, Transfer2.ToAccountID)
	require.Equal(t, Transfer1.Amount, Transfer2.Amount)
	require.WithinDuration(t, Transfer1.CreatedAt, Transfer2.CreatedAt, time.Second)
}

func TestUpdateTransfer(t *testing.T) {
	Transfer1 := createRandomTransfer(t)

	arg := UpdateTransferParams{
		ID:     Transfer1.ID,
		Amount: Transfer1.Amount,
	}

	Transfer2, err := testQueries.UpdateTransfer(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, Transfer2)

	require.Equal(t, Transfer1.ID, Transfer2.ID)
	require.Equal(t, Transfer1.FromAccountID, Transfer2.FromAccountID)
	require.Equal(t, Transfer1.ToAccountID, Transfer2.ToAccountID)
	require.Equal(t, Transfer1.Amount, Transfer2.Amount)
	require.WithinDuration(t, Transfer1.CreatedAt, Transfer2.CreatedAt, time.Second)
}

func TestDeleteTransfer(t *testing.T) {
	Transfer1 := createRandomTransfer(t)
	err := testQueries.DeleteTransfer(context.Background(), Transfer1.ID)
	require.NoError(t, err)

	account2, err := testQueries.GetTransfer(context.Background(), Transfer1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, account2)
}

func TestListTransfers(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomTransfer(t)
	}

	arg := ListEntiesParams{
		Limit:  5,
		Offset: 5,
	}

	transfers, err := testQueries.ListEnties(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, transfers, 5)

	for _, Transfer := range transfers {
		require.NotEmpty(t, Transfer)
	}
}
