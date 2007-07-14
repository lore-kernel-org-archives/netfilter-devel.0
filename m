From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 41/43] Unifies libip[6]t_TCPMSS.c into libxt_TCPMSS.c
Date: Sun, 15 Jul 2007 03:57:10 +0900 (JST)
Message-ID: <200707141857.l6EIvBDQ003273@toshiba.co.jp>
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
 extensions/Makefile                       |    6 +-
 extensions/libip6t_TCPMSS.c               |  134 ----------------------
 extensions/libipt_TCPMSS.c                |  134 ----------------------
 extensions/libxt_TCPMSS.c                 |  178 +++++++++++++++++++++++++++++
 include/linux/netfilter/xt_TCPMSS.h       |   10 ++
 include/linux/netfilter_ipv4/ipt_TCPMSS.h |   10 --
 6 files changed, 191 insertions(+), 281 deletions(-)
 delete mode 100644 extensions/libip6t_TCPMSS.c
 delete mode 100644 extensions/libipt_TCPMSS.c
 create mode 100644 extensions/libxt_TCPMSS.c
 create mode 100644 include/linux/netfilter/xt_TCPMSS.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_TCPMSS.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 0a46256..5690da3 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TRACE
+PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_TCPMSS.c b/extensions/libip6t_TCPMSS.c
deleted file mode 100644
index f93a5a3..0000000
--- a/extensions/libip6t_TCPMSS.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/* Shared library add-on to iptables to add TCPMSS target support.
- *
- * Copyright (c) 2000 Marc Boucher
-*/
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_TCPMSS.h>
-
-struct mssinfo {
-	struct xt_entry_target t;
-	struct ip6t_tcpmss_info mss;
-};
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"TCPMSS target v%s mutually-exclusive options:\n"
-"  --set-mss value               explicitly set MSS option to specified value\n"
-"  --clamp-mss-to-pmtu           automatically clamp MSS value to (path_MTU - 60)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "set-mss", 1, 0, '1' },
-	{ "clamp-mss-to-pmtu", 0, 0, '2' },
-	{ 0 }
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
-	struct ip6t_tcpmss_info *mssinfo
-		= (struct ip6t_tcpmss_info *)(*target)->data;
-
-	switch (c) {
-		unsigned int mssval;
-
-	case '1':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		if (string_to_number(optarg, 0, 65535 - 60, &mssval) == -1)
-			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
-
-		mssinfo->mss = mssval;
-		*flags = 1;
-		break;
-
-	case '2':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		mssinfo->mss = IP6T_TCPMSS_CLAMP_PMTU;
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
-		           "TCPMSS target: At least one parameter is required");
-}
-
-/* Prints out the targinfo. */
-static void
-print(const void *ip6,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ip6t_tcpmss_info *mssinfo =
-		(const struct ip6t_tcpmss_info *)target->data;
-	if(mssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU)
-		printf("TCPMSS clamp to PMTU ");
-	else
-		printf("TCPMSS set %u ", mssinfo->mss);
-}
-
-/* Saves the union ip6t_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ip6t_tcpmss_info *mssinfo =
-		(const struct ip6t_tcpmss_info *)target->data;
-
-	if(mssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU)
-		printf("--clamp-mss-to-pmtu ");
-	else
-		printf("--set-mss %u ", mssinfo->mss);
-}
-
-static struct ip6tables_target mss = {
-	.next		= NULL,
-	.name		= "TCPMSS",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_info)),
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
-	register_target6(&mss);
-}
diff --git a/extensions/libipt_TCPMSS.c b/extensions/libipt_TCPMSS.c
deleted file mode 100644
index 3f1855b..0000000
--- a/extensions/libipt_TCPMSS.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/* Shared library add-on to iptables to add TCPMSS target support.
- *
- * Copyright (c) 2000 Marc Boucher
-*/
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_TCPMSS.h>
-
-struct mssinfo {
-	struct xt_entry_target t;
-	struct ipt_tcpmss_info mss;
-};
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"TCPMSS target v%s mutually-exclusive options:\n"
-"  --set-mss value               explicitly set MSS option to specified value\n"
-"  --clamp-mss-to-pmtu           automatically clamp MSS value to (path_MTU - 40)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "set-mss", 1, 0, '1' },
-	{ "clamp-mss-to-pmtu", 0, 0, '2' },
-	{ 0 }
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
-	struct ipt_tcpmss_info *mssinfo
-		= (struct ipt_tcpmss_info *)(*target)->data;
-
-	switch (c) {
-		unsigned int mssval;
-
-	case '1':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		if (string_to_number(optarg, 0, 65535 - 40, &mssval) == -1)
-			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
-		
-		mssinfo->mss = mssval;
-		*flags = 1;
-		break;
-
-	case '2':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		mssinfo->mss = IPT_TCPMSS_CLAMP_PMTU;
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
-		           "TCPMSS target: At least one parameter is required");
-}
-
-/* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ipt_tcpmss_info *mssinfo =
-		(const struct ipt_tcpmss_info *)target->data;
-	if(mssinfo->mss == IPT_TCPMSS_CLAMP_PMTU)
-		printf("TCPMSS clamp to PMTU ");
-	else
-		printf("TCPMSS set %u ", mssinfo->mss);
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ipt_tcpmss_info *mssinfo =
-		(const struct ipt_tcpmss_info *)target->data;
-
-	if(mssinfo->mss == IPT_TCPMSS_CLAMP_PMTU)
-		printf("--clamp-mss-to-pmtu ");
-	else
-		printf("--set-mss %u ", mssinfo->mss);
-}
-
-static struct iptables_target mss = {
-	.next		= NULL,
-	.name		= "TCPMSS",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_tcpmss_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tcpmss_info)),
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
-	register_target(&mss);
-}
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
new file mode 100644
index 0000000..d5b6c1f
--- /dev/null
+++ b/extensions/libxt_TCPMSS.c
@@ -0,0 +1,178 @@
+/* Shared library add-on to iptables to add TCPMSS target support.
+ *
+ * Copyright (c) 2000 Marc Boucher
+*/
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPMSS.h>
+
+struct mssinfo {
+	struct xt_entry_target t;
+	struct xt_tcpmss_info mss;
+};
+
+/* Function which prints out usage message. */
+static void __help(int hdrsize)
+{
+	printf(
+"TCPMSS target v%s mutually-exclusive options:\n"
+"  --set-mss value               explicitly set MSS option to specified value\n"
+"  --clamp-mss-to-pmtu           automatically clamp MSS value to (path_MTU - %d)\n",
+IPTABLES_VERSION, hdrsize);
+}
+
+static void help(void)
+{
+	__help(40);
+}
+
+static void help6(void)
+{
+	__help(60);
+}
+
+static struct option opts[] = {
+	{ "set-mss", 1, 0, '1' },
+	{ "clamp-mss-to-pmtu", 0, 0, '2' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct xt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+__parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      struct xt_entry_target **target,
+      int hdrsize)
+{
+	struct xt_tcpmss_info *mssinfo
+		= (struct xt_tcpmss_info *)(*target)->data;
+
+	switch (c) {
+		unsigned int mssval;
+
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "TCPMSS target: Only one option may be specified");
+		if (string_to_number(optarg, 0, 65535 - hdrsize, &mssval) == -1)
+			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
+		
+		mssinfo->mss = mssval;
+		*flags = 1;
+		break;
+
+	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "TCPMSS target: Only one option may be specified");
+		mssinfo->mss = XT_TCPMSS_CLAMP_PMTU;
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
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      struct xt_entry_target **target)
+{
+	return __parse(c, argv, invert, flags, entry, target, 40);
+}
+
+static int
+parse6(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      struct xt_entry_target **target)
+{
+	return __parse(c, argv, invert, flags, entry, target, 60);
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPMSS target: At least one parameter is required");
+}
+
+/* Prints out the targinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_target *target,
+      int numeric)
+{
+	const struct xt_tcpmss_info *mssinfo =
+		(const struct xt_tcpmss_info *)target->data;
+	if(mssinfo->mss == XT_TCPMSS_CLAMP_PMTU)
+		printf("TCPMSS clamp to PMTU ");
+	else
+		printf("TCPMSS set %u ", mssinfo->mss);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tcpmss_info *mssinfo =
+		(const struct xt_tcpmss_info *)target->data;
+
+	if(mssinfo->mss == XT_TCPMSS_CLAMP_PMTU)
+		printf("--clamp-mss-to-pmtu ");
+	else
+		printf("--set-mss %u ", mssinfo->mss);
+}
+
+static struct xtables_target mss = {
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "TCPMSS",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_target mss6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "TCPMSS",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+	.help		= &help6,
+	.init		= &init,
+	.parse		= &parse6,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_target(&mss);
+	xtables_register_target(&mss6);
+}
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
new file mode 100644
index 0000000..53a292c
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -0,0 +1,10 @@
+#ifndef _XT_TCPMSS_H
+#define _XT_TCPMSS_H
+
+struct xt_tcpmss_info {
+	u_int16_t mss;
+};
+
+#define XT_TCPMSS_CLAMP_PMTU 0xffff
+
+#endif /* _XT_TCPMSS_H */
diff --git a/include/linux/netfilter_ipv4/ipt_TCPMSS.h b/include/linux/netfilter_ipv4/ipt_TCPMSS.h
deleted file mode 100644
index aadb395..0000000
--- a/include/linux/netfilter_ipv4/ipt_TCPMSS.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _IPT_TCPMSS_H
-#define _IPT_TCPMSS_H
-
-struct ipt_tcpmss_info {
-	u_int16_t mss;
-};
-
-#define IPT_TCPMSS_CLAMP_PMTU 0xffff
-
-#endif /*_IPT_TCPMSS_H*/
-- 
1.5.2.2
