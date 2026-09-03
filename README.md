# Learn Akademy - Java Maven Tomcat Deployment Lab

## DevOps Pipeline

```
Java Source Code
       |
       v
     Maven
       | mvn clean package
       v
   WAR Artifact  <-- learnakademy.war (this file is in target/)
       |
       v
 Apache Tomcat
       |
       v
Running Web Application
```

---

## Project Structure

```
learnakademy-java-demo/
├── pom.xml                                        # Maven build config (packaging: war, Java 17)
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/learnakademy/
│   │   │   └── AppInfo.java                       # App metadata class
│   │   └── webapp/
│   │       ├── index.jsp                          # Main page
│   │       └── health.jsp                         # Health check endpoint
│   └── test/java/com/learnakademy/
│       └── AppInfoTest.java                       # 9 JUnit unit tests
└── target/
    └── learnakademy.war                           # <-- BUILT ARTIFACT (ready to deploy)
```

---

## The WAR File

The pre-built artifact is located at:

```
target/learnakademy.war
```

This is a standard Java WAR file. You can:
- Copy it directly to any Tomcat `webapps/` directory to deploy it
- Transfer it to an EC2 instance via `scp`
- Upload it via the Tomcat Manager web UI

---

## Option A: Deploy on an Ubuntu EC2 Instance

### Step 1 — Launch EC2 and open ports

1. Launch an Ubuntu 22.04 or 24.04 EC2 instance (t2.micro is fine for lab)
2. In the EC2 Security Group, add these **Inbound Rules**:
   - SSH: TCP port **22** — your IP
   - Custom TCP: port **8080** — 0.0.0.0/0 (or your IP)

### Step 2 — SSH into your instance

```bash
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

### Step 3 — Install Java 17

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

### Step 4 — Install Maven

```bash
sudo apt install -y maven
mvn -version
```

### Step 5 — Install Tomcat (auto-detect 10 or 9)

```bash
# Check if tomcat10 is available
apt-cache show tomcat10 &>/dev/null && TOMCAT=tomcat10 || TOMCAT=tomcat9
echo "Installing: $TOMCAT"
sudo apt install -y $TOMCAT

# Verify
sudo systemctl status $TOMCAT
```

### Step 6 — Transfer the WAR to EC2

**From your local machine (Windows CMD / PowerShell):**

```powershell
scp -i your-key.pem target\learnakademy.war ubuntu@<EC2-PUBLIC-IP>:/home/ubuntu/
```

**From your local machine (Linux/Mac terminal):**

```bash
scp -i your-key.pem target/learnakademy.war ubuntu@<EC2-PUBLIC-IP>:/home/ubuntu/
```

### Step 7 — Deploy the WAR on EC2

Back on the EC2 instance:

```bash
# Detect the correct webapps directory
if   [ -d /var/lib/tomcat10/webapps ]; then WEBAPPS=/var/lib/tomcat10/webapps; TOMCAT=tomcat10
elif [ -d /var/lib/tomcat9/webapps  ]; then WEBAPPS=/var/lib/tomcat9/webapps;  TOMCAT=tomcat9
fi

echo "Deploying to: $WEBAPPS"
sudo cp /home/ubuntu/learnakademy.war $WEBAPPS/
sudo systemctl restart $TOMCAT
sudo systemctl status  $TOMCAT
```

### Step 8 — Wait and verify

```bash
# Wait for Tomcat to extract the WAR (usually 5-10 seconds)
sleep 10

# Test the application
curl http://localhost:8080/learnakademy/
curl http://localhost:8080/learnakademy/health.jsp
```

### Step 9 — Access from your browser

```
http://<EC2-PUBLIC-IP>:8080/learnakademy/
http://<EC2-PUBLIC-IP>:8080/learnakademy/health.jsp
```

> **Reminder:** Port 8080 must be open in your EC2 Security Group inbound rules.

---

## Option B: Build and Deploy Locally on Ubuntu (no EC2)

Use this if you want to run the full lab on any Ubuntu desktop or server.

### Step 1 — Install Java 17, Maven, Tomcat

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk maven

# Install Tomcat (try 10 first, fall back to 9)
apt-cache show tomcat10 &>/dev/null && TOMCAT=tomcat10 || TOMCAT=tomcat9
sudo apt install -y $TOMCAT

java -version
mvn -version
sudo systemctl status $TOMCAT
```

### Step 2 — Clone or copy the project

```bash
# If you have git
git clone <your-repo-url> /opt/learnakademy-java-demo
cd /opt/learnakademy-java-demo

# OR just copy the project folder
sudo cp -r /path/to/project /opt/learnakademy-java-demo
cd /opt/learnakademy-java-demo
```

### Step 3 — Build with Maven

```bash
cd /opt/learnakademy-java-demo

mvn clean
mvn compile
mvn test
mvn package

# Verify WAR was created
ls -lh target/learnakademy.war
```

Expected output:

```
[INFO] BUILD SUCCESS
...
-rw-r--r-- 1 user user 4.8K Aug 27 21:30 target/learnakademy.war
```

### Step 4 — Deploy to Tomcat

```bash
# Auto-detect webapps directory
if   [ -d /var/lib/tomcat10/webapps ]; then WEBAPPS=/var/lib/tomcat10/webapps; TOMCAT=tomcat10
elif [ -d /var/lib/tomcat9/webapps  ]; then WEBAPPS=/var/lib/tomcat9/webapps;  TOMCAT=tomcat9
fi

sudo cp target/learnakademy.war $WEBAPPS/
sudo systemctl restart $TOMCAT
sudo systemctl status  $TOMCAT
```

### Step 5 — Verify deployment

```bash
sleep 10
curl http://localhost:8080/learnakademy/
curl http://localhost:8080/learnakademy/health.jsp
```

### Step 6 — Open in browser

```
http://localhost:8080/learnakademy/
http://localhost:8080/learnakademy/health.jsp
```

---

## Troubleshooting

**Tomcat not starting:**
```bash
sudo journalctl -u tomcat10 -n 50
# or
sudo cat /var/log/tomcat10/catalina.out
```

**404 after deploying WAR:**
```bash
# WAR may still be extracting — wait and retry
sleep 15
curl http://localhost:8080/learnakademy/
```

**Permission denied copying WAR:**
```bash
sudo cp target/learnakademy.war /var/lib/tomcat10/webapps/
sudo chown tomcat:tomcat /var/lib/tomcat10/webapps/learnakademy.war
```

**Check which port Tomcat is using:**
```bash
sudo grep 'Connector port' /etc/tomcat10/server.xml
# or
sudo ss -tlnp | grep java
```

---

## Application Info

| Property           | Value                                 |
|--------------------|---------------------------------------|
| App Name           | learnakademy                          |
| Version            | 1.0                                   |
| Environment        | Development                           |
| Deployment Status  | SUCCESS                               |
| Server             | Apache Tomcat                         |
| Pipeline           | Source Code → Maven → WAR → Tomcat   |

---

## Endpoints

| Endpoint                                       | Returns              |
|------------------------------------------------|----------------------|
| `http://<HOST>:8080/learnakademy/`            | Main HTML page       |
| `http://<HOST>:8080/learnakademy/health.jsp`  | JSON health status   |

---

## Technology Stack

| Tool    | Version  |
|---------|----------|
| Java    | 17       |
| Maven   | 3.9+     |
| Tomcat  | 9 or 10  |
| JSP     | 3.1      |

---

*Learn Akademy DevOps Lab — Java + Maven + Apache Tomcat*
