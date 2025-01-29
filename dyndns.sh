#!/bin/bash

# Configuration
MAILINABOX_HOST="box.example.invalid"
API_URI="admin/dns/custom"
MAILINABOX_EMAIL="admin@example.invalid"
MAILINABOX_PASSWORD="CHANGE_ME"
RECORDS_TO_UPDATE=("box2.example.invalid" "sub.box2.example.invalid")
PUBIP_RESOLVER="ifconfig.me"
#PUBIP_RESOLVER="ipinfo.io/ip" #appears to only work with ipv4
LOG_FILE="/var/log/dyndns-updater.log"
#LOG_FILE="./dyndns-updater.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo $1
}

# Function to get current public IPs
get_public_ips() {
    # Get IPv4 address
    IPV4=$(curl -s4 $PUBIP_RESOLVER)
    if [ $? -ne 0 ]; then
        log_message "Error: Failed to get IPv4 address"
        IPV4=""
    fi

    # Get IPv6 address
    IPV6=$(curl -s6 $PUBIP_RESOLVER)
    if [ $? -ne 0 ]; then
        log_message "Error: Failed to get IPv6 address"
        IPV6=""
    fi
    log_message "IPv4: $IPV4"
    log_message "IPv6: $IPV6"
}

# Function to get current DNS records
get_dns_records() {
    local FQDN="$1"
    local RTYPE="$2"
    local response
    response=$(curl -X GET -s -u "$MAILINABOX_EMAIL:$MAILINABOX_PASSWORD" \
        "https://$MAILINABOX_HOST/$API_URI/$SUBDOMAIN/$RTYPE" | jq -r \
        --arg domain "$FQDN" --arg type "$RTYPE" '.[] | select(.qname == $domain and .rtype == $type) | .value' 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        log_message "Error: Failed to fetch DNS records for $domain"
        return 1
    fi
    log_message "$response"
    echo "$response"
}

# Function to update DNS record
update_dns_record() {
    local domain="$1"
    local record_type="$2"
    local ip="$3"
    
    # Skip if IP is empty
    if [ -z "$ip" ]; then
        log_message "Skipping $record_type update for $domain - No IP address available"
        return
    fi
    # Make the API call
    local response
    response=$(curl -s -u "$MAILINABOX_EMAIL:$MAILINABOX_PASSWORD" \
        -X PUT \
        -H "Content-Type: text/plain" \
        --data-raw "$ip" \
        "https://$MAILINABOX_HOST/$API_URI/$domain/$record_type")
    
    if [ $? -eq 0 ]; then
        log_message "Successfully updated $record_type record for $domain to $ip"
    else
        log_message "Error: Failed to update $record_type record for $domain"
    fi
}

# Main execution
log_message "Starting DNS update check"

# Get current public IPs
get_public_ips

# Process each domain
for domain in "${RECORDS_TO_UPDATE[@]}"; do
    log_message "Processing domain: $domain"
        
    # Update IPv4 if available
    if [ ! -z "$IPV4" ]; then
        # Get current DNS records
        current_record=$(get_dns_records "$domain" "A")
        # Compare current record to current ip
        if ! [ "$IPV4" == "$current_record" ]; then
        # Update current record if needed
        update_dns_record "$domain" "A" "$IPV4"
        fi
    fi
    
    # Update IPv6 if available
    if [ ! -z "$IPV6" ]; then
        # Get current DNS records
        current_record=$(get_dns_records "$domain" "AAAA")
        # Compare current record to current ip
        if ! [ "$IPV6" = "$current_record" ]; then
        # Update current record if needed
        update_dns_record "$domain" "AAAA" "$IPV6"
        fi
    fi
done

log_message "DNS update check completed"