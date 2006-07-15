From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] reduce parse_*_port duplication
Date: Fri, 14 Jul 2006 18:18:22 -0700
Message-ID: <20060715011822.GA7115@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The below patch (dependent upon my 'reduce service_to_port duplication' patch)
centralizes the parse_*_port functions into parse_port.

Phil



--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-parseport

diff -ru ipt-orig/extensions/libip6t_multiport.c ipt-new/extensions/libip6t_multiport.c
--- ipt-orig/extensions/libip6t_multiport.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libip6t_multiport.c	2006-07-14 17:54:55.000000000 -0700
@@ -50,19 +50,6 @@
 	}
 }
 
-static u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
 static unsigned int
 parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 {
diff -ru ipt-orig/extensions/libip6t_tcp.c ipt-new/extensions/libip6t_tcp.c
--- ipt-orig/extensions/libip6t_tcp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libip6t_tcp.c	2006-07-14 18:01:14.000000000 -0700
@@ -38,19 +38,6 @@
 	{0}
 };
 
-static u_int16_t
-parse_tcp_port(const char *port)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "tcp")) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid TCP port/service `%s' specified", port);
-}
-
 static void
 parse_tcp_ports(const char *portstring, u_int16_t *ports)
 {
@@ -59,13 +46,13 @@
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_tcp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "tcp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_tcp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_tcp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
 		
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM, 
diff -ru ipt-orig/extensions/libip6t_udp.c ipt-new/extensions/libip6t_udp.c
--- ipt-orig/extensions/libip6t_udp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libip6t_udp.c	2006-07-14 18:01:26.000000000 -0700
@@ -30,19 +30,6 @@
 	{0}
 };
 
-static u_int16_t
-parse_udp_port(const char *port)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "udp")) != -1)
-		return (u_int16_t)portnum;
-
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid UDP port/service `%s' specified", port);
-	}
-
 static void
 parse_udp_ports(const char *portstring, u_int16_t *ports)
 {
@@ -51,13 +38,13 @@
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_udp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "udp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_udp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_udp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_dccp.c ipt-new/extensions/libipt_dccp.c
--- ipt-orig/extensions/libipt_dccp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_dccp.c	2006-07-14 17:59:27.000000000 -0700
@@ -56,20 +56,6 @@
 	{ .name = 0 }
 };
 
-static u_int16_t
-parse_dccp_port(const char *port)
-{
-	unsigned int portnum;
-
-	DEBUGP("%s\n", port);
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "dccp")) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid DCCP port/service `%s' specified", port);
-}
-
 static void
 parse_dccp_ports(const char *portstring, 
 		 u_int16_t *ports)
@@ -80,14 +66,14 @@
 	buffer = strdup(portstring);
 	DEBUGP("%s\n", portstring);
 	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = parse_dccp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "dccp");
 	}
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_dccp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_dccp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "dccp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "dccp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_mport.c ipt-new/extensions/libipt_mport.c
--- ipt-orig/extensions/libipt_mport.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_mport.c	2006-07-14 17:57:59.000000000 -0700
@@ -33,19 +33,6 @@
 	{0}
 };
 
-static u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
 static void
 parse_multi_ports(const char *portstring, struct ipt_mport *minfo,
                   const char *proto)
diff -ru ipt-orig/extensions/libipt_multiport.c ipt-new/extensions/libipt_multiport.c
--- ipt-orig/extensions/libipt_multiport.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_multiport.c	2006-07-14 17:58:19.000000000 -0700
@@ -68,19 +68,6 @@
 	}
 }
 
-static u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
 static unsigned int
 parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 {
diff -ru ipt-orig/extensions/libipt_sctp.c ipt-new/extensions/libipt_sctp.c
--- ipt-orig/extensions/libipt_sctp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_sctp.c	2006-07-14 18:02:47.000000000 -0700
@@ -79,20 +79,6 @@
 	{ .name = 0 }
 };
 
-static u_int16_t
-parse_sctp_port(const char *port)
-{
-	unsigned int portnum;
-
-	DEBUGP("%s\n", port);
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "sctp")) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid SCTP port/service `%s' specified", port);
-}
-
 static void
 parse_sctp_ports(const char *portstring, 
 		 u_int16_t *ports)
@@ -103,14 +89,14 @@
 	buffer = strdup(portstring);
 	DEBUGP("%s\n", portstring);
 	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = parse_sctp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "sctp");
 	}
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_sctp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_sctp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "sctp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "sctp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_tcp.c ipt-new/extensions/libipt_tcp.c
--- ipt-orig/extensions/libipt_tcp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_tcp.c	2006-07-14 18:02:25.000000000 -0700
@@ -38,19 +38,6 @@
 	{0}
 };
 
-static u_int16_t
-parse_tcp_port(const char *port)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "tcp")) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid TCP port/service `%s' specified", port);
-}
-
 static void
 parse_tcp_ports(const char *portstring, u_int16_t *ports)
 {
@@ -59,13 +46,13 @@
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_tcp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "tcp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_tcp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_tcp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_udp.c ipt-new/extensions/libipt_udp.c
--- ipt-orig/extensions/libipt_udp.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/extensions/libipt_udp.c	2006-07-14 18:00:40.000000000 -0700
@@ -30,19 +30,6 @@
 	{0}
 };
 
-static u_int16_t
-parse_udp_port(const char *port)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, "udp")) != -1)
-		return (u_int16_t)portnum;
-
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid UDP port/service `%s' specified", port);
-	}
-
 static void
 parse_udp_ports(const char *portstring, u_int16_t *ports)
 {
@@ -51,13 +38,13 @@
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_udp_port(buffer);
+		ports[0] = ports[1] = parse_port(buffer, "udp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_udp_port(buffer) : 0;
-		ports[1] = cp[0] ? parse_udp_port(cp) : 0xFFFF;
+		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/include/ip6tables.h ipt-new/include/ip6tables.h
--- ipt-orig/include/ip6tables.h	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/include/ip6tables.h	2006-07-14 18:04:34.000000000 -0700
@@ -134,6 +134,7 @@
 extern void register_target6(struct ip6tables_target *me);
 
 extern int service_to_port(const char *name, const char *proto);
+extern u_int16_t parse_port(const char *port, const char *proto);
 extern int do_command6(int argc, char *argv[], char **table,
 		       ip6tc_handle_t *handle);
 /* Keeping track of external matches and targets: linked lists. */
diff -ru ipt-orig/include/iptables.h ipt-new/include/iptables.h
--- ipt-orig/include/iptables.h	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/include/iptables.h	2006-07-14 18:03:23.000000000 -0700
@@ -152,6 +152,7 @@
 extern void register_target(struct iptables_target *me);
 
 extern int service_to_port(const char *name, const char *proto);
+extern u_int16_t parse_port(const char *port, const char *proto);
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
 extern char *addr_to_anyname(const struct in_addr *addr);
diff -ru ipt-orig/ip6tables.c ipt-new/ip6tables.c
--- ipt-orig/ip6tables.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/ip6tables.c	2006-07-14 17:54:12.000000000 -0700
@@ -256,6 +256,19 @@
 	return -1;
 }
 
+u_int16_t
+parse_port(const char *port, const char *proto)
+{
+	unsigned int portnum;
+
+	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
+	    (portnum = service_to_port(port, proto)) != -1)
+		return (u_int16_t)portnum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid port/service `%s' specified", port);
+}
+
 static void
 in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
 {
diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2006-07-14 18:12:36.000000000 -0700
+++ ipt-new/iptables.c	2006-07-14 17:54:34.000000000 -0700
@@ -260,6 +260,19 @@
 	return -1;
 }
 
+u_int16_t
+parse_port(const char *port, const char *proto)
+{
+	unsigned int portnum;
+
+	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
+	    (portnum = service_to_port(port, proto)) != -1)
+		return (u_int16_t)portnum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid port/service `%s' specified", port);
+}
+
 struct in_addr *
 dotted_to_addr(const char *dotted)
 {

--HcAYCG3uE/tztfnV--
