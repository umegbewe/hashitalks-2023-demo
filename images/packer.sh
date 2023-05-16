sudo yum update -y
sudo yum install -y golang
cd /home/ec2-user/app && go mod tidy
go build -o main /home/ec2-user/app/main.go
sudo mkdir /usr/local/app && mv /home/ec2-user/app/main /usr/local/app
sudo sh -c 'printf "%s\n" \
"[Unit]" \
"Description=go-app" \
"[Service]" \
"Type=simple" \
"User=root" \
"Group=root" \
"WorkingDirectory=/usr/local/app" \
"ExecStart=/usr/local/app/main" \
"TimeoutSec=30" \
"RestartSec=15s" \
"Restart=always" \
"[Install]" \
"WantedBy=multi-user.target" \
> "/etc/systemd/system/go-app.service"'
sudo systemctl daemon-reload
sudo systemctl enable go-app
sudo systemctl start go-app
