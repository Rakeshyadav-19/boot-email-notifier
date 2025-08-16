# Boot Email Notifier 🚀

**Linux Boot Email Notification**

Easily receive an email every time your Linux machine boots up. Reliable, robust, and ready for use.

## Features

- ✅ Works on Fedora (tested), Ubuntu, and other systemd-based distros
- ✅ Waits for network connectivity and retries until internet is available (up to 5 minutes)
- ✅ Configurable recipient and sender email
- ✅ Secure: Uses Gmail App Password (never your real password)
- ✅ Easy systemd integration (user or system-wide)
- ✅ Clear logging for troubleshooting

## Setup

---

### 1. Install dependencies

```bash
sudo dnf install msmtp   # Fedora
sudo apt install msmtp   # Ubuntu/Debian
```

### 2. Clone this repo

```bash
git clone https://github.com/rakeshyadav-19/boot-email-notifier.git
cd boot-email-notifier
```

### 3. Configure `.env`

You must use an App Password (not your normal Gmail password).
Go to Google Account → Security → App Passwords.
Choose Mail and Linux Computer (or custom).
Google gives you a 16-character password (no spaces).
Example: abcd efgh ijkl mnop → use it without spaces → abcdefghijklmnop.

```bash
cp .env.example .env
nano .env
```

### 4. Make script executable

```bash
chmod +x scripts/send_boot_mail.sh
```

---

### 5. Install the systemd service

#### ▶️ User Service (recommended)

Installs only for your user:

```bash
mkdir -p ~/.config/systemd/user
cp systemd/boot-email.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable boot-email.service
systemctl --user start boot-email.service
```

Check logs:

```bash
journalctl --user -u boot-email.service -b
```

#### ▶️ System-Wide Service

Installs for all users:

```bash
sudo cp systemd/boot-email.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable boot-email.service
sudo systemctl start boot-email.service
```

Check logs:

```bash
journalctl -u boot-email.service -b
```

---

### 6. Reboot and test

Reboot your machine and check your inbox 🎉

## Logs

## Troubleshooting & Logs

If the email fails or you want to check status, logs are stored in:

```bash
/tmp/boot-email.log
```

Check systemd logs for more details (see above).

---

## How it works

1. On boot, systemd runs the script after network-online.target.
2. The script waits and retries until internet is available (up to 5 minutes).
3. Once online, it sends an email with your hostname, IP, and boot time.
4. All actions and errors are logged for easy debugging.

---

## Security

- Uses Gmail App Password (never your real password)
- Credentials are stored in `.env` (never hardcoded)

---

## License

MIT

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add new feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Create a pull request

## Versioning

v1.0.0
