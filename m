From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 40/43] Add IPv6 support to comment match
Date: Sun, 15 Jul 2007 03:13:17 +0900 (JST)
Message-ID: <200707141813.l6EIDI6S009790@toshiba.co.jp>
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
 extensions/libipt_comment.c                |  119 ------------------------
 extensions/libxt_comment.c                 |  136 ++++++++++++++++++++++++++++
 include/linux/netfilter/xt_comment.h       |   10 ++
 include/linux/netfilter_ipv4/ipt_comment.h |   10 --
 5 files changed, 148 insertions(+), 131 deletions(-)
 delete mode 100644 extensions/libipt_comment.c
 create mode 100644 extensions/libxt_comment.c
 create mode 100644 include/linux/netfilter/xt_comment.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_comment.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 1a757e7..0a46256 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libipt_comment.c b/extensions/libipt_comment.c
deleted file mode 100644
index ba0e92f..0000000
--- a/extensions/libipt_comment.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/* Shared library add-on to iptables to add comment match support.
- *
- * ChangeLog
- *     2003-05-13: Brad Fisher <brad@info-link.net>
- *         Initial comment match
- *     2004-05-12: Brad Fisher <brad@info-link.net>
- *         Port to patch-o-matic-ng
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_comment.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-		"COMMENT match options:\n"
-		"--comment COMMENT             Attach a comment to a rule\n\n"
-		);
-}
-
-static struct option opts[] = {
-	{ "comment", 1, 0, '1' },
-	{0}
-};
-
-static void
-parse_comment(const char *s, struct ipt_comment_info *info)
-{	
-	int slen = strlen(s);
-
-	if (slen >= IPT_MAX_COMMENT_LEN) {
-		exit_error(PARAMETER_PROBLEM,
-			"COMMENT must be shorter than %i characters", IPT_MAX_COMMENT_LEN);
-	}
-	strcpy((char *)info->comment, s);
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
-	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		if (invert) {
-			exit_error(PARAMETER_PROBLEM,
-					"Sorry, you can't have an inverted comment");
-		}
-		parse_comment(argv[optind-1], commentinfo);
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-/* Final check; must have specified --comment. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "COMMENT match: You must specify `--comment'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)match->data;
-
-	commentinfo->comment[IPT_MAX_COMMENT_LEN-1] = '\0';
-	printf("/* %s */ ", commentinfo->comment);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)match->data;
-
-	commentinfo->comment[IPT_MAX_COMMENT_LEN-1] = '\0';
-	printf("--comment \"%s\" ", commentinfo->comment);
-}
-
-static struct iptables_match comment = {
-    .next 		= NULL,
-    .name 		= "comment",
-    .version 		= IPTABLES_VERSION,
-    .size 		= IPT_ALIGN(sizeof(struct ipt_comment_info)),
-    .userspacesize	= IPT_ALIGN(sizeof(struct ipt_comment_info)),
-    .help		= &help,
-    .parse 		= &parse,
-    .final_check 	= &final_check,
-    .print 		= &print,
-    .save 		= &save,
-    .extra_opts		= opts
-};
-
-void _init(void)
-{
-	register_match(&comment);
-}
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
new file mode 100644
index 0000000..9a0c960
--- /dev/null
+++ b/extensions/libxt_comment.c
@@ -0,0 +1,136 @@
+/* Shared library add-on to iptables to add comment match support.
+ *
+ * ChangeLog
+ *     2003-05-13: Brad Fisher <brad@info-link.net>
+ *         Initial comment match
+ *     2004-05-12: Brad Fisher <brad@info-link.net>
+ *         Port to patch-o-matic-ng
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_comment.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+		"COMMENT match options:\n"
+		"--comment COMMENT             Attach a comment to a rule\n\n"
+		);
+}
+
+static struct option opts[] = {
+	{ "comment", 1, 0, '1' },
+	{0}
+};
+
+static void
+parse_comment(const char *s, struct xt_comment_info *info)
+{	
+	int slen = strlen(s);
+
+	if (slen >= XT_MAX_COMMENT_LEN) {
+		exit_error(PARAMETER_PROBLEM,
+			"COMMENT must be shorter than %i characters", XT_MAX_COMMENT_LEN);
+	}
+	strcpy((char *)info->comment, s);
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
+	struct xt_comment_info *commentinfo = (struct xt_comment_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		if (invert) {
+			exit_error(PARAMETER_PROBLEM,
+					"Sorry, you can't have an inverted comment");
+		}
+		parse_comment(argv[optind-1], commentinfo);
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --comment. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "COMMENT match: You must specify `--comment'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+	printf("/* %s */ ", commentinfo->comment);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+	printf("--comment \"%s\" ", commentinfo->comment);
+}
+
+static struct xtables_match comment = {
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "comment",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print 		= &print,
+	.save 		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match comment6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "comment",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print 		= &print,
+	.save 		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&comment);
+	xtables_register_match(&comment6);
+}
diff --git a/include/linux/netfilter/xt_comment.h b/include/linux/netfilter/xt_comment.h
new file mode 100644
index 0000000..eacfedc
--- /dev/null
+++ b/include/linux/netfilter/xt_comment.h
@@ -0,0 +1,10 @@
+#ifndef _XT_COMMENT_H
+#define _XT_COMMENT_H
+
+#define XT_MAX_COMMENT_LEN 256
+
+struct xt_comment_info {
+	unsigned char comment[XT_MAX_COMMENT_LEN];
+};
+
+#endif /* XT_COMMENT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_comment.h b/include/linux/netfilter_ipv4/ipt_comment.h
deleted file mode 100644
index 85c1123..0000000
--- a/include/linux/netfilter_ipv4/ipt_comment.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _IPT_COMMENT_H
-#define _IPT_COMMENT_H
-
-#define IPT_MAX_COMMENT_LEN 256
-
-struct ipt_comment_info {
-	unsigned char comment[IPT_MAX_COMMENT_LEN];
-};
-
-#endif /* _IPT_COMMENT_H */
-- 
1.5.2.2
