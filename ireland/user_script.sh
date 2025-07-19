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
    <h1>Hey! You are likely in Europe 🇪🇺</h1>
    <p>This content is coming from <strong>Ireland region (eu-west-1)</strong>.</p>
</body>

</body>
</html>
EOF