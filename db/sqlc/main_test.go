package db

import (
	"database/sql"
	"log"
	"os"
	"testing"
	"time"

	"github.com/ifeanyidike/simple_bank/util"
	_ "github.com/lib/pq"
)

var testQueries *Queries
var testDb *sql.DB

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../../")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	testDb, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db: ", err)
	}

	// Set a timeout for the connection
	testDb.SetConnMaxLifetime(time.Second * 5)

	// Test the connection
	err = testDb.Ping()
	if err != nil {
    	log.Fatal("cannot ping db: ", err)
	}

	testQueries = New(testDb)
	os.Exit(m.Run())
}
