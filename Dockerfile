FROM tomcat:9.0-jdk21

# Remove default Tomcat webapps (optional but clean)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat
COPY target/devops-trends.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080