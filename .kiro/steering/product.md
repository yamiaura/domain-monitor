# Product Overview

Domain Monitor is a self-hosted domain expiration monitoring system built with PHP. It helps users track domain expiration dates and receive timely notifications through multiple channels.

## Core Purpose

Monitor unlimited domains and prevent domain loss through automated checks and multi-channel alerts (Email, Telegram, Discord, Slack, Webhooks).

## Key Features

- **Domain Management**: Add, edit, monitor domains with automatic WHOIS/RDAP lookups
- **TLD Registry**: Built-in support for 1,400+ TLDs with IANA integration
- **Multi-Channel Notifications**: Email, Telegram, Discord, Slack, and custom webhooks
- **Notification Groups**: Organize channels and assign domains flexibly
- **User Management**: Multi-user support with isolation modes (shared/isolated)
- **Session Management**: Database-backed sessions with geolocation tracking and remote logout
- **Two-Factor Authentication**: TOTP and email-based 2FA with backup codes
- **Tag System**: Organize domains with custom tags
- **Bulk Operations**: Import, refresh, delete, and manage multiple domains at once

## User Types

- **Admin**: Full system access, user management, settings configuration
- **Regular User**: Domain management, notification setup (with optional isolation mode)

## Security Features

- Random password generation on installation
- Database-backed sessions with immediate remote logout capability
- SQL injection protection via prepared statements
- CSRF protection
- Secure "Remember Me" tokens (30-day cryptographic tokens)
- Session tracking with geolocation and device info
