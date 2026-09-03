package com.learnakademy;

/**
 * AppInfo - Application Information Class
 * Learn Akademy Java Maven Tomcat Deployment Lab
 *
 * This class holds all application metadata that is
 * displayed by index.jsp and health.jsp.
 */
public class AppInfo {

    private static final String APP_NAME        = "learnakademy";
    private static final String APP_TITLE       = "Learn Akademy";
    private static final String VERSION         = "1.0";
    private static final String ENVIRONMENT     = "Development";
    private static final String DEPLOYMENT_STATUS = "SUCCESS";
    private static final String SERVER          = "Apache Tomcat";
    private static final String PIPELINE        = "Source Code -> Maven -> WAR -> Tomcat";
    private static final String LAB_NAME        = "Java Maven Tomcat Deployment Lab";

    // Getters
    public String getAppName()          { return APP_NAME; }
    public String getAppTitle()         { return APP_TITLE; }
    public String getVersion()          { return VERSION; }
    public String getEnvironment()      { return ENVIRONMENT; }
    public String getDeploymentStatus() { return DEPLOYMENT_STATUS; }
    public String getServer()           { return SERVER; }
    public String getPipeline()         { return PIPELINE; }
    public String getLabName()          { return LAB_NAME; }

    /**
     * Returns a formatted summary string of the application info.
     */
    public String getSummary() {
        return String.format(
            "App: %s | Version: %s | Env: %s | Status: %s",
            APP_TITLE, VERSION, ENVIRONMENT, DEPLOYMENT_STATUS
        );
    }

    @Override
    public String toString() {
        return "AppInfo{" +
               "name='" + APP_NAME + '\'' +
               ", version='" + VERSION + '\'' +
               ", environment='" + ENVIRONMENT + '\'' +
               ", status='" + DEPLOYMENT_STATUS + '\'' +
               '}';
    }
}
