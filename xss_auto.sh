#!/bin/bash
echo -e '
   ____
 /     \
| () () |
 \  ^  /
  |||||
  |||||  - made by k1gh7m4re'
  
# Ask for the domain name
read -p "Enter the domain name: " domain_name

mkdir $domain_name
cd $domain_name

# Run waybackurls command and save the output to archive_links file
echo "[+] Running waybackurls"

waybackurls $domain_name -no-subs > archive_links

# Run gau command and append the output to archive_links file
echo "[+] Running gau"
gau $domain_name >> archive_links

# Sort the archive_links file and overwrite it with the sorted contents

sort -u archive_links -o archive_links1
echo "Running ParamSpider on $domain"
python3 "$home_dir/ParamSpider/paramspider.py" -d "$domain_name" --exclude png,jpg,gif,jpeg,swf,woff,gif,svg --level high --quiet -o paramspider_output.txt

# Run uro command on archive_links file and append the output to archive_links_uro file

cat archive_links1 | uro | tee -a archive_links_uro

# Run grep and qsreplace commands on archive_links_uro file,
# and append the output to freq_xss_findings file
echo "[+] Starting qsreplace and freq"
cat archive_links_uro | grep "=" | qsreplace '"><img src=x onerror=alert(1)>' | freq | grep -iv "Not Vulnerable" | tee -a freq_xss_findings

echo "Script executed successfully."
