package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		name := "World"
		if p := c.QueryParam("name"); p != "" {
			name = p
		}
		return c.String(http.StatusOK, fmt.Sprintf("Hello, %s!", name))
	})
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	e.Logger.Fatal(e.Start(":" + port))
}
