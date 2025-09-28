import { Client, GatewayIntentBits, Partials } from "discord.js";
import mysql from "mysql2/promise";
import fs from "fs";

const config = JSON.parse(fs.readFileSync("./config.json", "utf8"));
const TOKEN = config.discord_token;
const WATCH_CHANNEL_ID = config.watch_channel_id;
const GUILD_ID = config.guild_id;

const pool = mysql.createPool({
  host: config.db.host,
  user: config.db.user,
  password: config.db.password,
  database: config.db.database,
});

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
  ],
  partials: [Partials.Channel],
});

client.once("ready", () => {
  console.log("✅ Bejelentkezve mint ${client.user.tag}");
});

client.on("messageCreate", async (message) => {
  if (message.author.bot) return;

  if (!message.guild || message.guild.id !== GUILD_ID) return;
  if (message.channel.id !== WATCH_CHANNEL_ID) return;

  const userInput = message.content.trim();
  if (!userInput) return;

  await message.delete().catch(() =>
    console.warn("Nem sikerült törölni az üzenetet.")
  );

  try {
    const [rows] = await pool.query(
      "SELECT * FROM discord_verifications WHERE verify_code = ? AND discord_id IS NULL",
      [userInput]
    );

    if (rows.length > 0) {
        await pool.query("UPDATE discord_verifications SET discord_id = ?, verified_at = NOW() WHERE id = ?",[message.author.id, rows[0].id]);
    }
  } catch (err) {
    console.error("DB hiba:", err);
    await message.channel.send("⚠️ Hiba történt az ellenőrzés során.");
  }
});

client.login(TOKEN);