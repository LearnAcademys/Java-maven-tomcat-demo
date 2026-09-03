# Student Lab Guide — Learn Akademy
## Java Maven Tomcat Deployment Lab

---

## Welcome

This lab teaches you how to deploy a Java web application to a live AWS EC2 server
using Maven and Apache Tomcat — the same tools used in real DevOps pipelines.

By the end of this lab your application will be running at:
```
http://<YOUR-EC2-PUBLIC-IP>:8080/learnakademy/
```

You have two options for completing this lab. Read both and pick the one that fits you.

---

## Which Option Should I Choose?

| | Option A | Option B |
|---|---|---|
| **Best for** | Beginners / first time | Intermediate / want full experience |
| **What you do** | Download pre-built WAR and deploy it | Clone source code, build it yourself, deploy it |
| **Java needed locally?** | No | Yes |
| **Maven needed locally?** | No | Yes |
| **Time to complete** | ~15 minutes | ~25 minutes |
| **What you learn** | EC2 setup + Tomcat deployment | Full pipeline: compile → test → package → deploy |

---

## Before You Start — Set Up Your EC2 Instance

Both options require an EC2 instance. Do this first.

### Step 1 — Log into AWS and launch an instance

1. Go to https://console.aws.amazon.com
2. Click **EC2** → click **Launch Instance**
3. Fill in:
   - **Name:** `learnakademy-server`
   - **AMI:** Ubuntu Server 22.04 LTS or 24.04 LTS
   - **Instance type:** `t2.micro` (free tier)
   - **Key pair:** Click **Create new key pair**
     - Name it anything — e.g. `my-lab-key`
     - Format: `.pem`
     - Click **Download key pair** — save the file, you need it to connect
4. Click **Launch Instance**
5. Wait until the instance state shows **running** (takes 1–2 minutes)

---

### Step 2 — Open port 8080 in the Security Group

This is required so your browser can reach the application.
If you skip this step the app will not load in your browser.

1. Click on your instance in the EC2 console
2. Click the **Security** tab
3. Click the Security Group link (looks like `sg-0abc123...`)
4. Click **Edit inbound rules** → **Add rule**

   | Field | Value |
   |---|---|
   | Type | Custom TCP |
   | Port range | 8080 |
   | Source | Anywhere-IPv4 (0.0.0.0/0) |

5. Click **Save rules**

---

### Step 3 — Find your EC2 Public IP address

On your instance page, copy the **Public IPv4 address** — looks like `52.90.49.217`.
You will use this IP address in the commands below and to open the app in your browser.

---

### Step 4 — Connect to your EC2 instance via SSH

Open **Git Bash** (Windows) or your **Terminal** (Mac/Linux).

```bash
ssh -i ~/Downloads/my-lab-key.pem ubuntu@<YOUR-EC2-PUBLIC-IP>
```

Replace `my-lab-key.pem` with whatever you named your key file.
Replace `<YOUR-EC2-PUBLIC-IP>` with the IP from Step 3.

When prompted:
```
Are you sure you want to continue connecting (yes/no)?
```
Type `yes` and press Enter.

You are connected when you see:
```
ubuntu@ip-172-31-xx-xx:~$
```

All commands from this point run on your EC2 server.

---

### Step 5 — Install Java 17 on EC2

```bash
sudo apt update
```

Wait for it to finish, then:

```bash
sudo apt install -y openjdk-17-jdk
```

Verify it worked:
```bash
java -version
```

You should see:
```
openjdk version "17.0.x" ...
```

---

### Step 6 — Install Apache Tomcat 10 on EC2

> **Important:** Do NOT use `sudo apt install tomcat10`.
> On Ubuntu 24.04 and 26.04 that command installs a broken empty package.
> Always install Tomcat manually using the steps below.

```bash
cd /home/ubuntu
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.59/bin/apache-tomcat-10.1.59.tar.gz
```

Wait for the download to finish (about 14 MB), then:

```bash
sudo tar -xzf apache-tomcat-10.1.59.tar.gz -C /opt/
sudo mv /opt/apache-tomcat-10.1.59 /opt/tomcat10
sudo chmod +x /opt/tomcat10/bin/startup.sh /opt/tomcat10/bin/shutdown.sh /opt/tomcat10/bin/catalina.sh
```

Verify Tomcat is installed:
```bash
ls /opt/tomcat10/
```

You should see folders: `bin  conf  lib  logs  temp  webapps  work`

---

## OPTION A — Deploy the Pre-Built WAR (No Maven Required)

The WAR file is already built and sitting in this GitHub repository.
You just download it directly onto your EC2 server and deploy it.

### Step A1 — Download the WAR file directly onto EC2

Make sure you are in your SSH session on EC2, then run:

```bash
wget https://github.com/LearnAcademys/Java-maven-tomcat-demo/raw/main/target/learnakademy.war
```

Confirm it downloaded:
```bash
ls -lh learnakademy.war
```

You should see the file listed at about 4.9 KB.

### Step A2 — Deploy the WAR to Tomcat

```bash
sudo cp learnakademy.war /opt/tomcat10/webapps/
```

Verify it is in the webapps folder:
```bash
sudo ls /opt/tomcat10/webapps/
```

You should see `learnakademy.war` listed alongside ROOT, docs, examples, manager.

### Step A3 — Start Tomcat

```bash
sudo /opt/tomcat10/bin/startup.sh
```

You should see:
```
Using CATALINA_BASE:   /opt/tomcat10
...
Tomcat started.
```

### Step A4 — Wait and test

```bash
sleep 15
curl http://localhost:8080/learnakademy/
```

You should see HTML printed in the terminal. That means the app is running.

```bash
curl http://localhost:8080/learnakademy/health.jsp
```

You should see:
```json
{
  "status": "UP",
  "application": "learnakademy",
  "version": "1.0"
}
```

### Step A5 — Open in your browser

```
http://<YOUR-EC2-PUBLIC-IP>:8080/learnakademy/
```

You should see the Learn Akademy application page. Lab complete.

---

## OPTION B — Clone the Repo, Build with Maven, and Deploy

This option gives you the full DevOps pipeline experience.
You will compile Java source code, run unit tests, package a WAR file with Maven,
and deploy it to Tomcat — exactly how it works in professional teams.

### Step B1 — Install Maven on EC2

You should still be in your SSH session on EC2.

```bash
sudo apt install -y maven
```

Verify:
```bash
mvn -version
```

You should see:
```
Apache Maven 3.x.x ...
```

### Step B2 — Clone the repository

```bash
cd /home/ubuntu
git clone https://github.com/LearnAcademys/Java-maven-tomcat-demo.git
cd Java-maven-tomcat-demo
```

You should now be inside the project folder:
```bash
ls
```

You should see: `pom.xml  README.md  STUDENTS.md  deploy-on-ec2-instance.md  src/  target/`

### Step B3 — Clean any previous build

```bash
mvn clean
```

Expected output:
```
[INFO] BUILD SUCCESS
```

### Step B4 — Compile the Java source code

```bash
mvn compile
```

Maven will:
- Read `pom.xml`
- Download any required dependencies
- Compile `AppInfo.java` using Java 17

Expected output:
```
[INFO] Compiling 1 source file...
[INFO] BUILD SUCCESS
```

### Step B5 — Run the unit tests

```bash
mvn test
```

Maven will:
- Compile the test class `AppInfoTest.java`
- Run all 9 JUnit tests against `AppInfo`
- Report the results

Expected output:
```
[INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

All 9 tests must pass before you move on. If any test fails, do not continue.

### Step B6 — Package the WAR file

```bash
mvn package
```

Maven will:
- Run the tests again
- Bundle `AppInfo.class`, `index.jsp`, and `health.jsp` into a single WAR file
- Save it to `target/learnakademy.war`

Expected output:
```
[INFO] Building war: /home/ubuntu/Java-maven-tomcat-demo/target/learnakademy.war
[INFO] BUILD SUCCESS
```

Verify the WAR was created:
```bash
ls -lh target/learnakademy.war
```

You should see the file listed at about 4.9 KB.

### Step B7 — Deploy the WAR to Tomcat

```bash
sudo cp target/learnakademy.war /opt/tomcat10/webapps/
```

Verify it is in the webapps folder:
```bash
sudo ls /opt/tomcat10/webapps/
```

You should see `learnakademy.war` listed.

### Step B8 — Start Tomcat

```bash
sudo /opt/tomcat10/bin/startup.sh
```

Expected output:
```
Using CATALINA_BASE:   /opt/tomcat10
...
Tomcat started.
```

### Step B9 — Wait and test

```bash
sleep 15
curl http://localhost:8080/learnakademy/
```

You should see HTML in the terminal.

```bash
curl http://localhost:8080/learnakademy/health.jsp
```

You should see:
```json
{
  "status": "UP",
  "application": "learnakademy",
  "version": "1.0"
}
```

### Step B10 — Open in your browser

```
http://<YOUR-EC2-PUBLIC-IP>:8080/learnakademy/
```

You should see the Learn Akademy application page. Lab complete.

---

## Troubleshooting

### "This site can't be reached" in browser

Port 8080 is not open in your Security Group.
Go back to **Before You Start → Step 2** and add the inbound rule for port 8080.

---

### curl returns 404 Not Found

Tomcat is running but has not finished extracting the WAR yet. Wait longer:
```bash
sleep 20
curl http://localhost:8080/learnakademy/
```

Also check the WAR is actually in webapps:
```bash
sudo ls /opt/tomcat10/webapps/
```

---

### 404 that says "Apache Tomcat/10.1.55 (Ubuntu)" at the bottom

A broken apt-installed Tomcat is running instead of yours. Kill it and start the right one:
```bash
sudo pkill -f tomcat
sleep 3
sudo /opt/tomcat10/bin/startup.sh
sleep 15
curl http://localhost:8080/learnakademy/
```

---

### Tomcat does not start — nothing on port 8080

Read the log to find the error:
```bash
cat /opt/tomcat10/logs/catalina.out | tail -40
```

---

### ssh: Permission denied (publickey)

Your key file either has the wrong name or wrong permissions.

Find the exact filename:
```bash
ls ~/Downloads/*.pem
```

Fix permissions (Linux/Mac only):
```bash
chmod 400 ~/Downloads/my-lab-key.pem
```

Then retry the ssh command with the exact filename.

---

### wget on the WAR returns 404

The URL may have changed. Go to:
```
https://github.com/LearnAcademys/Java-maven-tomcat-demo
```
Click `target/` → click `learnakademy.war` → right-click **Download** → copy the URL.

---

## What You Just Built — Pipeline Summary

```
GitHub Repository
       |
       v
git clone  (Option B only)
       |
       v
mvn compile  →  AppInfo.class
       |
       v
mvn test     →  9 tests passed
       |
       v
mvn package  →  learnakademy.war
       |
       v
scp / wget   →  WAR on EC2 server
       |
       v
Tomcat webapps/learnakademy.war
       |
       v
http://<EC2-IP>:8080/learnakademy/   ← YOUR APP IS LIVE
```

---

## Final Checklist

- [ ] EC2 instance launched and running
- [ ] Port 8080 open in Security Group
- [ ] SSH connected to EC2
- [ ] Java 17 installed (`java -version`)
- [ ] Tomcat 10 installed in `/opt/tomcat10`
- [ ] WAR file deployed to `/opt/tomcat10/webapps/`
- [ ] Tomcat started (`Tomcat started.` message seen)
- [ ] `curl http://localhost:8080/learnakademy/` returns HTML
- [ ] Browser opens `http://<EC2-IP>:8080/learnakademy/` successfully
- [ ] Health check returns JSON at `/learnakademy/health.jsp`

---

*Learn Akademy — DevOps Training Lab | Java 17 + Maven + Apache Tomcat 10 on AWS EC2*
