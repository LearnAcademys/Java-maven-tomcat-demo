package com.learnakademy;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Unit tests for AppInfo class.
 * Learn Akademy DevOps Lab - Maven Test Phase
 */
public class AppInfoTest {

    @Test
    public void testAppName() {
        AppInfo app = new AppInfo();
        assertEquals("learnakademy", app.getAppName());
    }

    @Test
    public void testAppTitle() {
        AppInfo app = new AppInfo();
        assertEquals("Learn Akademy", app.getAppTitle());
    }

    @Test
    public void testVersion() {
        AppInfo app = new AppInfo();
        assertEquals("1.0", app.getVersion());
    }

    @Test
    public void testEnvironment() {
        AppInfo app = new AppInfo();
        assertEquals("Development", app.getEnvironment());
    }

    @Test
    public void testDeploymentStatus() {
        AppInfo app = new AppInfo();
        assertEquals("SUCCESS", app.getDeploymentStatus());
    }

    @Test
    public void testServer() {
        AppInfo app = new AppInfo();
        assertEquals("Apache Tomcat", app.getServer());
    }

    @Test
    public void testPipeline() {
        AppInfo app = new AppInfo();
        assertEquals("Source Code -> Maven -> WAR -> Tomcat", app.getPipeline());
    }

    @Test
    public void testSummaryNotNull() {
        AppInfo app = new AppInfo();
        assertNotNull(app.getSummary());
        assertTrue(app.getSummary().contains("Learn Akademy"));
        assertTrue(app.getSummary().contains("1.0"));
    }

    @Test
    public void testToString() {
        AppInfo app = new AppInfo();
        String str = app.toString();
        assertNotNull(str);
        assertTrue(str.contains("learnakademy"));
        assertTrue(str.contains("1.0"));
    }
}
