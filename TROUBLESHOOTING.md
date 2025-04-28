# Troubleshooting: Internal Web Dashboard Unreachable (DNS/Network Issue)

## Scenario
Your internal web dashboard (`internal.example.com`) is unreachable from multiple systems. The service appears up, but users get “host not found” errors. You suspect a DNS or network misconfiguration.

---

## 1. Verify DNS Resolution

### Compare /etc/resolv.conf DNS vs. 8.8.8.8

**Check system DNS:**
```sh
cat /etc/resolv.conf
nslookup internal.example.com
```

**Check with Google DNS:**
```sh
nslookup internal.example.com 8.8.8.8
```

**Screenshot:**
_Insert screenshot of both commands_

---

## 2. Diagnose Service Reachability

**Get resolved IP:**
```sh
getent hosts internal.example.com
```

**Check HTTP/HTTPS port (80/443):**
```sh
curl -I http://internal.example.com
curl -I https://internal.example.com
```

**Or test with telnet/netcat:**
```sh
telnet internal.example.com 80
nc -vz internal.example.com 80
```

**Check if service is listening (on server):**
```sh
sudo netstat -tulnp | grep ':80\|:443'
sudo ss -tulnp | grep ':80\|:443'
```

**Screenshot:**
_Insert screenshot of connection attempts_

---

## 3. List All Possible Causes

- Incorrect DNS records (A/AAAA/CNAME missing or wrong)
- DNS server misconfigured or unreachable
- /etc/resolv.conf points to wrong DNS
- Firewall blocking DNS or HTTP/HTTPS
- Network routing issues
- Service not listening on correct IP/port
- SELinux/AppArmor restrictions
- Hosts file overrides
- Expired DNS cache
- Split-horizon DNS (internal/external mismatch)
- Proxy or VPN misconfiguration

---

## 4. Propose and Apply Fixes

### a. Incorrect DNS Records
- **Confirm:**
  - Use `dig internal.example.com` and check returned IP
- **Fix:**
  - Update DNS zone file or use DNS provider UI/API
  - Reload DNS server: `sudo systemctl reload named` (BIND)

### b. DNS Server Misconfigured/Unreachable
- **Confirm:**
  - `nslookup internal.example.com <dns-server-ip>`
- **Fix:**
  - Edit `/etc/resolv.conf` to point to correct DNS
  - Restart network: `sudo systemctl restart NetworkManager`

### c. Firewall Blocking DNS/HTTP/HTTPS
- **Confirm:**
  - `sudo iptables -L -n | grep 53\|80\|443`
- **Fix:**
  - `sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT`
  - `sudo iptables -A INPUT -p tcp --dport 53 -j ACCEPT`

### d. Service Not Listening
- **Confirm:**
  - `sudo netstat -tulnp | grep ':80\|:443'`
- **Fix:**
  - Restart service: `sudo systemctl restart nginx` or `apache2`

### e. Hosts File Overrides
- **Confirm:**
  - `cat /etc/hosts | grep internal.example.com`
- **Fix:**
  - Edit `/etc/hosts` to remove or correct entry

### f. DNS Cache Issues
- **Confirm:**
  - `systemd-resolve --statistics`
- **Fix:**
  - `sudo systemd-resolve --flush-caches`

### g. Split-Horizon DNS
- **Confirm:**
  - Compare DNS results from inside and outside network
- **Fix:**
  - Adjust internal/external DNS zones

### h. Proxy/VPN Issues
- **Confirm:**
  - Check proxy/VPN settings and routes
- **Fix:**
  - Reconfigure or restart proxy/VPN

---

## Bonus: Bypass DNS with /etc/hosts

**Add entry:**
```sh
echo '192.168.1.100 internal.example.com' | sudo tee -a /etc/hosts
```
**Test:**
```sh
ping internal.example.com
```

---

## Bonus: Persist DNS Settings

### Using systemd-resolved
```sh
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemd-resolve --set-dns=8.8.8.8 --interface=eth0
```

### Using NetworkManager
```sh
nmcli device show
nmcli con mod <connection> ipv4.dns "8.8.8.8 1.1.1.1"
nmcli con up <connection>
```

---

## Screenshots
_Please insert screenshots of your terminal output for each step above._