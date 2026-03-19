#!/bin/bash

# Color Codes for Styling
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

while true; do
  clear
  echo -e "${CYAN}=====================================================${NC}"
  echo -e "${CYAN}   🛡️  SWIFTENTRY HUB - AUTOMATION MENU             ${NC}"
  echo -e "${CYAN}=====================================================${NC}"
  echo -e "1️⃣  হোম পেজ আপডেট করুন (Welcome Gateway)"
  echo -e "2️⃣  অ্যাডমিন লগইন আপডেট করুন (Admin Login)"
  echo -e "3️⃣  স্টাফ লগইন আপডেট করুন (Staff Login)"
  echo -e "4️⃣  মেইন অ্যাডমিন প্যানেল আপডেট করুন (Admin Panel)"
  echo -e "5️⃣  স্টাফ ড্যাশবোর্ড আপডেট করুন (Staff Dashboard)"
  echo -e "6️⃣  লাইভ রাডার আপডেট করুন (Attendance Radar)"
  echo -e "7️⃣  স্টাফ ম্যানেজমেন্ট পেজ আপডেট করুন (Manage Staff)"
  echo -e "8️⃣  লগআউট ফাইল আপডেট করুন (Logout System)"
  echo -e "9️⃣  ডেটাবেস সেটআপ/আপডেট করুন (Database Reset)"
  echo -e "0️⃣  ❌ এক্সিট (Exit)"
  echo -e "${CYAN}-----------------------------------------------------${NC}"
  echo -n "👉 আপনার পছন্দ নির্বাচন করুন [0-9]: "
  read choice

  if [[ "$choice" == "0" ]]; then
    echo -e "${GREEN}👋 বিদায় বন্ধু! আবার দেখা হবে।${NC}"
    exit 0
  fi

  file_path=""
  case $choice in
    1) file_path="/var/www/html/index.php" ;;
    2) file_path="/var/www/html/login_admin.php" ;;
    3) file_path="/var/www/html/login_staff.php" ;;
    4) file_path="/var/www/html/admin.php" ;;
    5) file_path="/var/www/html/staff_dashboard.php" ;;
    6) file_path="/var/www/html/check_attendance.php" ;;
    7) file_path="/var/www/html/staff_manage.php" ;;
    8) file_path="/var/www/html/logout.php" ;;
    9) file_path="database" ;;
    *) echo -e "${RED}❌ ভুল ইনপুট! দয়া করে ০-৯ এর মধ্যে বেছে নিন।${NC}"; sleep 2; continue ;;
  esac

  if [[ "$file_path" == "database" ]]; then
    echo -e "${YELLOW}⚠️ আপনি কি পুরনো ডেটাবেস মুছে নতুন ডেটাবেস কোড দিতে চান? (y/n):${NC}"
    read confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      echo -e "${GREEN}📋 আপনার ডেটাবেস কোডটি এখানে পেস্ট করুন:${NC}"
      echo -e "${CYAN}(সব কোড পেস্ট করা শেষ হলে কিবোর্ডে Ctrl+D চাপুন)${NC}"
      cat > temp_db.sql
      sudo mysql < temp_db.sql
      rm temp_db.sql
      echo -e "${GREEN}✅ ডেটাবেস সফলভাবে আপডেট হয়েছে!${NC}"
    else
      echo -e "${RED}❌ আপডেট বাতিল করা হয়েছে।${NC}"
    fi
  else
    echo -e "${YELLOW}⚠️ আপনি কি $file_path এর পুরনো কোড মুছে নতুন কোড দিতে চান? (y/n):${NC}"
    read confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      echo -e "${GREEN}📋 আপনার নতুন কোডটি এখানে পেস্ট করুন:${NC}"
      echo -e "${CYAN}(সব কোড পেস্ট করা শেষ হলে কিবোর্ডে Ctrl+D চাপুন)${NC}"
      cat > "$file_path"
      echo -e "${GREEN}✅ ফাইলটি সফলভাবে আপডেট এবং সেভ করা হয়েছে!${NC}"
    else
      echo -e "${RED}❌ আপডেট বাতিল করা হয়েছে।${NC}"
    fi
  fi
  
  echo -e "${CYAN}-----------------------------------------------------${NC}"
  read -p "মেইন মেনুতে ফিরে যেতে Enter চাপুন..."
done
