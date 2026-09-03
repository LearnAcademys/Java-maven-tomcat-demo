<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learnakademy.AppInfo" %>
<%
    AppInfo app = new AppInfo();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
{
  "status": "UP",
  "application": "<%= app.getAppName() %>",
  "version": "<%= app.getVersion() %>",
  "environment": "<%= app.getEnvironment() %>",
  "server": "<%= app.getServer() %>",
  "timestamp": "<%= new java.util.Date().toString() %>"
}
