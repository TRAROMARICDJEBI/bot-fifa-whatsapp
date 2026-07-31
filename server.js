const express = require('express');
const axios = require('axios');
const { initDatabase } = require('./db');

initDatabase();


// CONFIGURATION GREEN API
const ID_INSTANCE = "710722695528";
const API_TOKEN = "291e48ab78bb4cb6aa03eb6192c9ed802820d62c0231427b8d"; // Remplace par ton vrai API Token Green API
const URL_GREEN_API = `https://7107.api.greenapi.com/waInstance${ID_INSTANCE}/sendMessage/${API_TOKEN}`;

// COMMANDES ET RÉPONSES DU BOT
const COMMANDES = {
  "/start": `👋 Bienvenue sur le Bot FIFA Virtuel 1xBet !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 Je suis votre assistant IA pour les paris
   sur les matchs FIFA Virtuels 1xBet.

📌 Que souhaitez-vous faire ?
  ⚽ /predict   — Obtenir une prédiction
  📊 /stats     — Voir mes performances
  💳 /subscribe — Voir les abonnements
  ⚙️ /settings  — Mes préférences
  ❓ /help      — Aide & commandes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`,

  "/predict": `🤖 Analyse en cours...
⚽ Match : Manchester City vs PSG
📊 Prédiction : Victoire Manchester City
🎯 Confiance : 72%
💰 Mise conseillée : 1X2`,

  "/stats": `📈 STATISTIQUES DU BOT — 30 derniers jours
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Taux de réussite global : 73%
📊 Prédictions émises      : 248
🏆 Meilleures séries        : 9 victoires consécutives
🗓️ Dernière mise à jour     : Aujourd'hui à 14:32
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Détail par type de pari :
  1X2      → 76% ✅
  Double chance → 84% ✅
  Over/Under    → 68% ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`,

  "/subscribe": `💎 PLANS D'ABONNEMENT FIFA VIRTUEL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🥉 Starter  — 7 jours    → 4.99 €
🥈 Pro      — 30 jours   → 14.99 €
🥇 Premium  — 90 jours   → 34.99 €
👑 VIP      — 365 jours  → 99.99 €
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Prédictions illimitées
✅ Envoi automatique avant chaque match
✅ Alertes haute confiance en priorité
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
👉 Tapez le nom du plan pour continuer.`,

  "/help": `❓ AIDE — LISTE DES COMMANDES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/start      → Menu de bienvenue
/predict    → Obtenir une prédiction IA
/stats      → Statistiques du bot
/subscribe  → Plans d'abonnement
/settings   → Préférences personnelles
/history    → Vos 50 dernières prédictions
/balance    → Statut de votre abonnement
/help       → Afficher cette aide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Support : @support_1xbet_virtual`,

  "/settings": `⚙️ VOS PRÉFÉRENCES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌐 Langue              : Français ✅
🔔 Notifications auto  : Activées ✅
📋 Format prédiction   : Détaillé ✅
⏰ Fuseau horaire      : UTC+1 (Paris)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Que souhaitez-vous modifier ?
  [1] Langue
  [2] Notifications
  [3] Format de prédiction
  [4] Fuseau horaire
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`,

  "/history": `📋 HISTORIQUE — 50 DERNIÈRES PRÉDICTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#1250 | Barcelona vs Arsenal     | ✅ Gagné  | Cote 1.85
#1249 | Real Madrid vs Liverpool | ✅ Gagné  | Cote 2.10
#1248 | PSG vs Man United        | ❌ Perdu  | Cote 1.75
#1247 | Juventus vs Bayern       | ✅ Gagné  | Cote 1.90
#1246 | Chelsea vs Dortmund      | ✅ Gagné  | Cote 2.05
...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Taux de réussite sur cette période : 74%`,

  "/balance": `💳 STATUT DE VOTRE ABONNEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Plan actif    : Pro (30 jours)
📅 Expire le     : 15 février 2025
⏳ Jours restants : 18 jours
✅ Prédictions   : Illimitées
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 Renouveler : /subscribe`
};

// FONCTION POUR ENVOYER LE MESSAGE DANS WHATSAPP
async function repondreWhatsApp(chatId, texte) {
  try {
    await axios.post(URL_GREEN_API, {
      chatId: chatId,
      message: texte
    });
  } catch (error) {
    console.error("Erreur d'envoi Green API :", error);
  }
}

// WEBHOOK POUR RECEVOIR LES MESSAGES
app.post('/webhook', async (req, res) => {
  const body = req.body;

  if (body.typeWebhook === 'incomingMessageReceived') {
    const messageTexte = body.messageData?.textMessageData?.textMessage?.trim();
    const chatId = body.senderData?.chatId;

    if (messageTexte && chatId) {
      if (COMMANDES[messageTexte]) {
        await repondreWhatsApp(chatId, COMMANDES[messageTexte]);
      } else {
        await repondreWhatsApp(chatId, "⚠️ Commande non reconnue. Tapez /help pour voir la liste des commandes.");
      }
    }
  }

  res.sendStatus(200);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Bot FIFA WhatsApp démarré sur le port ${PORT} !`));
