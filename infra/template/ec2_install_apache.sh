#! /bin/bash
# shellcheck disable=SC2164
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install python3 python3-pip git nginx
git clone https://github.com/DeshmukhRuturaj/Resumate-ai.git
sleep 20
# shellcheck disable=SC2164
cd Resumate-ai
pip3 install -r requirements.txt
echo 'Installing streamlit if not already included in requirements.txt'
pip3 install streamlit

# Configure Nginx as reverse proxy
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo 'Waiting for 60 seconds before running the streamlit app'
sleep 60
cd App
# Run streamlit in background and keep it running
nohup streamlit run App_Updated_Backup.py --server.port 5000 --server.address 127.0.0.1 > /tmp/streamlit.log 2>&1 &
sleep 10
echo "Streamlit app started on port 5000, accessible via Nginx on port 80"