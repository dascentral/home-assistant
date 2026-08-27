# Nabu Casa + Alexa Setup Research

Research for wayfinder ticket [#4](https://github.com/dascentral/home-assistant/issues/4).

## 1. Sign Up for Nabu Casa / Home Assistant Cloud

Signup is done **from within Home Assistant**, not on the Nabu Casa website.

### Steps

1. In Home Assistant, go to **Settings > Home Assistant Cloud**.
   - The `cloud:` integration is included by default via `default_config:` in `configuration.yaml`. No manual config needed. ([source](https://www.home-assistant.io/integrations/cloud/))
2. Select **"Start your free 1 month trial"**.
3. Enter an **email address** and **password** to create a Nabu Casa account.
4. Select **"Start trial"**.
   - No payment details are required to start the trial. ([source](https://support.nabucasa.com/hc/en-us/articles/25649130769949))
5. The trial lasts **31 days**. After that, a subscription is required. ([source](https://www.nabucasa.com/))

### Pricing (after trial)

- **Monthly**: $6.50 USD (excl. sales tax)
- **Annual**: $65 USD (excl. sales tax)
- **Payment methods**: Credit Card, Google Pay, Apple Pay, or PayPal (via Stripe) ([source](https://www.nabucasa.com/pricing/))

### Account management

After signup, account management (billing, password) is at [account.nabucasa.com](https://account.nabucasa.com). ([source](https://www.nabucasa.com/))

## 2. Link Nabu Casa to HA Green

No separate linking step is required. When you sign up from within Home Assistant (step 1 above), the cloud connection is established automatically. The HA Green instance connects **outbound** to Nabu Casa's relay — no port forwarding, dynamic DNS, or SSL certificates needed. ([source](https://www.home-assistant.io/integrations/alexa.smart_home/))

### Verify the connection

After signup, **Settings > Home Assistant Cloud** should show the cloud connection as active, with remote access and voice assistant options available.

## 3. Connect Alexa Smart Home Skill

### 3a. Enable Alexa in Home Assistant

1. Go to **Settings > Voice Assistants**.
2. Under the **Home Assistant Cloud** card, **enable Alexa**. ([source](https://www.home-assistant.io/integrations/alexa.smart_home/))

### 3b. Expose entities to Alexa

1. Go to **Settings > Voice Assistants** and open the **Expose** tab.
2. Select the **"Expose entities"** button.
3. Find and select the entities you want Alexa to control (e.g., `script.sams_bedtime_routine`).
4. In the entity's exposure settings, ensure **Alexa** is checked. ([source](https://www.home-assistant.io/voice_control/voice_remote_expose_devices/))

Only exposed entities are visible to Alexa. Nothing is exposed by default — this is intentional to prevent sensitive devices from being inadvertently controlled by voice. ([source](https://www.home-assistant.io/voice_control/voice_remote_expose_devices/))

### 3c. Activate the Alexa Smart Home skill

1. Open the **Amazon Alexa app** on your phone.
2. Go to **More > Skills & Games**.
3. Search for **"Home Assistant"**.
4. Select the **Home Assistant** Smart Home skill and tap **"Enable to Use"**.
5. You will be prompted to **link your Nabu Casa account** — sign in with the same email/password used in step 1.
6. After linking, tap **"Discover Devices"** (or say "Alexa, discover my devices"). ([source](https://www.home-assistant.io/integrations/alexa.smart_home/))

### 3d. Test

Once discovery completes, the exposed script should appear as a device in the Alexa app. Test with:

> "Alexa, turn on Sam's Bedtime Routine"

Scripts support both "turn on" and direct name activation:
- "Alexa, turn on [script alias]"
- "Alexa, [script alias]"
- "Alexa, turn off [script alias]" (deactivates a running script)

([source](https://www.home-assistant.io/integrations/alexa.smart_home/))

## Supported Entity Types

The Alexa Smart Home integration supports scripts as activatable entities alongside lights, switches, scenes, locks, thermostats, media players, fans, sensors, and more. ([source](https://www.home-assistant.io/integrations/alexa.smart_home/))

## Security Notes

- Home Assistant Cloud uses an **outbound encrypted tunnel** — no ports are opened on the router, no public IP exposure. ([source](https://www.home-assistant.io/integrations/alexa.smart_home/))
- Smart home data travels encrypted; Nabu Casa cannot view the data. ([source](https://www.nabucasa.com/))
- Entity exposure is **opt-in only** — nothing is exposed until explicitly configured. ([source](https://www.home-assistant.io/voice_control/voice_remote_expose_devices/))

## Sources

- [Home Assistant Cloud integration docs](https://www.home-assistant.io/integrations/cloud/)
- [Alexa Smart Home Skill docs](https://www.home-assistant.io/integrations/alexa.smart_home/)
- [Exposing entities to voice assistants](https://www.home-assistant.io/voice_control/voice_remote_expose_devices/)
- [Nabu Casa homepage / trial info](https://www.nabucasa.com/)
- [Nabu Casa pricing](https://www.nabucasa.com/pricing/)
- [Enabling Home Assistant Cloud (Nabu Casa support)](https://support.nabucasa.com/hc/en-us/articles/25649130769949)
