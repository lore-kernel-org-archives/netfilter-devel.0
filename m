From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] reduce service_to_port duplication
Date: Wed, 12 Jul 2006 18:24:01 -0700
Message-ID: <20060713012401.GA19152@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
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


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The service_to_port function is used in a number of places, and could
benefit from some centralization instead of being duplicated everywhere.

Phil



--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-srvtoport

diff -ru ipt-orig/extensions/libip6t_multiport.c ipt-new/extensions/libip6t_multiport.c
--- ipt-orig/extensions/libip6t_multiport.c	2006-04-28 01:10:08.000000000 -0700
+++ ipt-new/extensions/libip6t_multiport.c	2006-07-12 18:07:13.000000000 -0700
@@ -50,17 +50,6 @@
 	}
 }
 
-static int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
 static u_int16_t
 parse_port(const char *port, const char *proto)
 {
diff -ru ipt-orig/extensions/libip6t_tcp.c ipt-new/extensions/libip6t_tcp.c
--- ipt-orig/extensions/libip6t_tcp.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libip6t_tcp.c	2006-07-12 18:07:26.000000000 -0700
@@ -38,24 +38,13 @@
 	{0}
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "tcp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
 static u_int16_t
 parse_tcp_port(const char *port)
 {
 	unsigned int portnum;
 
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "tcp")) != -1)
 		return (u_int16_t)portnum;
 
 	exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libip6t_udp.c ipt-new/extensions/libip6t_udp.c
--- ipt-orig/extensions/libip6t_udp.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libip6t_udp.c	2006-07-12 18:07:41.000000000 -0700
@@ -30,24 +30,13 @@
 	{0}
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "udp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
 static u_int16_t
 parse_udp_port(const char *port)
 {
 	unsigned int portnum;
 
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "udp")) != -1)
 		return (u_int16_t)portnum;
 
 		exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_dccp.c ipt-new/extensions/libipt_dccp.c
--- ipt-orig/extensions/libipt_dccp.c	2005-08-06 14:13:04.000000000 -0700
+++ ipt-new/extensions/libipt_dccp.c	2006-07-12 18:01:51.000000000 -0700
@@ -56,17 +56,6 @@
 	{ .name = 0 }
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "dccp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
 static u_int16_t
 parse_dccp_port(const char *port)
 {
@@ -74,7 +63,7 @@
 
 	DEBUGP("%s\n", port);
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "dccp")) != -1)
 		return (u_int16_t)portnum;
 
 	exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_mport.c ipt-new/extensions/libipt_mport.c
--- ipt-orig/extensions/libipt_mport.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libipt_mport.c	2006-07-12 18:02:12.000000000 -0700
@@ -33,17 +33,6 @@
 	{0}
 };
 
-static int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
 static u_int16_t
 parse_port(const char *port, const char *proto)
 {
diff -ru ipt-orig/extensions/libipt_multiport.c ipt-new/extensions/libipt_multiport.c
--- ipt-orig/extensions/libipt_multiport.c	2006-04-28 01:10:08.000000000 -0700
+++ ipt-new/extensions/libipt_multiport.c	2006-07-12 18:02:23.000000000 -0700
@@ -68,17 +68,6 @@
 	}
 }
 
-static int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
 static u_int16_t
 parse_port(const char *port, const char *proto)
 {
diff -ru ipt-orig/extensions/libipt_sctp.c ipt-new/extensions/libipt_sctp.c
--- ipt-orig/extensions/libipt_sctp.c	2006-07-03 11:20:59.000000000 -0700
+++ ipt-new/extensions/libipt_sctp.c	2006-07-12 18:02:47.000000000 -0700
@@ -79,17 +79,6 @@
 	{ .name = 0 }
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "sctp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
 static u_int16_t
 parse_sctp_port(const char *port)
 {
@@ -97,7 +86,7 @@
 
 	DEBUGP("%s\n", port);
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "sctp")) != -1)
 		return (u_int16_t)portnum;
 
 	exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_tcp.c ipt-new/extensions/libipt_tcp.c
--- ipt-orig/extensions/libipt_tcp.c	2005-05-04 00:34:37.000000000 -0700
+++ ipt-new/extensions/libipt_tcp.c	2006-07-12 18:03:06.000000000 -0700
@@ -38,24 +38,13 @@
 	{0}
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "tcp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
 static u_int16_t
 parse_tcp_port(const char *port)
 {
 	unsigned int portnum;
 
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "tcp")) != -1)
 		return (u_int16_t)portnum;
 
 	exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/extensions/libipt_udp.c ipt-new/extensions/libipt_udp.c
--- ipt-orig/extensions/libipt_udp.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libipt_udp.c	2006-07-12 18:03:18.000000000 -0700
@@ -30,24 +30,13 @@
 	{0}
 };
 
-static int
-service_to_port(const char *name)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, "udp")) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
 static u_int16_t
 parse_udp_port(const char *port)
 {
 	unsigned int portnum;
 
 	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port)) != -1)
+	    (portnum = service_to_port(port, "udp")) != -1)
 		return (u_int16_t)portnum;
 
 		exit_error(PARAMETER_PROBLEM,
diff -ru ipt-orig/include/ip6tables.h ipt-new/include/ip6tables.h
--- ipt-orig/include/ip6tables.h	2006-04-28 01:10:08.000000000 -0700
+++ ipt-new/include/ip6tables.h	2006-07-12 18:08:49.000000000 -0700
@@ -133,6 +133,7 @@
 extern void register_match6(struct ip6tables_match *me);
 extern void register_target6(struct ip6tables_target *me);
 
+extern int service_to_port(const char *name, const char *proto);
 extern int do_command6(int argc, char *argv[], char **table,
 		       ip6tc_handle_t *handle);
 /* Keeping track of external matches and targets: linked lists. */
diff -ru ipt-orig/include/iptables.h ipt-new/include/iptables.h
--- ipt-orig/include/iptables.h	2006-04-28 01:10:08.000000000 -0700
+++ ipt-new/include/iptables.h	2006-07-12 18:00:59.000000000 -0700
@@ -151,6 +151,7 @@
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
+extern int service_to_port(const char *name, const char *proto);
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
 extern char *addr_to_anyname(const struct in_addr *addr);
diff -ru ipt-orig/ip6tables.c ipt-new/ip6tables.c
--- ipt-orig/ip6tables.c	2006-04-21 05:04:51.000000000 -0700
+++ ipt-new/ip6tables.c	2006-07-12 18:05:15.000000000 -0700
@@ -245,6 +245,17 @@
 	return NULL;
 }
 
+int
+service_to_port(const char *name, const char *proto)
+{
+	struct servent *service;
+
+	if ((service = getservbyname(name, proto)) != NULL)
+		return ntohs((unsigned short) service->s_port);
+
+	return -1;
+}
+
 static void
 in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
 {
diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2006-07-09 21:52:56.000000000 -0700
+++ ipt-new/iptables.c	2006-07-12 18:00:11.000000000 -0700
@@ -249,6 +249,17 @@
 	return NULL;
 }
 
+int
+service_to_port(const char *name, const char *proto)
+{
+	struct servent *service;
+
+	if ((service = getservbyname(name, proto)) != NULL)
+		return ntohs((unsigned short) service->s_port);
+
+	return -1;
+}
+
 struct in_addr *
 dotted_to_addr(const char *dotted)
 {

--wRRV7LY7NUeQGEoC--
