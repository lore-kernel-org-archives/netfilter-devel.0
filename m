From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] proto_to_name duplication
Date: Fri, 21 Jul 2006 15:56:12 -0700
Message-ID: <20060721225612.GA3951@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
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


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Update multiport match to use the iptables version of proto_to_name
instead of reinventing the wheel.

I looked at a similar ipv6 cleanup, but the ipv6header header match
makes this somewhat trickier.

Incidentally - it's probably time to remove the superfluous mport
match.  Anyone still using it can probably stick with older userspace.

Phil


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-proto_to_name

diff -ru ipt-orig/extensions/libipt_multiport.c ipt-new/extensions/libipt_multiport.c
--- ipt-orig/extensions/libipt_multiport.c	2006-07-20 10:01:54.000000000 -0700
+++ ipt-new/extensions/libipt_multiport.c	2006-07-21 14:58:53.000000000 -0700
@@ -51,23 +51,6 @@
 	{0}
 };
 
-static char *
-proto_to_name(u_int8_t proto)
-{
-	switch (proto) {
-	case IPPROTO_TCP:
-		return "tcp";
-	case IPPROTO_UDP:
-		return "udp";
-	case IPPROTO_SCTP:
-		return "sctp";
-	case IPPROTO_DCCP:
-		return "dccp";
-	default:
-		return NULL;
-	}
-}
-
 static unsigned int
 parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 {
@@ -143,7 +126,7 @@
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP or UDP");
 
-	if ((proto = proto_to_name(entry->ip.proto)) != NULL)
+	if ((proto = proto_to_name(entry->ip.proto, 1)) != NULL)
 		return proto;
 	else if (!entry->ip.proto)
 		exit_error(PARAMETER_PROBLEM,
@@ -264,7 +247,7 @@
 {
 	struct servent *service;
 
-	if ((service = getservbyport(htons(port), proto_to_name(proto))))
+	if ((service = getservbyport(htons(port), proto_to_name(proto, 1))))
 		return service->s_name;
 
 	return NULL;
diff -ru ipt-orig/include/iptables.h ipt-new/include/iptables.h
--- ipt-orig/include/iptables.h	2006-07-20 10:01:54.000000000 -0700
+++ ipt-new/include/iptables.h	2006-07-21 15:29:18.000000000 -0700
@@ -151,6 +151,7 @@
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
+extern char *proto_to_name(u_int8_t proto, int nolookup);
 extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
 extern struct in_addr *dotted_to_addr(const char *dotted);
diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2006-07-20 10:01:54.000000000 -0700
+++ ipt-new/iptables.c	2006-07-21 15:29:28.000000000 -0700
@@ -229,9 +229,10 @@
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
 	{ "sctp", IPPROTO_SCTP },
+	{ "dccp", IPPROTO_DCCP },
 };
 
-static char *
+char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
 	unsigned int i;

--SUOF0GtieIMvvwua--
