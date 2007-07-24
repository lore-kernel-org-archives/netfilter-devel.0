From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 11/13] Add IPv6 support to connbytes match
Date: Tue, 24 Jul 2007 15:59:05 +0900 (JST)
Message-ID: <200707240659.l6O6x5xc005446@toshiba.co.jp>
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


 extensions/.connbytes-test             |    2 -
 extensions/.connbytes-testx            |    3 +
 extensions/libipt_connbytes.c          |   65 ++++++----
 extensions/libxt_connbytes.c           |  222 ++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_connbytes.h |   25 ++++
 5 files changed, 291 insertions(+), 26 deletions(-)
 delete mode 100755 extensions/.connbytes-test
 create mode 100755 extensions/.connbytes-testx
 create mode 100644 extensions/libxt_connbytes.c
 create mode 100644 include/linux/netfilter/xt_connbytes.h

diff --git a/extensions/.connbytes-test b/extensions/.connbytes-test
deleted file mode 100755
index 61355d0..0000000
--- a/extensions/.connbytes-test
+++ /dev/null
@@ -1,2 +0,0 @@
-#! /bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_connbytes.h ] && echo connbytes
diff --git a/extensions/.connbytes-testx b/extensions/.connbytes-testx
new file mode 100755
index 0000000..1b16712
--- /dev/null
+++ b/extensions/.connbytes-testx
@@ -0,0 +1,3 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_connbytes.h ] ||	\
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_connbytes.h ] && echo connbytes
diff --git a/extensions/libipt_connbytes.c b/extensions/libipt_connbytes.c
index 69b39bd..ec602f0 100644
--- a/extensions/libipt_connbytes.c
+++ b/extensions/libipt_connbytes.c
@@ -4,9 +4,9 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
-#include <linux/netfilter_ipv4/ipt_connbytes.h>
+#include <linux/netfilter/xt_connbytes.h>
 
 /* Function which prints out usage message. */
 static void
@@ -28,7 +28,7 @@ static struct option opts[] = {
 };
 
 static void
-parse_range(const char *arg, struct ipt_connbytes_info *si)
+parse_range(const char *arg, struct xt_connbytes_info *si)
 {
 	char *colon,*p;
 
@@ -53,7 +53,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)(*match)->data;
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
 	unsigned long i;
 
 	switch (c) {
@@ -71,11 +71,11 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (!strcmp(optarg, "original"))
-			sinfo->direction = IPT_CONNBYTES_DIR_ORIGINAL;
+			sinfo->direction = XT_CONNBYTES_DIR_ORIGINAL;
 		else if (!strcmp(optarg, "reply"))
-			sinfo->direction = IPT_CONNBYTES_DIR_REPLY;
+			sinfo->direction = XT_CONNBYTES_DIR_REPLY;
 		else if (!strcmp(optarg, "both"))
-			sinfo->direction = IPT_CONNBYTES_DIR_BOTH;
+			sinfo->direction = XT_CONNBYTES_DIR_BOTH;
 		else
 			exit_error(PARAMETER_PROBLEM,
 				   "Unknown --connbytes-dir `%s'", optarg);
@@ -84,11 +84,11 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (!strcmp(optarg, "packets"))
-			sinfo->what = IPT_CONNBYTES_PKTS;
+			sinfo->what = XT_CONNBYTES_PKTS;
 		else if (!strcmp(optarg, "bytes"))
-			sinfo->what = IPT_CONNBYTES_BYTES;
+			sinfo->what = XT_CONNBYTES_BYTES;
 		else if (!strcmp(optarg, "avgpkt"))
-			sinfo->what = IPT_CONNBYTES_AVGPKT;
+			sinfo->what = XT_CONNBYTES_AVGPKT;
 		else
 			exit_error(PARAMETER_PROBLEM,
 				   "Unknown --connbytes-mode `%s'", optarg);
@@ -108,16 +108,16 @@ static void final_check(unsigned int flags)
 			   "`--connbytes-dir' and `--connbytes-mode'");
 }
 
-static void print_mode(struct ipt_connbytes_info *sinfo)
+static void print_mode(struct xt_connbytes_info *sinfo)
 {
 	switch (sinfo->what) {
-		case IPT_CONNBYTES_PKTS:
+		case XT_CONNBYTES_PKTS:
 			fputs("packets ", stdout);
 			break;
-		case IPT_CONNBYTES_BYTES:
+		case XT_CONNBYTES_BYTES:
 			fputs("bytes ", stdout);
 			break;
-		case IPT_CONNBYTES_AVGPKT:
+		case XT_CONNBYTES_AVGPKT:
 			fputs("avgpkt ", stdout);
 			break;
 		default:
@@ -126,16 +126,16 @@ static void print_mode(struct ipt_connbytes_info *sinfo)
 	}
 }
 
-static void print_direction(struct ipt_connbytes_info *sinfo)
+static void print_direction(struct xt_connbytes_info *sinfo)
 {
 	switch (sinfo->direction) {
-		case IPT_CONNBYTES_DIR_ORIGINAL:
+		case XT_CONNBYTES_DIR_ORIGINAL:
 			fputs("original ", stdout);
 			break;
-		case IPT_CONNBYTES_DIR_REPLY:
+		case XT_CONNBYTES_DIR_REPLY:
 			fputs("reply ", stdout);
 			break;
-		case IPT_CONNBYTES_DIR_BOTH:
+		case XT_CONNBYTES_DIR_BOTH:
 			fputs("both ", stdout);
 			break;
 		default:
@@ -150,7 +150,7 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
 
 	if (sinfo->count.from > sinfo->count.to) 
 		printf("connbytes ! %llu:%llu ", sinfo->count.to,
@@ -169,7 +169,7 @@ print(const void *ip,
 /* Saves the matchinfo in parsable form to stdout. */
 static void save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
 
 	if (sinfo->count.from > sinfo->count.to) 
 		printf("! --connbytes %llu:%llu ", sinfo->count.to,
@@ -185,12 +185,28 @@ static void save(const void *ip, const struct xt_entry_match *match)
 	print_direction(sinfo);
 }
 
-static struct iptables_match state = {
+static struct xtables_match state = {
 	.next 		= NULL,
+	.family		= AF_INET,
 	.name 		= "connbytes",
 	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
+	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save 		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match state6 = {
+	.next 		= NULL,
+	.family		= AF_INET6,
+	.name 		= "connbytes",
+	.version 	= IPTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.help		= &help,
 	.parse		= &parse,
 	.final_check	= &final_check,
@@ -201,5 +217,6 @@ static struct iptables_match state = {
 
 void _init(void)
 {
-	register_match(&state);
+	xtables_register_match(&state);
+	xtables_register_match(&state6);
 }
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
new file mode 100644
index 0000000..ec602f0
--- /dev/null
+++ b/extensions/libxt_connbytes.c
@@ -0,0 +1,222 @@
+/* Shared library add-on to iptables to add byte tracking support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/xt_connbytes.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"connbytes v%s options:\n"
+" [!] --connbytes from:[to]\n"
+"     --connbytes-dir [original, reply, both]\n"
+"     --connbytes-mode [packets, bytes, avgpkt]\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "connbytes", 1, 0, '1' },
+	{ "connbytes-dir", 1, 0, '2' },
+	{ "connbytes-mode", 1, 0, '3' },
+	{0}
+};
+
+static void
+parse_range(const char *arg, struct xt_connbytes_info *si)
+{
+	char *colon,*p;
+
+	si->count.from = strtoul(arg,&colon,10);
+	if (*colon != ':') 
+		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+	si->count.to = strtoul(colon+1,&p,10);
+	if (p == colon+1) {
+		/* second number omited */
+		si->count.to = 0xffffffff;
+	}
+	if (si->count.from > si->count.to)
+		exit_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
+			   si->count.from, si->count.to);
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
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
+	unsigned long i;
+
+	switch (c) {
+	case '1':
+		if (check_inverse(optarg, &invert, &optind, 0))
+			optind++;
+
+		parse_range(argv[optind-1], sinfo);
+		if (invert) {
+			i = sinfo->count.from;
+			sinfo->count.from = sinfo->count.to;
+			sinfo->count.to = i;
+		}
+		*flags |= 1;
+		break;
+	case '2':
+		if (!strcmp(optarg, "original"))
+			sinfo->direction = XT_CONNBYTES_DIR_ORIGINAL;
+		else if (!strcmp(optarg, "reply"))
+			sinfo->direction = XT_CONNBYTES_DIR_REPLY;
+		else if (!strcmp(optarg, "both"))
+			sinfo->direction = XT_CONNBYTES_DIR_BOTH;
+		else
+			exit_error(PARAMETER_PROBLEM,
+				   "Unknown --connbytes-dir `%s'", optarg);
+
+		*flags |= 2;
+		break;
+	case '3':
+		if (!strcmp(optarg, "packets"))
+			sinfo->what = XT_CONNBYTES_PKTS;
+		else if (!strcmp(optarg, "bytes"))
+			sinfo->what = XT_CONNBYTES_BYTES;
+		else if (!strcmp(optarg, "avgpkt"))
+			sinfo->what = XT_CONNBYTES_AVGPKT;
+		else
+			exit_error(PARAMETER_PROBLEM,
+				   "Unknown --connbytes-mode `%s'", optarg);
+		*flags |= 4;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (flags != 7)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes'"
+			   "`--connbytes-dir' and `--connbytes-mode'");
+}
+
+static void print_mode(struct xt_connbytes_info *sinfo)
+{
+	switch (sinfo->what) {
+		case XT_CONNBYTES_PKTS:
+			fputs("packets ", stdout);
+			break;
+		case XT_CONNBYTES_BYTES:
+			fputs("bytes ", stdout);
+			break;
+		case XT_CONNBYTES_AVGPKT:
+			fputs("avgpkt ", stdout);
+			break;
+		default:
+			fputs("unknown ", stdout);
+			break;
+	}
+}
+
+static void print_direction(struct xt_connbytes_info *sinfo)
+{
+	switch (sinfo->direction) {
+		case XT_CONNBYTES_DIR_ORIGINAL:
+			fputs("original ", stdout);
+			break;
+		case XT_CONNBYTES_DIR_REPLY:
+			fputs("reply ", stdout);
+			break;
+		case XT_CONNBYTES_DIR_BOTH:
+			fputs("both ", stdout);
+			break;
+		default:
+			fputs("unknown ", stdout);
+			break;
+	}
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
+
+	if (sinfo->count.from > sinfo->count.to) 
+		printf("connbytes ! %llu:%llu ", sinfo->count.to,
+			sinfo->count.from);
+	else
+		printf("connbytes %llu:%llu ",sinfo->count.from,
+			sinfo->count.to);
+
+	fputs("connbytes mode ", stdout);
+	print_mode(sinfo);
+
+	fputs("connbytes direction ", stdout);
+	print_direction(sinfo);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
+
+	if (sinfo->count.from > sinfo->count.to) 
+		printf("! --connbytes %llu:%llu ", sinfo->count.to,
+			sinfo->count.from);
+	else
+		printf("--connbytes %llu:%llu ", sinfo->count.from,
+			sinfo->count.to);
+
+	fputs("--connbytes-mode ", stdout);
+	print_mode(sinfo);
+
+	fputs("--connbytes-dir ", stdout);
+	print_direction(sinfo);
+}
+
+static struct xtables_match state = {
+	.next 		= NULL,
+	.family		= AF_INET,
+	.name 		= "connbytes",
+	.version 	= IPTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save 		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match state6 = {
+	.next 		= NULL,
+	.family		= AF_INET6,
+	.name 		= "connbytes",
+	.version 	= IPTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save 		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&state);
+	xtables_register_match(&state6);
+}
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
new file mode 100644
index 0000000..c022c98
--- /dev/null
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -0,0 +1,25 @@
+#ifndef _XT_CONNBYTES_H
+#define _XT_CONNBYTES_H
+
+enum xt_connbytes_what {
+	XT_CONNBYTES_PKTS,
+	XT_CONNBYTES_BYTES,
+	XT_CONNBYTES_AVGPKT,
+};
+
+enum xt_connbytes_direction {
+	XT_CONNBYTES_DIR_ORIGINAL,
+	XT_CONNBYTES_DIR_REPLY,
+	XT_CONNBYTES_DIR_BOTH,
+};
+
+struct xt_connbytes_info
+{
+	struct {
+		aligned_u64 from;	/* count to be matched */
+		aligned_u64 to;		/* count to be matched */
+	} count;
+	u_int8_t what;		/* ipt_connbytes_what */
+	u_int8_t direction;	/* ipt_connbytes_direction */
+};
+#endif
-- 
1.5.2.2
