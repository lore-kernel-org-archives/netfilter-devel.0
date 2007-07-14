From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 33/43] Unifies libip[6]t_physdev.c into libxt_physdev.c
Date: Sun, 15 Jul 2007 03:12:12 +0900 (JST)
Message-ID: <200707141812.l6EICCDH003097@toshiba.co.jp>
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
 extensions/Makefile                         |    6 +-
 extensions/libip6t_physdev.c                |  192 ------------------------
 extensions/libipt_physdev.c                 |  193 ------------------------
 extensions/libxt_physdev.c                  |  211 +++++++++++++++++++++++++++
 include/linux/netfilter/xt_physdev.h        |   24 +++
 include/linux/netfilter_ipv4/ipt_physdev.h  |   24 ---
 include/linux/netfilter_ipv6/ip6t_physdev.h |   24 ---
 7 files changed, 238 insertions(+), 436 deletions(-)
 delete mode 100644 extensions/libip6t_physdev.c
 delete mode 100644 extensions/libipt_physdev.c
 create mode 100644 extensions/libxt_physdev.c
 create mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_physdev.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_physdev.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 85ed1aa..70af48b 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport pkttype sctp standard tcp tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_physdev.c b/extensions/libip6t_physdev.c
deleted file mode 100644
index d2a37f6..0000000
--- a/extensions/libip6t_physdev.c
+++ /dev/null
@@ -1,192 +0,0 @@
-/* Shared library add-on to iptables to add bridge port matching support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_physdev.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
-
-static void
-help(void)
-{
-	printf(
-"physdev v%s options:\n"
-" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
-" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
-" [!] --physdev-is-in			arrived on a bridge device\n"
-" [!] --physdev-is-out			will leave on a bridge device\n"
-" [!] --physdev-is-bridged		it's a bridged packet\n"
-"\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "physdev-in", 1, 0, '1' },
-	{ "physdev-out", 1, 0, '2' },
-	{ "physdev-is-in", 0, 0, '3' },
-	{ "physdev-is-out", 0, 0, '4' },
-	{ "physdev-is-bridged", 0, 0, '5' },
-	{0}
-};
-
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-}
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_physdev_info *info =
-		(struct ip6t_physdev_info*)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_PHYSDEV_OP_IN)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physindev,
-				(unsigned char *)info->in_mask);
-		if (invert)
-			info->invert |= IP6T_PHYSDEV_OP_IN;
-		info->bitmask |= IP6T_PHYSDEV_OP_IN;
-		*flags |= IP6T_PHYSDEV_OP_IN;
-		break;
-
-	case '2':
-		if (*flags & IP6T_PHYSDEV_OP_OUT)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physoutdev,
-				(unsigned char *)info->out_mask);
-		if (invert)
-			info->invert |= IP6T_PHYSDEV_OP_OUT;
-		info->bitmask |= IP6T_PHYSDEV_OP_OUT;
-		*flags |= IP6T_PHYSDEV_OP_OUT;
-		break;
-
-	case '3':
-		if (*flags & IP6T_PHYSDEV_OP_ISIN)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		info->bitmask |= IP6T_PHYSDEV_OP_ISIN;
-		if (invert)
-			info->invert |= IP6T_PHYSDEV_OP_ISIN;
-		*flags |= IP6T_PHYSDEV_OP_ISIN;
-		break;
-
-	case '4':
-		if (*flags & IP6T_PHYSDEV_OP_ISOUT)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		info->bitmask |= IP6T_PHYSDEV_OP_ISOUT;
-		if (invert)
-			info->invert |= IP6T_PHYSDEV_OP_ISOUT;
-		*flags |= IP6T_PHYSDEV_OP_ISOUT;
-		break;
-
-	case '5':
-		if (*flags & IP6T_PHYSDEV_OP_BRIDGED)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		if (invert)
-			info->invert |= IP6T_PHYSDEV_OP_BRIDGED;
-		*flags |= IP6T_PHYSDEV_OP_BRIDGED;
-		info->bitmask |= IP6T_PHYSDEV_OP_BRIDGED;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-multiple_use:
-	exit_error(PARAMETER_PROBLEM,
-	   "multiple use of the same physdev option is not allowed");
-
-}
-
-static void final_check(unsigned int flags)
-{
-	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
-}
-
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ip6t_physdev_info *info =
-		(struct ip6t_physdev_info*)match->data;
-
-	printf("PHYSDEV match");
-	if (info->bitmask & IP6T_PHYSDEV_OP_ISIN)
-		printf("%s --physdev-is-in",
-		       info->invert & IP6T_PHYSDEV_OP_ISIN ? " !":"");
-	if (info->bitmask & IP6T_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
-		(info->invert & IP6T_PHYSDEV_OP_IN) ? " !":"", info->physindev);
-
-	if (info->bitmask & IP6T_PHYSDEV_OP_ISOUT)
-		printf("%s --physdev-is-out",
-		       info->invert & IP6T_PHYSDEV_OP_ISOUT ? " !":"");
-	if (info->bitmask & IP6T_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
-		(info->invert & IP6T_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
-	if (info->bitmask & IP6T_PHYSDEV_OP_BRIDGED)
-		printf("%s --physdev-is-bridged",
-		       info->invert & IP6T_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
-}
-
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ip6t_physdev_info *info =
-		(struct ip6t_physdev_info*)match->data;
-
-	if (info->bitmask & IP6T_PHYSDEV_OP_ISIN)
-		printf("%s --physdev-is-in",
-		       info->invert & IP6T_PHYSDEV_OP_ISIN ? " !":"");
-	if (info->bitmask & IP6T_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
-		(info->invert & IP6T_PHYSDEV_OP_IN) ? " !":"", info->physindev);
-
-	if (info->bitmask & IP6T_PHYSDEV_OP_ISOUT)
-		printf("%s --physdev-is-out",
-		       info->invert & IP6T_PHYSDEV_OP_ISOUT ? " !":"");
-	if (info->bitmask & IP6T_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
-		(info->invert & IP6T_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
-	if (info->bitmask & IP6T_PHYSDEV_OP_BRIDGED)
-		printf("%s --physdev-is-bridged",
-		       info->invert & IP6T_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
-}
-
-static struct ip6tables_match physdev = {
-	.name		= "physdev",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_physdev_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_physdev_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_match6(&physdev);
-}
diff --git a/extensions/libipt_physdev.c b/extensions/libipt_physdev.c
deleted file mode 100644
index d80fb0c..0000000
--- a/extensions/libipt_physdev.c
+++ /dev/null
@@ -1,193 +0,0 @@
-/* Shared library add-on to iptables to add bridge port matching support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_physdev.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
-
-static void
-help(void)
-{
-	printf(
-"physdev v%s options:\n"
-" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
-" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
-" [!] --physdev-is-in			arrived on a bridge device\n"
-" [!] --physdev-is-out			will leave on a bridge device\n"
-" [!] --physdev-is-bridged		it's a bridged packet\n"
-"\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "physdev-in", 1, 0, '1' },
-	{ "physdev-out", 1, 0, '2' },
-	{ "physdev-is-in", 0, 0, '3' },
-	{ "physdev-is-out", 0, 0, '4' },
-	{ "physdev-is-bridged", 0, 0, '5' },
-	{0}
-};
-
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-}
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_physdev_info *info =
-		(struct ipt_physdev_info*)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IPT_PHYSDEV_OP_IN)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physindev,
-				(unsigned char *)info->in_mask);
-		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_IN;
-		info->bitmask |= IPT_PHYSDEV_OP_IN;
-		*flags |= IPT_PHYSDEV_OP_IN;
-		break;
-
-	case '2':
-		if (*flags & IPT_PHYSDEV_OP_OUT)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physoutdev,
-				(unsigned char *)info->out_mask);
-		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_OUT;
-		info->bitmask |= IPT_PHYSDEV_OP_OUT;
-		*flags |= IPT_PHYSDEV_OP_OUT;
-		break;
-
-	case '3':
-		if (*flags & IPT_PHYSDEV_OP_ISIN)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		info->bitmask |= IPT_PHYSDEV_OP_ISIN;
-		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_ISIN;
-		*flags |= IPT_PHYSDEV_OP_ISIN;
-		break;
-
-	case '4':
-		if (*flags & IPT_PHYSDEV_OP_ISOUT)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		info->bitmask |= IPT_PHYSDEV_OP_ISOUT;
-		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_ISOUT;
-		*flags |= IPT_PHYSDEV_OP_ISOUT;
-		break;
-
-	case '5':
-		if (*flags & IPT_PHYSDEV_OP_BRIDGED)
-			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
-		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_BRIDGED;
-		*flags |= IPT_PHYSDEV_OP_BRIDGED;
-		info->bitmask |= IPT_PHYSDEV_OP_BRIDGED;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-multiple_use:
-	exit_error(PARAMETER_PROBLEM,
-	   "multiple use of the same physdev option is not allowed");
-
-}
-
-static void final_check(unsigned int flags)
-{
-	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
-}
-
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ipt_physdev_info *info =
-		(struct ipt_physdev_info*)match->data;
-
-	printf("PHYSDEV match");
-	if (info->bitmask & IPT_PHYSDEV_OP_ISIN)
-		printf("%s --physdev-is-in",
-		       info->invert & IPT_PHYSDEV_OP_ISIN ? " !":"");
-	if (info->bitmask & IPT_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
-		(info->invert & IPT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
-
-	if (info->bitmask & IPT_PHYSDEV_OP_ISOUT)
-		printf("%s --physdev-is-out",
-		       info->invert & IPT_PHYSDEV_OP_ISOUT ? " !":"");
-	if (info->bitmask & IPT_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
-		(info->invert & IPT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
-	if (info->bitmask & IPT_PHYSDEV_OP_BRIDGED)
-		printf("%s --physdev-is-bridged",
-		       info->invert & IPT_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
-}
-
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_physdev_info *info =
-		(struct ipt_physdev_info*)match->data;
-
-	if (info->bitmask & IPT_PHYSDEV_OP_ISIN)
-		printf("%s --physdev-is-in",
-		       info->invert & IPT_PHYSDEV_OP_ISIN ? " !":"");
-	if (info->bitmask & IPT_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
-		(info->invert & IPT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
-
-	if (info->bitmask & IPT_PHYSDEV_OP_ISOUT)
-		printf("%s --physdev-is-out",
-		       info->invert & IPT_PHYSDEV_OP_ISOUT ? " !":"");
-	if (info->bitmask & IPT_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
-		(info->invert & IPT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
-	if (info->bitmask & IPT_PHYSDEV_OP_BRIDGED)
-		printf("%s --physdev-is-bridged",
-		       info->invert & IPT_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
-}
-
-static struct iptables_match physdev = { 
-	.next		= NULL,
-	.name		= "physdev",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_physdev_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_physdev_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_match(&physdev);
-}
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
new file mode 100644
index 0000000..397c5e9
--- /dev/null
+++ b/extensions/libxt_physdev.c
@@ -0,0 +1,211 @@
+/* Shared library add-on to iptables to add bridge port matching support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_physdev.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+
+static void
+help(void)
+{
+	printf(
+"physdev v%s options:\n"
+" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
+" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
+" [!] --physdev-is-in			arrived on a bridge device\n"
+" [!] --physdev-is-out			will leave on a bridge device\n"
+" [!] --physdev-is-bridged		it's a bridged packet\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "physdev-in", 1, 0, '1' },
+	{ "physdev-out", 1, 0, '2' },
+	{ "physdev-is-in", 0, 0, '3' },
+	{ "physdev-is-out", 0, 0, '4' },
+	{ "physdev-is-bridged", 0, 0, '5' },
+	{0}
+};
+
+static void
+init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_physdev_info *info =
+		(struct xt_physdev_info*)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & XT_PHYSDEV_OP_IN)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physindev,
+				(unsigned char *)info->in_mask);
+		if (invert)
+			info->invert |= XT_PHYSDEV_OP_IN;
+		info->bitmask |= XT_PHYSDEV_OP_IN;
+		*flags |= XT_PHYSDEV_OP_IN;
+		break;
+
+	case '2':
+		if (*flags & XT_PHYSDEV_OP_OUT)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physoutdev,
+				(unsigned char *)info->out_mask);
+		if (invert)
+			info->invert |= XT_PHYSDEV_OP_OUT;
+		info->bitmask |= XT_PHYSDEV_OP_OUT;
+		*flags |= XT_PHYSDEV_OP_OUT;
+		break;
+
+	case '3':
+		if (*flags & XT_PHYSDEV_OP_ISIN)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= XT_PHYSDEV_OP_ISIN;
+		if (invert)
+			info->invert |= XT_PHYSDEV_OP_ISIN;
+		*flags |= XT_PHYSDEV_OP_ISIN;
+		break;
+
+	case '4':
+		if (*flags & XT_PHYSDEV_OP_ISOUT)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= XT_PHYSDEV_OP_ISOUT;
+		if (invert)
+			info->invert |= XT_PHYSDEV_OP_ISOUT;
+		*flags |= XT_PHYSDEV_OP_ISOUT;
+		break;
+
+	case '5':
+		if (*flags & XT_PHYSDEV_OP_BRIDGED)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |= XT_PHYSDEV_OP_BRIDGED;
+		*flags |= XT_PHYSDEV_OP_BRIDGED;
+		info->bitmask |= XT_PHYSDEV_OP_BRIDGED;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+multiple_use:
+	exit_error(PARAMETER_PROBLEM,
+	   "multiple use of the same physdev option is not allowed");
+
+}
+
+static void final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
+}
+
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	struct xt_physdev_info *info =
+		(struct xt_physdev_info*)match->data;
+
+	printf("PHYSDEV match");
+	if (info->bitmask & XT_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & XT_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & XT_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & XT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & XT_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & XT_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & XT_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & XT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & XT_PHYSDEV_OP_BRIDGED ? " !":"");
+	printf(" ");
+}
+
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_physdev_info *info =
+		(struct xt_physdev_info*)match->data;
+
+	if (info->bitmask & XT_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & XT_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & XT_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & XT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & XT_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & XT_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & XT_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & XT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & XT_PHYSDEV_OP_BRIDGED ? " !":"");
+	printf(" ");
+}
+
+static struct xtables_match physdev = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "physdev",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match physdev6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "physdev",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&physdev);
+	xtables_register_match(&physdev6);
+}
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
new file mode 100644
index 0000000..25a7a18
--- /dev/null
+++ b/include/linux/netfilter/xt_physdev.h
@@ -0,0 +1,24 @@
+#ifndef _XT_PHYSDEV_H
+#define _XT_PHYSDEV_H
+
+#ifdef __KERNEL__
+#include <linux/if.h>
+#endif
+
+#define XT_PHYSDEV_OP_IN		0x01
+#define XT_PHYSDEV_OP_OUT		0x02
+#define XT_PHYSDEV_OP_BRIDGED		0x04
+#define XT_PHYSDEV_OP_ISIN		0x08
+#define XT_PHYSDEV_OP_ISOUT		0x10
+#define XT_PHYSDEV_OP_MASK		(0x20 - 1)
+
+struct xt_physdev_info {
+	char physindev[IFNAMSIZ];
+	char in_mask[IFNAMSIZ];
+	char physoutdev[IFNAMSIZ];
+	char out_mask[IFNAMSIZ];
+	u_int8_t invert;
+	u_int8_t bitmask;
+};
+
+#endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_physdev.h b/include/linux/netfilter_ipv4/ipt_physdev.h
deleted file mode 100644
index 7538c86..0000000
--- a/include/linux/netfilter_ipv4/ipt_physdev.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef _IPT_PHYSDEV_H
-#define _IPT_PHYSDEV_H
-
-#ifdef __KERNEL__
-#include <linux/if.h>
-#endif
-
-#define IPT_PHYSDEV_OP_IN		0x01
-#define IPT_PHYSDEV_OP_OUT		0x02
-#define IPT_PHYSDEV_OP_BRIDGED		0x04
-#define IPT_PHYSDEV_OP_ISIN		0x08
-#define IPT_PHYSDEV_OP_ISOUT		0x10
-#define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
-
-struct ipt_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
-};
-
-#endif /*_IPT_PHYSDEV_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_physdev.h b/include/linux/netfilter_ipv6/ip6t_physdev.h
deleted file mode 100644
index c234731..0000000
--- a/include/linux/netfilter_ipv6/ip6t_physdev.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef _IP6T_PHYSDEV_H
-#define _IP6T_PHYSDEV_H
-
-#ifdef __KERNEL__
-#include <linux/if.h>
-#endif
-
-#define IP6T_PHYSDEV_OP_IN		0x01
-#define IP6T_PHYSDEV_OP_OUT		0x02
-#define IP6T_PHYSDEV_OP_BRIDGED		0x04
-#define IP6T_PHYSDEV_OP_ISIN		0x08
-#define IP6T_PHYSDEV_OP_ISOUT		0x10
-#define IP6T_PHYSDEV_OP_MASK		(0x20 - 1)
-
-struct ip6t_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
-};
-
-#endif /*_IP6T_PHYSDEV_H*/
-- 
1.5.2.2
