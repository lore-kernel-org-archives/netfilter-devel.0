From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 03/13] Unifies libip[6]t_MARK into libxt_MARK
Date: Tue, 24 Jul 2007 15:58:09 +0900 (JST)
Message-ID: <200707240658.l6O6w9MD011972@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
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


 extensions/Makefile                        |    6 +-
 extensions/libip6t_MARK.c                  |  118 ----------------------------
 extensions/{libipt_MARK.c => libxt_MARK.c} |   91 +++++++++++++---------
 include/linux/netfilter/xt_MARK.h          |   21 +++++
 include/linux/netfilter_ipv4/ipt_MARK.h    |   19 -----
 include/linux/netfilter_ipv6/ip6t_MARK.h   |    8 --
 6 files changed, 78 insertions(+), 185 deletions(-)
 delete mode 100644 extensions/libip6t_MARK.c
 rename extensions/{libipt_MARK.c => libxt_MARK.c} (66%)
 create mode 100644 include/linux/netfilter/xt_MARK.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_MARK.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_MARK.h

diff --git a/extensions/Makefile b/extensions/Makefile
index d495725..904803e 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state HL LOG MARK TRACE
-PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state HL LOG TRACE
+PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libip6t_MARK.c b/extensions/libip6t_MARK.c
deleted file mode 100644
index 0ca4059..0000000
--- a/extensions/libip6t_MARK.c
+++ /dev/null
@@ -1,118 +0,0 @@
-/* Shared library add-on to iptables to add MARK target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv6/ip6t_MARK.h"
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MARK target v%s options:\n"
-"  --set-mark value                   Set nfmark value\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ .name = "set-mark", .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
-{
-	struct ip6t_mark_target_info *markinfo
-		= (struct ip6t_mark_target_info *)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (string_to_number_l(optarg, 0, 0, 
-				     &markinfo->mark))
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARK target: Can't specify --set-mark twice");
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
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-		           "MARK target: Parameter --set-mark is required");
-}
-
-static void
-print_mark(unsigned long mark)
-{
-	printf("0x%lx ", mark);
-}
-
-/* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ip6t_mark_target_info *markinfo =
-		(const struct ip6t_mark_target_info *)target->data;
-
-	printf("MARK set ");
-	print_mark(markinfo->mark);
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ip6t_mark_target_info *markinfo =
-		(const struct ip6t_mark_target_info *)target->data;
-
-	printf("--set-mark ");
-	print_mark(markinfo->mark);
-}
-
-static
-struct ip6tables_target mark = {
-	.name          = "MARK",
-	.version       = IPTABLES_VERSION,
-	.size          = IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
-	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
-	.help          = &help,
-	.init          = &init,
-	.parse         = &parse,
-	.final_check   = &final_check,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
-};
-
-void _init(void)
-{
-	register_target6(&mark);
-}
diff --git a/extensions/libipt_MARK.c b/extensions/libxt_MARK.c
similarity index 66%
rename from extensions/libipt_MARK.c
rename to extensions/libxt_MARK.c
index 62329ab..5c9890c 100644
--- a/extensions/libipt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -4,10 +4,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_MARK.h"
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_MARK.h>
 
 /* Function which prints out usage message. */
 static void
@@ -42,8 +41,8 @@ parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	 const void *entry,
 	 struct xt_entry_target **target)
 {
-	struct ipt_mark_target_info *markinfo
-		= (struct ipt_mark_target_info *)(*target)->data;
+	struct xt_mark_target_info *markinfo
+		= (struct xt_mark_target_info *)(*target)->data;
 
 	switch (c) {
 	case '1':
@@ -84,18 +83,18 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const void *entry,
 	 struct xt_entry_target **target)
 {
-	struct ipt_mark_target_info_v1 *markinfo
-		= (struct ipt_mark_target_info_v1 *)(*target)->data;
+	struct xt_mark_target_info_v1 *markinfo
+		= (struct xt_mark_target_info_v1 *)(*target)->data;
 
 	switch (c) {
 	case '1':
-	        markinfo->mode = IPT_MARK_SET;
+	        markinfo->mode = XT_MARK_SET;
 		break;
 	case '2':
-	        markinfo->mode = IPT_MARK_AND;
+	        markinfo->mode = XT_MARK_AND;
 		break;
 	case '3':
-	        markinfo->mode = IPT_MARK_OR;
+	        markinfo->mode = XT_MARK_OR;
 		break;
 	default:
 		return 0;
@@ -124,8 +123,8 @@ print_v0(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
-	const struct ipt_mark_target_info *markinfo =
-		(const struct ipt_mark_target_info *)target->data;
+	const struct xt_mark_target_info *markinfo =
+		(const struct xt_mark_target_info *)target->data;
 	printf("MARK set ");
 	print_mark(markinfo->mark);
 }
@@ -134,8 +133,8 @@ print_v0(const void *ip,
 static void
 save_v0(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_mark_target_info *markinfo =
-		(const struct ipt_mark_target_info *)target->data;
+	const struct xt_mark_target_info *markinfo =
+		(const struct xt_mark_target_info *)target->data;
 
 	printf("--set-mark ");
 	print_mark(markinfo->mark);
@@ -147,17 +146,17 @@ print_v1(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
-	const struct ipt_mark_target_info_v1 *markinfo =
-		(const struct ipt_mark_target_info_v1 *)target->data;
+	const struct xt_mark_target_info_v1 *markinfo =
+		(const struct xt_mark_target_info_v1 *)target->data;
 
 	switch (markinfo->mode) {
-	case IPT_MARK_SET:
+	case XT_MARK_SET:
 		printf("MARK set ");
 		break;
-	case IPT_MARK_AND:
+	case XT_MARK_AND:
 		printf("MARK and ");
 		break;
-	case IPT_MARK_OR: 
+	case XT_MARK_OR: 
 		printf("MARK or ");
 		break;
 	}
@@ -168,59 +167,77 @@ print_v1(const void *ip,
 static void
 save_v1(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_mark_target_info_v1 *markinfo =
-		(const struct ipt_mark_target_info_v1 *)target->data;
+	const struct xt_mark_target_info_v1 *markinfo =
+		(const struct xt_mark_target_info_v1 *)target->data;
 
 	switch (markinfo->mode) {
-	case IPT_MARK_SET:
+	case XT_MARK_SET:
 		printf("--set-mark ");
 		break;
-	case IPT_MARK_AND:
+	case XT_MARK_AND:
 		printf("--and-mark ");
 		break;
-	case IPT_MARK_OR: 
+	case XT_MARK_OR: 
 		printf("--or-mark ");
 		break;
 	}
 	print_mark(markinfo->mark);
 }
 
-static
-struct iptables_target mark_v0 = {
+static struct xtables_target mark_v0 = {
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
-	.size		= IPT_ALIGN(sizeof(struct ipt_mark_target_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mark_target_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse_v0,
 	.final_check	= &final_check,
 	.print		= &print_v0,
 	.save		= &save_v0,
-	.extra_opts	= opts
+	.extra_opts	= opts,
 };
 
-static
-struct iptables_target mark_v1 = {
+static struct xtables_target mark_v1 = {
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
-	.size		= IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1)),
+	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse_v1,
 	.final_check	= &final_check,
 	.print		= &print_v1,
 	.save		= &save_v1,
-	.extra_opts	= opts
+	.extra_opts	= opts,
+};
+
+static struct xtables_target mark6_v0 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "MARK",
+	.version	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse_v0,
+	.final_check	= &final_check,
+	.print		= &print_v0,
+	.save		= &save_v0,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_target(&mark_v0);
-	register_target(&mark_v1);
+	xtables_register_target(&mark_v0);
+	xtables_register_target(&mark_v1);
+	xtables_register_target(&mark6_v0);
 }
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
new file mode 100644
index 0000000..b021e93
--- /dev/null
+++ b/include/linux/netfilter/xt_MARK.h
@@ -0,0 +1,21 @@
+#ifndef _XT_MARK_H_target
+#define _XT_MARK_H_target
+
+/* Version 0 */
+struct xt_mark_target_info {
+	unsigned long mark;
+};
+
+/* Version 1 */
+enum {
+	XT_MARK_SET=0,
+	XT_MARK_AND,
+	XT_MARK_OR,
+};
+
+struct xt_mark_target_info_v1 {
+	unsigned long mark;
+	u_int8_t mode;
+};
+
+#endif /*_XT_MARK_H_target */
diff --git a/include/linux/netfilter_ipv4/ipt_MARK.h b/include/linux/netfilter_ipv4/ipt_MARK.h
deleted file mode 100644
index 1b6502f..0000000
--- a/include/linux/netfilter_ipv4/ipt_MARK.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IPT_MARK_H_target
-#define _IPT_MARK_H_target
-
-struct ipt_mark_target_info {
-	unsigned long mark;
-};
-
-enum {
-	IPT_MARK_SET=0,
-	IPT_MARK_AND,
-	IPT_MARK_OR
-};
-
-struct ipt_mark_target_info_v1 {
-	unsigned long mark;
-	u_int8_t mode;
-};
-
-#endif /*_IPT_MARK_H_target*/
diff --git a/include/linux/netfilter_ipv6/ip6t_MARK.h b/include/linux/netfilter_ipv6/ip6t_MARK.h
deleted file mode 100644
index 7ade8d8..0000000
--- a/include/linux/netfilter_ipv6/ip6t_MARK.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _IP6T_MARK_H_target
-#define _IP6T_MARK_H_target
-
-struct ip6t_mark_target_info {
-	unsigned long mark;
-};
-
-#endif /*_IPT_MARK_H_target*/
-- 
1.5.2.2
