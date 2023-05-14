package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

type Entry struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

var db *sql.DB

func init() {
	var err error
	db, err = sql.Open("sqlite3", "./entries.db")
	if err != nil {
		log.Fatal(err)
	}

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS entries (id INTEGER PRIMARY KEY, name TEXT)")
	if err != nil {
		log.Fatal(err)
	}
}

func entriesHandler(w http.ResponseWriter, r *http.Request) {
	start := time.Now()

	rows, err := db.Query("SELECT id, name FROM entries")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	log.Printf("Executed query: SELECT id, name FROM entries")

	entries := make([]Entry, 0)
	for rows.Next() {
		var e Entry
		if err := rows.Scan(&e.ID, &e.Name); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		entries = append(entries, e)
	}

	json.NewEncoder(w).Encode(entries)

	log.Printf("Processed /entries request in %s", time.Since(start))
}

func createHandler(w http.ResponseWriter, r *http.Request) {
	start := time.Now()

	if r.Method != "POST" {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	name := r.FormValue("name")
	if name == "" {
		http.Error(w, "Name is required", http.StatusBadRequest)
		return
	}

	_, err := db.Exec("INSERT INTO entries (name) VALUES (?)", name)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	log.Printf("Executed query: INSERT INTO entries (name) VALUES (?) with value: %s", name)

	fmt.Fprintf(w, "Entry created successfully!")

	log.Printf("Processed /create request in %s", time.Since(start))
}

func main() {
	http.HandleFunc("/entries", entriesHandler)
	http.HandleFunc("/create", createHandler)

	log.Println("Starting server on port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
