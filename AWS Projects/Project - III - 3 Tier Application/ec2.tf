# Web tier
resource "aws_instance" "web" {
    count = length(aws_subnet.public)
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public[count.index].id
    associate_public_ip_address = true
     key_name                    = "terraform_ec2"
     vpc_security_group_ids = [aws_security_group.web_sg.id]

    user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    echo "<h1>Welcome to Web-srv-${local.roman[count.index]}</h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = { Name = "Web-srv-${local.roman[count.index]}" }
  
}

# App tier 
resource "aws_instance" "app" {
    count = length(aws_subnet.private)
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.private[count.index].id
    key_name                    = "terraform_ec2"
    vpc_security_group_ids = [aws_security_group.app_sg.id]

      user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3-pip default-libmysqlclient-dev python3-dev
    pip3 install flask PyMySQL

    cat <<EOL > /home/ubuntu/app.py
    from flask import Flask, request
    import pymysql

    conn = pymysql.connect(
      host='${aws_db_instance.rds.address}',
      user='${var.db_username}',
      password='${var.db_password}',
      db='${var.db_name}'
    )

    app = Flask(__name__)

    @app.route('/health')
    def health():
        return "App-srv-${local.roman[count.index]} is healthy", 200

    @app.route('/write', methods=['POST'])
    def write():
        msg = request.form.get('message', 'no message')
        with conn.cursor() as cur:
            cur.execute("CREATE TABLE IF NOT EXISTS messages (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255));")
            cur.execute("INSERT INTO messages (message) VALUES (%s);", (msg,))
            conn.commit()
        return f"Inserted: {msg}", 201

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=5000)
    EOL

    chown ubuntu:ubuntu /home/ubuntu/app.py
    nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &
  EOF

  tags = { Name = "App-srv-${local.roman[count.index]}" }

  
}