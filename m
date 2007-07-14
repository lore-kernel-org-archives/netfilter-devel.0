From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 27/43] Use unified API in tcpmss match and add support for
 IPv6 to it
Date: Sun, 15 Jul 2007 03:11:18 +0900 (JST)
Message-ID: <200707141811.l6EIBIOH002754@toshiba.co.jp>
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
 extensions/Makefile                       |    4 +-
 extensions/libipt_tcpmss.c                |  152 --------------------------
 extensions/libxt_tcpmss.c                 |  169 +++++++++++++++++++++++++++++
 include/linux/netfilter/xt_tcpmss.h       |    9 ++
 include/linux/netfilter_ipv4/ipt_tcpmss.h |    9 --
 5 files changed, 180 insertions(+), 163 deletions(-)
 delete mode 100644 extensions/libipt_tcpmss.c
 create mode 100644 extensions/libxt_tcpmss.c
 create mode 100644 include/linux/netfilter/xt_tcpmss.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_tcpmss.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 8bfb40d..b0df81c 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state tcp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport udp NOTRACK
+PFX_EXT_SLIB:=mark multiport tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libipt_tcpmss.c b/extensions/libipt_tcpmss.c
deleted file mode 100644
index e17c020..0000000
--- a/extensions/libipt_tcpmss.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/* Shared library add-on to iptables to add tcp MSS matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_tcpmss.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"tcpmss match v%s options:\n"
-"[!] --mss value[:value]	Match TCP MSS range.\n"
-"				(only valid for TCP SYN or SYN/ACK packets)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "mss", 1, 0, '1' },
-	{0}
-};
-
-static u_int16_t
-parse_tcp_mssvalue(const char *mssvalue)
-{
-	unsigned int mssvaluenum;
-
-	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
-		return (u_int16_t)mssvaluenum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "Invalid mss `%s' specified", mssvalue);
-}
-
-static void
-parse_tcp_mssvalues(const char *mssvaluestring,
-		    u_int16_t *mss_min, u_int16_t *mss_max)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(mssvaluestring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		*mss_min = *mss_max = parse_tcp_mssvalue(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		*mss_min = buffer[0] ? parse_tcp_mssvalue(buffer) : 0;
-		*mss_max = cp[0] ? parse_tcp_mssvalue(cp) : 0xFFFF;
-	}
-	free(buffer);
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
-	struct ipt_tcpmss_match_info *mssinfo =
-		(struct ipt_tcpmss_match_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--mss' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_mssvalues(argv[optind-1],
-				    &mssinfo->mss_min, &mssinfo->mss_max);
-		if (invert)
-			mssinfo->invert = 1;
-		*flags = 1;
-		break;
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, int invert, int numeric)
-{
-	if (invert)
-		printf("! ");
-
-	if (mss_min == mss_max)
-		printf("%u ", mss_min);
-	else
-		printf("%u:%u ", mss_min, mss_max);
-}
-
-/* Final check; must have specified --mss. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "tcpmss match: You must specify `--mss'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	const struct ipt_tcpmss_match_info *mssinfo =
-		(const struct ipt_tcpmss_match_info *)match->data;
-
-	printf("tcpmss match ");
-	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
-		     mssinfo->invert, numeric);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_tcpmss_match_info *mssinfo =
-		(const struct ipt_tcpmss_match_info *)match->data;
-
-	printf("--mss ");
-	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
-		     mssinfo->invert, 0);
-}
-
-static struct iptables_match tcpmss = {
-	.next		= NULL,
-	.name		= "tcpmss",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_tcpmss_match_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tcpmss_match_info)),
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
-	register_match(&tcpmss);
-}
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
new file mode 100644
index 0000000..db3dd90
--- /dev/null
+++ b/extensions/libxt_tcpmss.c
@@ -0,0 +1,169 @@
+/* Shared library add-on to iptables to add tcp MSS matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_tcpmss.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"tcpmss match v%s options:\n"
+"[!] --mss value[:value]	Match TCP MSS range.\n"
+"				(only valid for TCP SYN or SYN/ACK packets)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mss", 1, 0, '1' },
+	{0}
+};
+
+static u_int16_t
+parse_tcp_mssvalue(const char *mssvalue)
+{
+	unsigned int mssvaluenum;
+
+	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
+		return (u_int16_t)mssvaluenum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "Invalid mss `%s' specified", mssvalue);
+}
+
+static void
+parse_tcp_mssvalues(const char *mssvaluestring,
+		    u_int16_t *mss_min, u_int16_t *mss_max)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(mssvaluestring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		*mss_min = *mss_max = parse_tcp_mssvalue(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		*mss_min = buffer[0] ? parse_tcp_mssvalue(buffer) : 0;
+		*mss_max = cp[0] ? parse_tcp_mssvalue(cp) : 0xFFFF;
+	}
+	free(buffer);
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
+	struct xt_tcpmss_match_info *mssinfo =
+		(struct xt_tcpmss_match_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--mss' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_mssvalues(argv[optind-1],
+				    &mssinfo->mss_min, &mssinfo->mss_max);
+		if (invert)
+			mssinfo->invert = 1;
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, int invert, int numeric)
+{
+	if (invert)
+		printf("! ");
+
+	if (mss_min == mss_max)
+		printf("%u ", mss_min);
+	else
+		printf("%u:%u ", mss_min, mss_max);
+}
+
+/* Final check; must have specified --mss. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "tcpmss match: You must specify `--mss'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	const struct xt_tcpmss_match_info *mssinfo =
+		(const struct xt_tcpmss_match_info *)match->data;
+
+	printf("tcpmss match ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, numeric);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_tcpmss_match_info *mssinfo =
+		(const struct xt_tcpmss_match_info *)match->data;
+
+	printf("--mss ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, 0);
+}
+
+static struct xtables_match tcpmss = {
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "tcpmss",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match tcpmss6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "tcpmss",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
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
+	xtables_register_match(&tcpmss);
+	xtables_register_match(&tcpmss6);
+}
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
new file mode 100644
index 0000000..e03274c
--- /dev/null
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -0,0 +1,9 @@
+#ifndef _XT_TCPMSS_MATCH_H
+#define _XT_TCPMSS_MATCH_H
+
+struct xt_tcpmss_match_info {
+    u_int16_t mss_min, mss_max;
+    u_int8_t invert;
+};
+
+#endif /*_XT_TCPMSS_MATCH_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_tcpmss.h b/include/linux/netfilter_ipv4/ipt_tcpmss.h
deleted file mode 100644
index e2b1439..0000000
--- a/include/linux/netfilter_ipv4/ipt_tcpmss.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _IPT_TCPMSS_MATCH_H
-#define _IPT_TCPMSS_MATCH_H
-
-struct ipt_tcpmss_match_info {
-    u_int16_t mss_min, mss_max;
-    u_int8_t invert;
-};
-
-#endif /*_IPT_TCPMSS_MATCH_H*/
-- 
1.5.2.2
