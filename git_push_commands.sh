#!/bin/bash
# ============================================================
# Project 04 — GitHub Push Script
# Run this on Kali after setting up repo structure
# ============================================================

echo "[*] Setting up Project 04 folder structure..."

# Create directory structure
mkdir -p ~/IT-Support-Portfolio-7-Projects/Project04-RedTeam-C2/report
mkdir -p ~/IT-Support-Portfolio-7-Projects/Project04-RedTeam-C2/screenshots
mkdir -p ~/IT-Support-Portfolio-7-Projects/Project04-RedTeam-C2/scripts

PROJECT="~/IT-Support-Portfolio-7-Projects/Project04-RedTeam-C2"

echo "[*] Copy your files:"
echo ""
echo "  cp README.md          $PROJECT/"
echo "  cp SECURITY.md        $PROJECT/"
echo "  cp CHANGELOG.md       $PROJECT/"
echo "  cp .gitignore         $PROJECT/"
echo "  cp RedTeam_Report_Project04.pdf  $PROJECT/report/"
echo "  cp generate_report.py $PROJECT/scripts/"
echo ""
echo "  # Screenshots (your actual lab screenshots):"
echo "  cp 01_sliver_running.png    $PROJECT/screenshots/"
echo "  cp 02_listener_implant.png  $PROJECT/screenshots/"
echo "  cp 03_session_opened.png    $PROJECT/screenshots/"
echo "  cp 04_whoami_session.png    $PROJECT/screenshots/"
echo "  cp 05_privesc_shell.png     $PROJECT/screenshots/"
echo "  cp 06_privesc_system.png    $PROJECT/screenshots/"
echo "  cp 07_domain_enum.png       $PROJECT/screenshots/"
echo "  cp 08_sharphound_complete.png     $PROJECT/screenshots/"
echo "  cp 09_bloodhound_download.png     $PROJECT/screenshots/"
echo "  cp 10_bloodhound_login.png        $PROJECT/screenshots/"
echo "  cp 11_bloodhound_ui.png           $PROJECT/screenshots/"
echo "  cp 12_bloodhound_Zip_File_Upload_Completed.png $PROJECT/screenshots/"
echo ""

echo "[*] Git commands:"
echo ""
echo "  cd ~/IT-Support-Portfolio-7-Projects"
echo "  git add Project04-RedTeam-C2/"
echo "  git commit -m 'Add Project 04: Full Red Team C2 Infrastructure"
echo ""
echo "  - Sliver C2 v1.5.42 with HTTP C2 session"
echo "  - NT AUTHORITY\\SYSTEM via privilege escalation"
echo "  - BloodHound CE: 319 AD objects collected"
echo "  - 12 screenshots + professional pentest report"
echo "  - MITRE ATT&CK: T1566, T1071.001, T1087, T1558.003, T1068'"
echo ""
echo "  git push origin main"
echo ""
echo "[+] Done! Check github.com/rithika-ujjalsingh/IT-Support-Portfolio-7-Projects"
