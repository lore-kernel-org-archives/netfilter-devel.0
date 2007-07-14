From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 20/43] Unifies libip[6]t_multiport.c into libipxt_multiport.c
Date: Sun, 15 Jul 2007 02:25:38 +0900 (JST)
Message-ID: <200707141725.l6EHPcoO018219@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


---
 extensions/Makefile                           |    2 +-
 extensions/libxt_multiport.c                  |   85 +++++++++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_multiport.h |   30 ---------
 3 files changed, 86 insertions(+), 31 deletions(-)
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_multiport.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 3a7c6a2..0dd6bc6 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
 PFX_EXT_SLIB:=multiport NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index e3b6f17..43ca389 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -7,6 +7,7 @@
 
 #include <xtables.h>
 #include <libiptc/libiptc.h>
+#include <libiptc/libip6tc.h>
 /* To ensure that iptables compiles with an old kernel */
 #include "../include/linux/netfilter/xt_multiport.h"
 
@@ -221,6 +222,17 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
+parse6(int c, char **argv, int invert, unsigned int *flags,
+	 const void *e,
+	 unsigned int *nfcache,
+	 struct xt_entry_match **match)
+{
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	return __parse(c, argv, invert, flags, match, entry->ipv6.proto,
+		       entry->ipv6.invflags);
+}
+
+static int
 __parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	   struct xt_entry_match **match,
 	   u_int16_t pnum, u_int8_t invflags)
@@ -276,6 +288,17 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 			  entry->ip.invflags);
 }
 
+static int
+parse6_v1(int c, char **argv, int invert, unsigned int *flags,
+	  const void *e,
+	  unsigned int *nfcache,
+	  struct xt_entry_match **match)
+{
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	return __parse_v1(c, argv, invert, flags, match, entry->ipv6.proto,
+			  entry->ipv6.invflags);
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -349,6 +372,13 @@ print(const void *ip_void, const struct xt_entry_match *match, int numeric)
 }
 
 static void
+print6(const void *ip_void, const struct xt_entry_match *match, int numeric)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__print(match, numeric, ip->proto);
+}
+
+static void
 __print_v1(const struct xt_entry_match *match, int numeric, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
@@ -396,6 +426,13 @@ print_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
 	__print_v1(match, numeric, ip->proto);
 }
 
+static void
+print6_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__print_v1(match, numeric, ip->proto);
+}
+
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void __save(const struct xt_entry_match *match, u_int16_t proto)
 {
@@ -430,6 +467,12 @@ static void save(const void *ip_void, const struct xt_entry_match *match)
 	__save(match, ip->proto);
 }
 
+static void save6(const void *ip_void, const struct xt_entry_match *match)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__save(match, ip->proto);
+}
+
 static void __save_v1(const struct xt_entry_match *match, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
@@ -470,6 +513,12 @@ static void save_v1(const void *ip_void, const struct xt_entry_match *match)
 	__save_v1(match, ip->proto);
 }
 
+static void save6_v1(const void *ip_void, const struct xt_entry_match *match)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__save_v1(match, ip->proto);
+}
+
 static struct xtables_match multiport = { 
 	.next		= NULL,
 	.family		= AF_INET,
@@ -487,6 +536,23 @@ static struct xtables_match multiport = {
 	.extra_opts	= opts
 };
 
+static struct xtables_match multiport6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "multiport",
+	.revision	= 0,
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse6,
+	.final_check	= &final_check,
+	.print		= &print6,
+	.save		= &save6,
+	.extra_opts	= opts
+};
+
 static struct xtables_match multiport_v1 = { 
 	.next		= NULL,
 	.family		= AF_INET,
@@ -504,9 +570,28 @@ static struct xtables_match multiport_v1 = {
 	.extra_opts	= opts
 };
 
+static struct xtables_match multiport6_v1 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "multiport",
+	.version	= IPTABLES_VERSION,
+	.revision	= 1,
+	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
+	.help		= &help_v1,
+	.init		= &init,
+	.parse		= &parse6_v1,
+	.final_check	= &final_check,
+	.print		= &print6_v1,
+	.save		= &save6_v1,
+	.extra_opts	= opts
+};
+
 void
 _init(void)
 {
 	xtables_register_match(&multiport);
+	xtables_register_match(&multiport6);
 	xtables_register_match(&multiport_v1);
+	xtables_register_match(&multiport6_v1);
 }
diff --git a/include/linux/netfilter_ipv6/ip6t_multiport.h b/include/linux/netfilter_ipv6/ip6t_multiport.h
deleted file mode 100644
index 8c2cc9d..0000000
--- a/include/linux/netfilter_ipv6/ip6t_multiport.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _IP6T_MULTIPORT_H
-#define _IP6T_MULTIPORT_H
-
-enum ip6t_multiport_flags
-{
-	IP6T_MULTIPORT_SOURCE,
-	IP6T_MULTIPORT_DESTINATION,
-	IP6T_MULTIPORT_EITHER
-};
-
-#define IP6T_MULTI_PORTS	15
-
-/* Must fit inside union xt_matchinfo: 16 bytes */
-struct ip6t_multiport
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
-};
-
-struct ip6t_multiport_v1
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[IP6T_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
-};
-
-#endif /*_IP6T_MULTIPORT_H*/
-- 
1.5.2.2
