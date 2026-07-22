# Security Policy

## ⚠️ Important Notice

This repository documents a **controlled red team exercise** conducted entirely within an **isolated VMware Workstation lab environment**. All content is for **educational and portfolio purposes only**.

---

## 🔒 Scope of This Project

| In Scope ✅ | Out of Scope ❌ |
|------------|----------------|
| Isolated VMware lab VMs | Any production systems |
| corp.local (lab domain only) | Real Active Directory environments |
| Windows Server 2019 (lab VM) | Any external networks |
| Windows 11 x64 (lab VM) | Any third-party systems |
| Kali Linux 2026 (lab VM) | Internet-facing infrastructure |

---

## 📋 Ethical Use Statement

All techniques demonstrated in this repository:

- Were conducted **only** within a personally owned, isolated lab environment
- Are documented **for educational purposes** to understand attack techniques and build defensive knowledge
- Align with the **MITRE ATT&CK framework** for security research
- Were performed with **no intent to harm** any real system, person, or organisation
- Follow ethical hacking principles as taught in OSCP, CEH, and similar certifications

---

## 🚫 Do Not Use These Techniques On

- Systems you do not own
- Systems without explicit written authorisation
- Any production, corporate, or public infrastructure
- Any third-party networks or devices

Unauthorised use of these techniques is **illegal** under the Computer Fraud and Abuse Act (CFAA), IT Act 2000 (India), and similar laws in other jurisdictions.

---

## 📢 Responsible Disclosure

If you discover any actual security vulnerabilities through your own legitimate security research, please follow responsible disclosure practices:

1. **Do not** exploit the vulnerability beyond what is necessary to demonstrate it
2. **Do not** access, modify, or delete data that is not yours
3. **Report** vulnerabilities to the affected organisation through their official security channels
4. **Allow** a reasonable remediation period before public disclosure

---

## 🛡️ Defensive Resources

If you are a defender looking to protect against these techniques:

- **Kerberoasting:** Use gMSA accounts, enforce AES-256, monitor Event ID 4769
- **C2 Detection:** Deploy EDR, monitor HTTP beaconing patterns, use network segmentation
- **Privilege Escalation:** Remove SeImpersonatePrivilege from non-service accounts
- **AD Auditing:** Run BloodHound CE quarterly as a defensive audit tool
- **SIEM:** Alert on Event IDs 4688, 4624/4625, 4768/4769, 4771

---

## 📬 Contact

**Rithika Ujjalsingh**
- LinkedIn: [linkedin.com/in/rithikasingh2626](https://linkedin.com/in/rithikasingh2626)
- GitHub: [github.com/rithika-ujjalsingh](https://github.com/rithika-ujjalsingh)

---

*This security policy is part of the RIVI Enterprises Elite Portfolio System.*
