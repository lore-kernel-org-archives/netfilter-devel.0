From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 32/43] Use unified API in pkttype match and add support for
 IPv6 to it.
Date: Sun, 15 Jul 2007 03:12:01 +0900 (JST)
Message-ID: <200707141812.l6EIC2Ov009098@toshiba.co.jp>
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
 extensions/Makefile                        |    4 +-
 extensions/libipt_pkttype.c                |  167 -------------------------
 extensions/libxt_pkttype.c                 |  184 ++++++++++++++++++++++++++++
 include/linux/netfilter/xt_pkttype.h       |    8 ++
 include/linux/netfilter_ipv4/ipt_pkttype.h |    9 --
 5 files changed, 194 insertions(+), 178 deletions(-)
 delete mode 100644 extensions/libipt_pkttype.c
 create mode 100644 extensions/libxt_pkttype.c
 create mode 100644 include/linux/netfilter/xt_pkttype.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_pkttype.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 2c911b6..85ed1aa 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport sctp standard tcp tcpmss udp NOTRACK
+PFX_EXT_SLIB:=mark multiport pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libipt_pkttype.c b/extensions/libipt_pkttype.c
deleted file mode 100644
index 568aaab..0000000
--- a/extensions/libipt_pkttype.c
+++ /dev/null
@@ -1,167 +0,0 @@
-/* 
- * Shared library add-on to iptables to match 
- * packets by their type (BROADCAST, UNICAST, MULTICAST). 
- *
- * Michal Ludvig <michal@logix.cz>
- */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
-#include <iptables.h>
-#include <linux/if_packet.h>
-#include <linux/netfilter_ipv4/ipt_pkttype.h>
-
-#define	PKTTYPE_VERSION	"0.1"
-
-struct pkttypes {
-	const char *name;
-	unsigned char pkttype;
-	unsigned char printhelp;
-	const char *help;
-};
-
-static const struct pkttypes supported_types[] = {
-	{"unicast", PACKET_HOST, 1, "to us"},
-	{"broadcast", PACKET_BROADCAST, 1, "to all"},
-	{"multicast", PACKET_MULTICAST, 1, "to group"},
-/*
-	{"otherhost", PACKET_OTHERHOST, 1, "to someone else"},
-	{"outgoing", PACKET_OUTGOING, 1, "outgoing of any type"},
-*/
-	/* aliases */
-	{"bcast", PACKET_BROADCAST, 0, NULL},
-	{"mcast", PACKET_MULTICAST, 0, NULL},
-	{"host", PACKET_HOST, 0, NULL}
-};
-
-static void print_types()
-{
-	unsigned int	i;
-	
-	printf("Valid packet types:\n");
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
-		if(supported_types[i].printhelp == 1)
-			printf("\t%-14s\t\t%s\n", supported_types[i].name, supported_types[i].help);
-	}
-	printf("\n");
-}
-
-/* Function which prints out usage message. */
-static void help(void)
-{
-	printf(
-"pkt_type v%s options:\n"
-"  --pkt-type [!] packettype\tmatch packet type\n"
-"\n", PKTTYPE_VERSION);
-	print_types();
-}
-
-static struct option opts[] = {
-	{"pkt-type", 1, 0, '1'},
-	{0}
-};
-
-static void parse_pkttype(const char *pkttype, struct ipt_pkttype_info *info)
-{
-	unsigned int	i;
-	
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
-		if(strcasecmp(pkttype, supported_types[i].name)==0)
-		{
-			info->pkttype=supported_types[i].pkttype;
-			return;
-		}
-	}
-	
-	exit_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
-}
-
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)(*match)->data;
-	
-	switch(c)
-	{
-		case '1':
-			check_inverse(optarg, &invert, &optind, 0);
-			parse_pkttype(argv[optind-1], info);
-			if(invert)
-				info->invert=1;
-			*flags=1;
-			break;
-
-		default: 
-			return 0;
-	}
-
-	return 1;
-}
-
-static void final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "You must specify `--pkt-type'");
-}
-
-static void print_pkttype(struct ipt_pkttype_info *info)
-{
-	unsigned int	i;
-	
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
-		if(supported_types[i].pkttype==info->pkttype)
-		{
-			printf("%s ", supported_types[i].name);
-			return;
-		}
-	}
-
-	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
-}
-
-static void print(const void *ip, const struct xt_entry_match *match, int numeric)
-{
-	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
-	
-	printf("PKTTYPE %s= ", info->invert?"!":"");
-	print_pkttype(info);
-}
-
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
-	
-	printf("--pkt-type %s", info->invert?"! ":"");
-	print_pkttype(info);
-}
-
-static struct iptables_match pkttype = {
-	.next		= NULL,
-	.name		= "pkttype",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_pkttype_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_pkttype_info)),
-	.help		= &help,
-	.parse		= &parse, 
-	.final_check	= &final_check, 
-	.print		= &print,
-	.save		= &save, 
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_match(&pkttype);
-}
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
new file mode 100644
index 0000000..9654226
--- /dev/null
+++ b/extensions/libxt_pkttype.c
@@ -0,0 +1,184 @@
+/* 
+ * Shared library add-on to iptables to match 
+ * packets by their type (BROADCAST, UNICAST, MULTICAST). 
+ *
+ * Michal Ludvig <michal@logix.cz>
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+#include <xtables.h>
+#include <linux/if_packet.h>
+#include <linux/netfilter/xt_pkttype.h>
+
+#define	PKTTYPE_VERSION	"0.1"
+
+struct pkttypes {
+	const char *name;
+	unsigned char pkttype;
+	unsigned char printhelp;
+	const char *help;
+};
+
+static const struct pkttypes supported_types[] = {
+	{"unicast", PACKET_HOST, 1, "to us"},
+	{"broadcast", PACKET_BROADCAST, 1, "to all"},
+	{"multicast", PACKET_MULTICAST, 1, "to group"},
+/*
+	{"otherhost", PACKET_OTHERHOST, 1, "to someone else"},
+	{"outgoing", PACKET_OUTGOING, 1, "outgoing of any type"},
+*/
+	/* aliases */
+	{"bcast", PACKET_BROADCAST, 0, NULL},
+	{"mcast", PACKET_MULTICAST, 0, NULL},
+	{"host", PACKET_HOST, 0, NULL}
+};
+
+static void print_types()
+{
+	unsigned int	i;
+	
+	printf("Valid packet types:\n");
+	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
+	{
+		if(supported_types[i].printhelp == 1)
+			printf("\t%-14s\t\t%s\n", supported_types[i].name, supported_types[i].help);
+	}
+	printf("\n");
+}
+
+/* Function which prints out usage message. */
+static void help(void)
+{
+	printf(
+"pkt_type v%s options:\n"
+"  --pkt-type [!] packettype\tmatch packet type\n"
+"\n", PKTTYPE_VERSION);
+	print_types();
+}
+
+static struct option opts[] = {
+	{"pkt-type", 1, 0, '1'},
+	{0}
+};
+
+static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
+{
+	unsigned int	i;
+	
+	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
+	{
+		if(strcasecmp(pkttype, supported_types[i].name)==0)
+		{
+			info->pkttype=supported_types[i].pkttype;
+			return;
+		}
+	}
+	
+	exit_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
+	
+	switch(c)
+	{
+		case '1':
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_pkttype(argv[optind-1], info);
+			if(invert)
+				info->invert=1;
+			*flags=1;
+			break;
+
+		default: 
+			return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--pkt-type'");
+}
+
+static void print_pkttype(struct xt_pkttype_info *info)
+{
+	unsigned int	i;
+	
+	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
+	{
+		if(supported_types[i].pkttype==info->pkttype)
+		{
+			printf("%s ", supported_types[i].name);
+			return;
+		}
+	}
+
+	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
+}
+
+static void print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
+	
+	printf("PKTTYPE %s= ", info->invert?"!":"");
+	print_pkttype(info);
+}
+
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
+	
+	printf("--pkt-type %s", info->invert?"! ":"");
+	print_pkttype(info);
+}
+
+static struct xtables_match pkttype = {
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "pkttype",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
+	.help		= &help,
+	.parse		= &parse, 
+	.final_check	= &final_check, 
+	.print		= &print,
+	.save		= &save, 
+	.extra_opts	= opts
+};
+
+static struct xtables_match pkttype6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "pkttype",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
+	.help		= &help,
+	.parse		= &parse, 
+	.final_check	= &final_check, 
+	.print		= &print,
+	.save		= &save, 
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&pkttype);
+	xtables_register_match(&pkttype6);
+}
diff --git a/include/linux/netfilter/xt_pkttype.h b/include/linux/netfilter/xt_pkttype.h
new file mode 100644
index 0000000..f265cf5
--- /dev/null
+++ b/include/linux/netfilter/xt_pkttype.h
@@ -0,0 +1,8 @@
+#ifndef _XT_PKTTYPE_H
+#define _XT_PKTTYPE_H
+
+struct xt_pkttype_info {
+	int	pkttype;
+	int	invert;
+};
+#endif /*_XT_PKTTYPE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_pkttype.h b/include/linux/netfilter_ipv4/ipt_pkttype.h
deleted file mode 100644
index c189e94..0000000
--- a/include/linux/netfilter_ipv4/ipt_pkttype.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _IPT_PKTTYPE_H
-#define _IPT_PKTTYPE_H
-
-struct ipt_pkttype_info {
-	int	pkttype;
-	int	invert;
-};
-
-#endif /*_IPT_PKTTYPE_H*/
-- 
1.5.2.2
