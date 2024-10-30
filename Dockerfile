# Use the official Ubuntu base image
FROM ubuntu

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Add a build argument to bust the cache
ARG CACHEBUST=1

# Copy files to the container
COPY index.html /var/www/html
COPY survey.html /var/www/html 
COPY IMG_4195.jpeg /var/www/html
COPY error.html /var/www/html
COPY default.conf /etc/nginx/sites-available/default

# Enable the Nginx default site
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
