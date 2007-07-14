From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 43/43] Unifies libip[6]t_NFQUEUE.c into libxt_NFQUEUE.c
Date: Sun, 15 Jul 2007 03:57:27 +0900 (JST)
Message-ID: <200707141857.l6EIvSgF028755@toshiba.co.jp>
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
 extensions/Makefile                        |    6 +-
 extensions/libip6t_NFQUEUE.c               |  114 ------------------------
 extensions/libipt_NFQUEUE.c                |  114 ------------------------
 extensions/libxt_NFQUEUE.c                 |  132 ++++++++++++++++++++++++++++
 include/linux/netfilter/xt_NFQUEUE.h       |   16 ++++
 include/linux/netfilter_ipv4/ipt_NFQUEUE.h |   16 ----
 6 files changed, 151 insertions(+), 247 deletions(-)
 delete mode 100644 extensions/libip6t_NFQUEUE.c
 delete mode 100644 extensions/libipt_NFQUEUE.c
 create mode 100644 extensions/libxt_NFQUEUE.c
 create mode 100644 include/linux/netfilter/xt_NFQUEUE.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_NFQUEUE.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 3159b3d..fa3fdb5 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TRACE
-PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG MARK TRACE
+PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=CONNSECMARK
diff --git a/extensions/libip6t_NFQUEUE.c b/extensions/libip6t_NFQUEUE.c
deleted file mode 100644
index afc3a6e..0000000
--- a/extensions/libip6t_NFQUEUE.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/* Shared library add-on to ip666666tables for NFQ
- *
- * (C) 2005 by Harald Welte <laforge@netfilter.org>
- *
- * This program is distributed under the terms of GNU GPL v2, 1991
- *
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
-
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-static void help(void) 
-{
-	printf(
-"NFQUEUE target options\n"
-"  --queue-num value		Send packet to QUEUE number <value>.\n"
-"  		                Valid queue numbers are 0-65535\n"
-);
-}
-
-static struct option opts[] = {
-	{ "queue-num", 1, 0, 'F' },
-	{ 0 }
-};
-
-static void
-parse_num(const char *s, struct ipt_NFQ_info *tinfo)
-{
-	unsigned int num;
-       
-	if (string_to_number(s, 0, 65535, &num) == -1)
-		exit_error(PARAMETER_PROBLEM,
-			   "Invalid queue number `%s'\n", s);
-
-    	tinfo->queuenum = num & 0xffff;
-    	return;
-}
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
-{
-	struct ipt_NFQ_info *tinfo
-		= (struct ipt_NFQ_info *)(*target)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM, "NFQUEUE target: "
-				   "Only use --queue-num ONCE!");
-		parse_num(optarg, tinfo);
-		break;
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
-}
-
-/* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ipt_NFQ_info *tinfo =
-		(const struct ipt_NFQ_info *)target->data;
-	printf("NFQUEUE num %u", tinfo->queuenum);
-}
-
-/* Saves the union ip6t_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ipt_NFQ_info *tinfo =
-		(const struct ipt_NFQ_info *)target->data;
-
-	printf("--queue-num %u ", tinfo->queuenum);
-}
-
-static struct ip6tables_target nfqueue = { 
-	.next		= NULL,
-	.name		= "NFQUEUE",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ipt_NFQ_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ipt_NFQ_info)),
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
-	register_target6(&nfqueue);
-}
diff --git a/extensions/libipt_NFQUEUE.c b/extensions/libipt_NFQUEUE.c
deleted file mode 100644
index 5d608fc..0000000
--- a/extensions/libipt_NFQUEUE.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/* Shared library add-on to iptables for NFQ
- *
- * (C) 2005 by Harald Welte <laforge@netfilter.org>
- *
- * This program is distributed under the terms of GNU GPL v2, 1991
- *
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
-
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-static void help(void) 
-{
-	printf(
-"NFQUEUE target options\n"
-"  --queue-num value		Send packet to QUEUE number <value>.\n"
-"  		                Valid queue numbers are 0-65535\n"
-);
-}
-
-static struct option opts[] = {
-	{ "queue-num", 1, 0, 'F' },
-	{ 0 }
-};
-
-static void
-parse_num(const char *s, struct ipt_NFQ_info *tinfo)
-{
-	unsigned int num;
-       
-	if (string_to_number(s, 0, 65535, &num) == -1)
-		exit_error(PARAMETER_PROBLEM,
-			   "Invalid queue number `%s'\n", s);
-
-    	tinfo->queuenum = num & 0xffff;
-    	return;
-}
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
-{
-	struct ipt_NFQ_info *tinfo
-		= (struct ipt_NFQ_info *)(*target)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM, "NFQUEUE target: "
-				   "Only use --queue-num ONCE!");
-		parse_num(optarg, tinfo);
-		break;
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
-}
-
-/* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ipt_NFQ_info *tinfo =
-		(const struct ipt_NFQ_info *)target->data;
-	printf("NFQUEUE num %u", tinfo->queuenum);
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ipt_NFQ_info *tinfo =
-		(const struct ipt_NFQ_info *)target->data;
-
-	printf("--queue-num %u ", tinfo->queuenum);
-}
-
-static struct iptables_target nfqueue = { 
-	.next		= NULL,
-	.name		= "NFQUEUE",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_NFQ_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_NFQ_info)),
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
-	register_target(&nfqueue);
-}
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
new file mode 100644
index 0000000..558e80b
--- /dev/null
+++ b/extensions/libxt_NFQUEUE.c
@@ -0,0 +1,132 @@
+/* Shared library add-on to iptables for NFQ
+ *
+ * (C) 2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * This program is distributed under the terms of GNU GPL v2, 1991
+ *
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NFQUEUE.h>
+
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+static void help(void) 
+{
+	printf(
+"NFQUEUE target options\n"
+"  --queue-num value		Send packet to QUEUE number <value>.\n"
+"  		                Valid queue numbers are 0-65535\n"
+);
+}
+
+static struct option opts[] = {
+	{ "queue-num", 1, 0, 'F' },
+	{ 0 }
+};
+
+static void
+parse_num(const char *s, struct xt_NFQ_info *tinfo)
+{
+	unsigned int num;
+       
+	if (string_to_number(s, 0, 65535, &num) == -1)
+		exit_error(PARAMETER_PROBLEM,
+			   "Invalid queue number `%s'\n", s);
+
+    	tinfo->queuenum = num & 0xffff;
+    	return;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      struct xt_entry_target **target)
+{
+	struct xt_NFQ_info *tinfo
+		= (struct xt_NFQ_info *)(*target)->data;
+
+	switch (c) {
+	case 'F':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM, "NFQUEUE target: "
+				   "Only use --queue-num ONCE!");
+		parse_num(optarg, tinfo);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_target *target,
+      int numeric)
+{
+	const struct xt_NFQ_info *tinfo =
+		(const struct xt_NFQ_info *)target->data;
+	printf("NFQUEUE num %u", tinfo->queuenum);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_NFQ_info *tinfo =
+		(const struct xt_NFQ_info *)target->data;
+
+	printf("--queue-num %u ", tinfo->queuenum);
+}
+
+static struct xtables_target nfqueue = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "NFQUEUE",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_target nfqueue6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "NFQUEUE",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
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
+	xtables_register_target(&nfqueue);
+	xtables_register_target(&nfqueue6);
+}
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
new file mode 100644
index 0000000..9a9af79
--- /dev/null
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -0,0 +1,16 @@
+/* iptables module for using NFQUEUE mechanism
+ *
+ * (C) 2005 Harald Welte <laforge@netfilter.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+*/
+#ifndef _XT_NFQ_TARGET_H
+#define _XT_NFQ_TARGET_H
+
+/* target info */
+struct xt_NFQ_info {
+	u_int16_t queuenum;
+};
+
+#endif /* _XT_NFQ_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_NFQUEUE.h b/include/linux/netfilter_ipv4/ipt_NFQUEUE.h
deleted file mode 100644
index b5b2943..0000000
--- a/include/linux/netfilter_ipv4/ipt_NFQUEUE.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* iptables module for using NFQUEUE mechanism
- *
- * (C) 2005 Harald Welte <laforge@netfilter.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
-*/
-#ifndef _IPT_NFQ_TARGET_H
-#define _IPT_NFQ_TARGET_H
-
-/* target info */
-struct ipt_NFQ_info {
-	u_int16_t queuenum;
-};
-
-#endif /* _IPT_DSCP_TARGET_H */
-- 
1.5.2.2
