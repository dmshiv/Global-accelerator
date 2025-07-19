#!/bin/bash
sudo yum install -y httpd

# Install Apache web server (httpd)
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Write your custom HydCafe HTML homepage
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Outlander</title>
</head>
<body>
    <h1>Guess you're in India! 🇮🇳</h1>
    <p>You’re accessing this content via the <strong>Mumbai region (ap-south-1)</strong> — your nearest AWS edge location.</p>
</body>
</html>
EOF