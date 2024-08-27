sudo apt update -y
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Hello World from $(hostname -f)" > /var/www/html/index.html