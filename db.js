const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

// 1. Connexion / création du fichier de base de données SQLite
const dbPath = path.join(__dirname, 'football.db');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Erreur lors de la connexion à SQLite :', err.message);
    } else {
        console.log('Connecté avec succès à la base SQLite (football.db).');
    }
});

// 2. Initialisation des tables depuis schema.sql
function initDatabase() {
    const schemaPath = path.join(__dirname, 'schema.sql');
    
    if (fs.existsSync(schemaPath)) {
        const sqlSchema = fs.readFileSync(schemaPath, 'utf8');
        db.exec(sqlSchema, (err) => {
            if (err) {
                console.error('Erreur d initialisation de la base :', err.message);
            } else {
                console.log('Structure SQL chargée avec succès !');
            }
        });
    } else {
        console.warn('Fichier schema.sql introuvable.');
    }
}

module.exports = { db, initDatabase };
