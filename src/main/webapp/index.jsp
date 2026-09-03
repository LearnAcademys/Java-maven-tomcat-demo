<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learnakademy.AppInfo" %>
<%
    AppInfo app = new AppInfo();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= app.getAppTitle() %> - DevOps Lab</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Courier New', Courier, monospace;
            background-color: #0d1117;
            color: #c9d1d9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background-color: #161b22;
            border: 1px solid #30363d;
            border-radius: 8px;
            padding: 40px;
            max-width: 700px;
            width: 100%;
            box-shadow: 0 0 30px rgba(88, 166, 255, 0.15);
        }

        .header {
            text-align: center;
            border-bottom: 2px solid #58a6ff;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #58a6ff;
            font-size: 2.2rem;
            letter-spacing: 3px;
            text-transform: uppercase;
        }

        .header p {
            color: #8b949e;
            margin-top: 8px;
            font-size: 0.9rem;
        }

        .divider {
            text-align: center;
            color: #58a6ff;
            font-size: 1.1rem;
            letter-spacing: 2px;
            margin: 20px 0;
        }

        .info-block {
            background-color: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
            padding: 20px 25px;
            margin: 15px 0;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #21262d;
        }

        .info-row:last-child { border-bottom: none; }

        .label { color: #8b949e; font-size: 0.85rem; }

        .value {
            color: #c9d1d9;
            font-weight: bold;
            font-size: 0.85rem;
        }

        .value.success { color: #3fb950; }
        .value.version { color: #ffa657; }
        .value.env     { color: #79c0ff; }

        .pipeline {
            background-color: #0d1117;
            border: 1px solid #3fb950;
            border-radius: 6px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
        }

        .pipeline h3 {
            color: #3fb950;
            margin-bottom: 15px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .pipeline-steps {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 5px;
            font-size: 0.8rem;
        }

        .step {
            background-color: #161b22;
            border: 1px solid #58a6ff;
            border-radius: 4px;
            padding: 5px 12px;
            color: #58a6ff;
        }

        .arrow { color: #3fb950; font-size: 1rem; }

        .health-link {
            text-align: center;
            margin-top: 20px;
            padding: 12px;
            background-color: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
        }

        .health-link a {
            color: #58a6ff;
            text-decoration: none;
            font-size: 0.85rem;
        }

        .health-link a:hover { text-decoration: underline; }

        .footer {
            text-align: center;
            margin-top: 25px;
            color: #8b949e;
            font-size: 0.75rem;
            border-top: 1px solid #30363d;
            padding-top: 15px;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <h1><%= app.getAppTitle() %></h1>
        <p><%= app.getLabName() %></p>
    </div>

    <div class="divider">-----------------------------------</div>

    <div class="info-block">
        <div class="info-row">
            <span class="label">Application Name</span>
            <span class="value"><%= app.getAppTitle() %></span>
        </div>
        <div class="info-row">
            <span class="label">Sub-Title</span>
            <span class="value">Java Maven Tomcat Deployment Lab</span>
        </div>
        <div class="info-row">
            <span class="label">Application Version</span>
            <span class="value version"><%= app.getVersion() %></span>
        </div>
        <div class="info-row">
            <span class="label">Environment</span>
            <span class="value env"><%= app.getEnvironment() %></span>
        </div>
        <div class="info-row">
            <span class="label">Deployment Status</span>
            <span class="value success"><%= app.getDeploymentStatus() %></span>
        </div>
        <div class="info-row">
            <span class="label">Server</span>
            <span class="value"><%= app.getServer() %></span>
        </div>
    </div>

    <div class="divider">-----------------------------------</div>

    <div class="pipeline">
        <h3>DevOps Pipeline</h3>
        <div class="pipeline-steps">
            <span class="step">Source Code</span>
            <span class="arrow">&#8594;</span>
            <span class="step">Maven</span>
            <span class="arrow">&#8594;</span>
            <span class="step">WAR</span>
            <span class="arrow">&#8594;</span>
            <span class="step">Tomcat</span>
        </div>
    </div>

    <div class="divider">-----------------------------------</div>

    <div class="health-link">
        Health Check Endpoint:
        <a href="health.jsp">/learnakademy/health.jsp</a>
    </div>

    <div class="footer">
        &copy; <%= new java.util.Date().getYear() + 1900 %> Learn Akademy DevOps Lab |
        Built with Java 17 + Maven + Apache Tomcat
    </div>

</div>
</body>
</html>
