From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 34/43] Unifies libip[6]t_mac.c into libxt_mac.c
Date: Sun, 15 Jul 2007 03:12:21 +0900 (JST)
Message-ID: <200707141812.l6EICM5N000538@toshiba.co.jp>
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
 extensions/Makefile              |    6 +-
 extensions/libip6t_mac.c         |  139 ---------------------------------
 extensions/libipt_mac.c          |  140 ---------------------------------
 extensions/libxt_mac.c           |  157 ++++++++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_mac.h |    8 ++
 5 files changed, 168 insertions(+), 282 deletions(-)
 delete mode 100644 extensions/libip6t_mac.c
 delete mode 100644 extensions/libipt_mac.c
 create mode 100644 extensions/libxt_mac.c
 create mode 100644 include/linux/netfilter/xt_mac.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 70af48b..3fbb1b4 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_mac.c b/extensions/libip6t_mac.c
deleted file mode 100644
index 77a6390..0000000
--- a/extensions/libip6t_mac.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/* Shared library add-on to iptables to add MAC address support. */
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
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_mac.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MAC v%s options:\n"
-" --mac-source [!] XX:XX:XX:XX:XX:XX\n"
-"				Match source MAC address\n"
-"\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "mac-source", 1, 0, '1' },
-	{0}
-};
-
-static void
-parse_mac(const char *mac, struct ip6t_mac_info *info)
-{
-	unsigned int i = 0;
-
-	if (strlen(mac) != ETH_ALEN*3-1)
-		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		long number;
-		char *end;
-
-		number = strtol(mac + i*3, &end, 16);
-
-		if (end == mac + i*3 + 2
-		    && number >= 0
-		    && number <= 255)
-			info->srcaddr[i] = number;
-		else
-			exit_error(PARAMETER_PROBLEM,
-				   "Bad mac address `%s'", mac);
-	}
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_mac_info *macinfo = (struct ip6t_mac_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_mac(argv[optind-1], macinfo);
-		if (invert)
-			macinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void print_mac(unsigned char macaddress[ETH_ALEN])
-{
-	unsigned int i;
-
-	printf("%02X", macaddress[0]);
-	for (i = 1; i < ETH_ALEN; i++)
-		printf(":%02X", macaddress[i]);
-	printf(" ");
-}
-
-/* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "You must specify `--mac-source'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	printf("MAC ");
-
-	if (((struct ip6t_mac_info *)match->data)->invert)
-		printf("! ");
-
-	print_mac(((struct ip6t_mac_info *)match->data)->srcaddr);
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	if (((struct ip6t_mac_info *)match->data)->invert)
-		printf("! ");
-
-	printf("--mac-source ");
-	print_mac(((struct ip6t_mac_info *)match->data)->srcaddr);
-}
-
-static struct ip6tables_match mac = {
-	.name		= "mac",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_mac_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mac_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_match6(&mac);
-}
diff --git a/extensions/libipt_mac.c b/extensions/libipt_mac.c
deleted file mode 100644
index 13fa69a..0000000
--- a/extensions/libipt_mac.c
+++ /dev/null
@@ -1,140 +0,0 @@
-/* Shared library add-on to iptables to add MAC address support. */
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
-#include <linux/netfilter_ipv4/ipt_mac.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MAC v%s options:\n"
-" --mac-source [!] XX:XX:XX:XX:XX:XX\n"
-"				Match source MAC address\n"
-"\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "mac-source", 1, 0, '1' },
-	{0}
-};
-
-static void
-parse_mac(const char *mac, struct ipt_mac_info *info)
-{
-	unsigned int i = 0;
-
-	if (strlen(mac) != ETH_ALEN*3-1)
-		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		long number;
-		char *end;
-
-		number = strtol(mac + i*3, &end, 16);
-
-		if (end == mac + i*3 + 2
-		    && number >= 0
-		    && number <= 255)
-			info->srcaddr[i] = number;
-		else
-			exit_error(PARAMETER_PROBLEM,
-				   "Bad mac address `%s'", mac);
-	}
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_mac_info *macinfo = (struct ipt_mac_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_mac(argv[optind-1], macinfo);
-		if (invert)
-			macinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void print_mac(unsigned char macaddress[ETH_ALEN])
-{
-	unsigned int i;
-
-	printf("%02X", macaddress[0]);
-	for (i = 1; i < ETH_ALEN; i++)
-		printf(":%02X", macaddress[i]);
-	printf(" ");
-}
-
-/* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "You must specify `--mac-source'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	printf("MAC ");
-
-	if (((struct ipt_mac_info *)match->data)->invert)
-		printf("! ");
-	
-	print_mac(((struct ipt_mac_info *)match->data)->srcaddr);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	if (((struct ipt_mac_info *)match->data)->invert)
-		printf("! ");
-
-	printf("--mac-source ");
-	print_mac(((struct ipt_mac_info *)match->data)->srcaddr);
-}
-
-static struct iptables_match mac = { 
-	.next		= NULL,
- 	.name		= "mac",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_mac_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mac_info)),
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
-	register_match(&mac);
-}
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
new file mode 100644
index 0000000..61da13b
--- /dev/null
+++ b/extensions/libxt_mac.c
@@ -0,0 +1,157 @@
+/* Shared library add-on to iptables to add MAC address support. */
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
+#include <linux/netfilter/xt_mac.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"MAC v%s options:\n"
+" --mac-source [!] XX:XX:XX:XX:XX:XX\n"
+"				Match source MAC address\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mac-source", 1, 0, '1' },
+	{0}
+};
+
+static void
+parse_mac(const char *mac, struct xt_mac_info *info)
+{
+	unsigned int i = 0;
+
+	if (strlen(mac) != ETH_ALEN*3-1)
+		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
+
+	for (i = 0; i < ETH_ALEN; i++) {
+		long number;
+		char *end;
+
+		number = strtol(mac + i*3, &end, 16);
+
+		if (end == mac + i*3 + 2
+		    && number >= 0
+		    && number <= 255)
+			info->srcaddr[i] = number;
+		else
+			exit_error(PARAMETER_PROBLEM,
+				   "Bad mac address `%s'", mac);
+	}
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_mac_info *macinfo = (struct xt_mac_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_mac(argv[optind-1], macinfo);
+		if (invert)
+			macinfo->invert = 1;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void print_mac(unsigned char macaddress[ETH_ALEN])
+{
+	unsigned int i;
+
+	printf("%02X", macaddress[0]);
+	for (i = 1; i < ETH_ALEN; i++)
+		printf(":%02X", macaddress[i]);
+	printf(" ");
+}
+
+/* Final check; must have specified --mac. */
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "You must specify `--mac-source'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	printf("MAC ");
+
+	if (((struct xt_mac_info *)match->data)->invert)
+		printf("! ");
+	
+	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	if (((struct xt_mac_info *)match->data)->invert)
+		printf("! ");
+
+	printf("--mac-source ");
+	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
+}
+
+static struct xtables_match mac = { 
+	.next		= NULL,
+	.family		= AF_INET,
+ 	.name		= "mac",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match mac6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+ 	.name		= "mac",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
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
+	xtables_register_match(&mac);
+	xtables_register_match(&mac6);
+}
diff --git a/include/linux/netfilter/xt_mac.h b/include/linux/netfilter/xt_mac.h
new file mode 100644
index 0000000..b892cdc
--- /dev/null
+++ b/include/linux/netfilter/xt_mac.h
@@ -0,0 +1,8 @@
+#ifndef _XT_MAC_H
+#define _XT_MAC_H
+
+struct xt_mac_info {
+    unsigned char srcaddr[ETH_ALEN];
+    int invert;
+};
+#endif /*_XT_MAC_H*/
-- 
1.5.2.2
