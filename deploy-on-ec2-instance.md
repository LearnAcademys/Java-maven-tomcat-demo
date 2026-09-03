# How to Deploy learnakademy on an AWS EC2 Ubuntu Instance
### Learn Akademy — Java Maven Tomcat Deployment Lab

---

## What You Will Do

Take the `learnakademy.war` file built by Maven on your local machine,
transfer it to a fresh Ubuntu EC2 server, install Java 17 and Tomcat 10,
deploy the WAR, and access the running app from your browser.

Final result:
```
http://<YOUR-EC2-PUBLIC-IP>:8080/learnakademy/
```

---

## What You Need Before Starting

| Requirement | Details |
|---|---|
| AWS Account | Free tier is fine |
| EC2 Instance | Ubuntu 22.04, 24.04, or 26.04 — t2.micro or larger |
| Key Pair (.pem file) | Downloaded when you created the EC2 instance |
| The WAR file | `target/learnakademy.war` — already built by Maven |
| Git Bash | Use Git Bash on Windows for scp and ssh commands |

---

## PART 1 — Launch and Configure Your EC2 Instance

### Step 1.1 — Launch an EC2 Instance

1. Log into AWS Console → go to **EC2** → click **Launch Instance**
2. Settings:
   - **Name:** `learnakademy-server`
   - **AMI:** Ubuntu Server 22.04 or 24.04 LTS
   - **Instance type:** `t2.micro`
   - **Key pair:** Create new → name it `learnakademy-server` → format `.pem` → **Download it**
   - **Storage:** 8 GB
3. Click **Launch Instance** and wait until state shows **running**

---

### Step 1.2 — Open Port 8080 in the Security Group

Without this your browser cannot reach Tomcat. Do not skip it.

1. Click your instance → click the **Security** tab
2. Click the Security Group link
3. Click **Edit inbound rules** → **Add rule**:

   | Field | Value |
   |---|---|
   | Type | Custom TCP |
   | Port range | 8080 |
   | Source | Anywhere-IPv4 (0.0.0.0/0) |

4. Click **Save rules**

> Port 22 (SSH) must also be open. Add it if missing.

---

### Step 1.3 — Get Your EC2 Public IP

On your EC2 instance page, copy the **Public IPv4 address** (e.g. `52.90.49.217`).
You will use this in every command below.

---

## PART 2 — Connect via SSH

Open **Git Bash** on your Windows machine. Do not use PowerShell for these commands.

```bash
ssh -i ~/Downloads/learnakademy-server.pem ubuntu@<EC2-PUBLIC-IP>
```

Real example:
```bash
ssh -i ~/Downloads/learnakademy-server.pem ubuntu@52.90.49.217
```

When prompted `Are you sure you want to continue connecting?` type `yes`.

You are connected when you see:
```
ubuntu@ip-172-31-xx-xx:~$
```

> **Key file name:** When AWS asks you to name the key pair, note the exact name.
> The downloaded file will be named exactly what you typed, with `.pem` at the end.
> For example if you named it `learnakademy-server` the file is `learnakademy-server.pem`.
> Check the exact name with: `ls ~/Downloads/*.pem`

---

## PART 3 — Install Java 17 on EC2

Run these on the EC2 server (in your SSH session).

```bash
sudo apt update
```

Wait for it to finish, then:

```bash
sudo apt install -y openjdk-17-jdk
```

Verify:
```bash
java -version
```

Expected:
```
openjdk version "17.0.x" ...
```

---

## PART 4 — Install Apache Tomcat 10 Manually

> **Critical warning for Ubuntu 24.04 and 26.04:**
> Running `sudo apt install tomcat10` installs a completely broken package —
> no service, no files, nothing works. Do NOT use apt for Tomcat on these versions.
> Always install Tomcat manually from the official Apache download as shown below.

### Step 4.1 — Download Tomcat 10.1.59

```bash
cd /home/ubuntu
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.59/bin/apache-tomcat-10.1.59.tar.gz
```

Progress bar appears. File is ~14 MB. When done you see:
```
'apache-tomcat-10.1.59.tar.gz' saved [14424246/14424246]
```

### Step 4.2 — Extract into /opt

```bash
sudo tar -xzf apache-tomcat-10.1.59.tar.gz -C /opt/
```

### Step 4.3 — Rename to a clean folder name

```bash
sudo mv /opt/apache-tomcat-10.1.59 /opt/tomcat10
```

Verify:
```bash
ls -la /opt/
```

You should see `tomcat10` with 10 items inside.

### Step 4.4 — Make startup scripts executable

```bash
sudo chmod +x /opt/tomcat10/bin/startup.sh /opt/tomcat10/bin/shutdown.sh /opt/tomcat10/bin/catalina.sh
```

---

## PART 5 — Transfer the WAR File from Your Computer to EC2

Open a **new Git Bash window on your local machine** (not the SSH session).

```bash
scp -i ~/Downloads/learnakademy-server.pem \
    ~/Documents/Learnakademyproject4/target/learnakademy.war \
    ubuntu@<EC2-PUBLIC-IP>:/home/ubuntu/
```

Real example:
```bash
scp -i ~/Downloads/learnakademy-server.pem ~/Documents/Learnakademyproject4/target/learnakademy.war ubuntu@52.90.49.217:/home/ubuntu/
```

Success looks like:
```
learnakademy.war     100% 4941     7.8KB/s   00:00
```

Confirm it arrived — back in your SSH session:
```bash
ls -lh /home/ubuntu/learnakademy.war
```

---

## PART 6 — Deploy the WAR to Tomcat

### Step 6.1 — Copy WAR into the Tomcat webapps directory

```bash
sudo cp /home/ubuntu/learnakademy.war /opt/tomcat10/webapps/
```

Verify:
```bash
sudo ls -lh /opt/tomcat10/webapps/
```

You should see `learnakademy.war` and a `learnakademy/` folder — the folder means
Tomcat already extracted it.

---

## PART 7 — Start the Correct Tomcat

> **Important:** Ubuntu 24/26 may have a broken apt Tomcat running in the background
> on port 8080. If you curl and get a 404 that says `Apache Tomcat/10.1.55 (Ubuntu)`
> at the bottom, that is the wrong instance. Kill it and start yours.

### Step 7.1 — Kill any existing Tomcat process

```bash
sudo pkill -f tomcat
```

Wait 3 seconds:
```bash
sleep 3
```

### Step 7.2 — Start your Tomcat

```bash
sudo /opt/tomcat10/bin/startup.sh
```

You should see:
```
Using CATALINA_BASE:   /opt/tomcat10
Using CATALINA_HOME:   /opt/tomcat10
...
Tomcat started.
```

### Step 7.3 — Confirm it is listening on port 8080

```bash
sudo ss -tlnp | grep 8080
```

Expected:
```
LISTEN  0  100  *:8080  *:*  users:(("java",...))
```

---

## PART 8 — Verify the Deployment

### Step 8.1 — Wait for WAR extraction then curl

```bash
sleep 15
curl http://localhost:8080/learnakademy/
```

You should see your Learn Akademy HTML in the terminal.

```bash
curl http://localhost:8080/learnakademy/health.jsp
```

You should see:
```json
{
  "status": "UP",
  "application": "learnakademy",
  "version": "1.0",
  "environment": "Development",
  "server": "Apache Tomcat",
  "timestamp": "..."
}
```

> Confirm the response footer says `Apache Tomcat/10.1.59` — that confirms you are
> running your manually installed Tomcat, not the broken apt one.

### Step 8.2 — Open in your browser

```
http://<EC2-PUBLIC-IP>:8080/learnakademy/
```

```
http://<EC2-PUBLIC-IP>:8080/learnakademy/health.jsp
```

---

## PART 9 — Keep Tomcat Running After Reboot

The manual startup above stops when the server reboots. Create a systemd service
so Tomcat starts automatically.

### Step 9.1 — Find your Java home

```bash
dirname $(dirname $(readlink -f $(which java)))
```

Copy the output — looks like `/usr/lib/jvm/java-17-openjdk-amd64` or just `/usr`.

### Step 9.2 — Create the service file

```bash
sudo nano /etc/systemd/system/tomcat10.service
```

Paste this (replace `JAVA_HOME` with the value from Step 9.1 if different):

```ini
[Unit]
Description=Apache Tomcat 10
After=network.target

[Service]
Type=forking
User=root
Group=root
Environment="JAVA_HOME=/usr"
Environment="CATALINA_HOME=/opt/tomcat10"
ExecStart=/opt/tomcat10/bin/startup.sh
ExecStop=/opt/tomcat10/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Press `Ctrl+X` → `Y` → `Enter` to save.

### Step 9.3 — Enable and start

```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat10
sudo systemctl start tomcat10
sudo systemctl status tomcat10
```

---

## PART 10 — Troubleshooting

### 404 that says "Apache Tomcat/10.1.55 (Ubuntu)" at the bottom

The wrong apt-installed Tomcat is running. Kill it and start yours:
```bash
sudo pkill -f tomcat
sleep 3
sudo /opt/tomcat10/bin/startup.sh
sleep 15
curl http://localhost:8080/learnakademy/
```

---

### "This site can't be reached" in browser

Port 8080 is not open in the Security Group.
- EC2 Console → Security Groups → Edit inbound rules
- Add: Custom TCP, port 8080, source 0.0.0.0/0
- Save — no restart needed

---

### 404 on /learnakademy/ (correct Tomcat, app just not there yet)

```bash
# Check the WAR is in webapps
sudo ls /opt/tomcat10/webapps/

# Check Tomcat log for deployment progress
sudo tail -30 /opt/tomcat10/logs/catalina.out

# Wait longer and retry
sleep 20 && curl http://localhost:8080/learnakademy/
```

---

### scp fails — "Identity file not accessible"

The `.pem` filename is wrong. Find the exact name:
```bash
ls ~/Downloads/*.pem
```

Then use that exact filename in your scp command.

---

### scp fails — "Permission denied (publickey)"

Key file permissions are too open on Linux/Mac:
```bash
chmod 400 ~/Downloads/learnakademy-server.pem
```

Then retry scp.

---

### Tomcat not starting — port 8080 already in use

```bash
sudo ss -tlnp | grep 8080
sudo pkill -f tomcat
sleep 3
sudo /opt/tomcat10/bin/startup.sh
```

---

## Quick Reference — All Commands in Order

```bash
# ── ON EC2: Java ──────────────────────────────────────────────
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version

# ── ON EC2: Install Tomcat manually ──────────────────────────
cd /home/ubuntu
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.59/bin/apache-tomcat-10.1.59.tar.gz
sudo tar -xzf apache-tomcat-10.1.59.tar.gz -C /opt/
sudo mv /opt/apache-tomcat-10.1.59 /opt/tomcat10
sudo chmod +x /opt/tomcat10/bin/startup.sh /opt/tomcat10/bin/shutdown.sh /opt/tomcat10/bin/catalina.sh

# ── ON LOCAL MACHINE (Git Bash): Transfer WAR ────────────────
scp -i ~/Downloads/learnakademy-server.pem ~/Documents/Learnakademyproject4/target/learnakademy.war ubuntu@<EC2-IP>:/home/ubuntu/

# ── ON EC2: Deploy ────────────────────────────────────────────
sudo cp /home/ubuntu/learnakademy.war /opt/tomcat10/webapps/

# ── ON EC2: Kill wrong Tomcat, start correct one ─────────────
sudo pkill -f tomcat
sleep 3
sudo /opt/tomcat10/bin/startup.sh
sleep 15

# ── ON EC2: Verify ────────────────────────────────────────────
curl http://localhost:8080/learnakademy/
curl http://localhost:8080/learnakademy/health.jsp
```

---

## Final URLs

| Endpoint | URL |
|---|---|
| Main Application | `http://<EC2-PUBLIC-IP>:8080/learnakademy/` |
| Health Check | `http://<EC2-PUBLIC-IP>:8080/learnakademy/health.jsp` |

> Port **8080 must be open** in the EC2 Security Group inbound rules.
> The key file must be named exactly as downloaded — check with `ls ~/Downloads/*.pem`.

---

*Learn Akademy — DevOps Lab | Java 17 + Maven + Apache Tomcat 10.1.59 on AWS EC2 Ubuntu*
