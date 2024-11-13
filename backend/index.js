const express = require("express");
const app = express();
const PORT = 3000;

// Load the countries data from JSON file
const countries = require("./countries.json");

// Endpoint to fetch all countries
app.get("/api/countries", (req, res) => {
  res.json(countries);
});

// Endpoint to fetch a country by its code (e.g., /api/countries/FI)
app.get("/api/countries/:code", (req, res) => {
  const code = req.params.code.toUpperCase();
  const country = countries.find((c) => c.code === code);

  if (country) {
    res.json(country);
  } else {
    res.status(404).json({ error: "Country not found" });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
