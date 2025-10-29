package main

import (
	"database/sql"
	"log"
	"os"

	_ "github.com/lib/pq"
	"github.com/roditu/gosimplebank/api"
	db "github.com/roditu/gosimplebank/db/sqlc"
)

const (
	dbDriver = "postgres"
	serverAddress = "0.0.0.0:8080"
)
var dbSource = os.Getenv("DB_SOURCE")

func main() {
	if dbSource == "" {
		dbSource = "postgresql://postgres:secret@localhost:5433/simple_bank?sslmode=disable"
	}

	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("cannot start server: ", err)
	}
}