#! /bin/bash
# shellcheck disable=SC2164
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install python3 python3-pip
git clone https://github.com/DeshmukhRuturaj/Resumate-ai.git
sleep 20
# shellcheck disable=SC2164
cd Resumate-ai
pip3 install -r requirements.txt
echo 'Installing streamlit if not already included in requirements.txt'
pip3 install streamlit
echo 'Waiting for 30 seconds before running the streamlit app'
sleep 30
cd App
setsid streamlit run App_Updated_Backup.py --server.port 5000 --server.address 0.0.0.0 &
sleep 10