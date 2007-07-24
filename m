From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 07/13] Unifies libip[6]t_NFLOG into libxt_NFLOG
Date: Tue, 24 Jul 2007 15:58:39 +0900 (JST)
Message-ID: <200707240658.l6O6weTr012543@toshiba.co.jp>
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


 extensions/.NFLOG-test6                      |    2 -
 extensions/{.NFLOG-test => .NFLOG-testx}     |    0 
 extensions/libip6t_NFLOG.c                   |  161 --------------------------
 extensions/{libipt_NFLOG.c => libxt_NFLOG.c} |   25 ++++-
 4 files changed, 21 insertions(+), 167 deletions(-)
 delete mode 100755 extensions/.NFLOG-test6
 rename extensions/{.NFLOG-test => .NFLOG-testx} (100%)
 delete mode 100644 extensions/libip6t_NFLOG.c
 rename extensions/{libipt_NFLOG.c => libxt_NFLOG.c} (88%)

diff --git a/extensions/.NFLOG-test6 b/extensions/.NFLOG-test6
deleted file mode 100755
index 25f0dee..0000000
--- a/extensions/.NFLOG-test6
+++ /dev/null
@@ -1,2 +0,0 @@
-#! /bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter/xt_NFLOG.h ] && echo NFLOG
diff --git a/extensions/.NFLOG-test b/extensions/.NFLOG-testx
similarity index 100%
rename from extensions/.NFLOG-test
rename to extensions/.NFLOG-testx
diff --git a/extensions/libip6t_NFLOG.c b/extensions/libip6t_NFLOG.c
deleted file mode 100644
index 9f4ebaa..0000000
--- a/extensions/libip6t_NFLOG.c
+++ /dev/null
@@ -1,161 +0,0 @@
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <getopt.h>
-#include <ip6tables.h>
-
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/xt_NFLOG.h>
-
-enum {
-	NFLOG_GROUP	= 0x1,
-	NFLOG_PREFIX	= 0x2,
-	NFLOG_RANGE	= 0x4,
-	NFLOG_THRESHOLD	= 0x8,
-};
-
-static struct option opts[] = {
-	{ "nflog-group",     1, 0, NFLOG_GROUP },
-	{ "nflog-prefix",    1, 0, NFLOG_PREFIX },
-	{ "nflog-range",     1, 0, NFLOG_RANGE },
-	{ "nflog-threshold", 1, 0, NFLOG_THRESHOLD },
-};
-
-static void help(void)
-{
-	printf("NFLOG v%s options:\n"
-	       " --nflog-group NUM		NETLINK group used for logging\n"
-	       " --nflog-range NUM		Number of byte to copy\n"
-	       " --nflog-threshold NUM		Message threshold of in-kernel queue\n"
-	       " --nflog-prefix STRING		Prefix string for log messages\n\n",
-	       IPTABLES_VERSION);
-}
-
-static void init(struct ip6t_entry_target *t, unsigned int *nfcache)
-{
-	struct xt_nflog_info *info = (struct xt_nflog_info *)t->data;
-
-	info->group	= 0;
-	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
-}
-
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry,
-		 struct xt_entry_target **target)
-{
-	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
-	int n;
-
-	switch (c) {
-	case NFLOG_GROUP:
-		if (*flags & NFLOG_GROUP)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-group twice");
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --nflog-group");
-
-		n = atoi(optarg);
-		if (n < 0)
-			exit_error(PARAMETER_PROBLEM,
-				   "--nflog-group can not be negative");
-		info->group = n;
-		break;
-	case NFLOG_PREFIX:
-		if (*flags & NFLOG_PREFIX)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-prefix twice");
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --nflog-prefix");
-
-		n = strlen(optarg);
-		if (n == 0)
-			exit_error(PARAMETER_PROBLEM,
-				   "No prefix specified for --nflog-prefix");
-		if (n >= sizeof(info->prefix))
-			exit_error(PARAMETER_PROBLEM,
-				   "--nflog-prefix too long, max %Zu characters",
-				   sizeof(info->prefix) - 1);
-		if (n != strlen(strtok(optarg, "\n")))
-			exit_error(PARAMETER_PROBLEM,
-				   "Newlines are not allowed in --nflog-prefix");
-		strcpy(info->prefix, optarg);
-		break;
-	case NFLOG_RANGE:
-		if (*flags & NFLOG_RANGE)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-range twice");
-		n = atoi(optarg);
-		if (n < 0)
-			exit_error(PARAMETER_PROBLEM,
-				   "Invalid --nflog-range, must be >= 0");
-		info->len = n;
-		break;
-	case NFLOG_THRESHOLD:
-		if (*flags & NFLOG_THRESHOLD)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-threshold twice");
-		n = atoi(optarg);
-		if (n < 1)
-			exit_error(PARAMETER_PROBLEM,
-				   "Invalid --nflog-threshold, must be >= 1");
-		info->threshold = n;
-		break;
-	default:
-		return 0;
-	}
-	*flags |= c;
-	return 1;
-}
-
-static void final_check(unsigned int flags)
-{
-	return;
-}
-
-static void nflog_print(const struct xt_nflog_info *info, char *prefix)
-{
-	if (info->prefix[0] != '\0')
-		printf("%snflog-prefix \"%s\" ", prefix, info->prefix);
-	if (info->group)
-		printf("%snflog-group %u ", prefix, info->group);
-	if (info->len)
-		printf("%snflog-range %u ", prefix, info->len);
-	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
-		printf("%snflog-threshold %u ", prefix, info->threshold);
-}
-
-static void print(const void *ip, const struct xt_entry_target *target,
-		  int numeric)
-{
-	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
-
-	nflog_print(info, "");
-}
-
-static void save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
-
-	nflog_print(info, "--");
-}
-
-static struct ip6tables_target nflog = {
-	.name		= "NFLOG",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
-	.help		= help,
-	.init		= init,
-	.parse		= parse,
-	.final_check	= final_check,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_target6(&nflog);
-}
diff --git a/extensions/libipt_NFLOG.c b/extensions/libxt_NFLOG.c
similarity index 88%
rename from extensions/libipt_NFLOG.c
rename to extensions/libxt_NFLOG.c
index b43a8b8..a67d013 100644
--- a/extensions/libipt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -2,9 +2,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
 
 enum {
@@ -141,7 +141,23 @@ static void save(const void *ip, const struct xt_entry_target *target)
 	nflog_print(info, "--");
 }
 
-static struct iptables_target nflog = {
+static struct xtables_target nflog = {
+	.family		= AF_INET,
+	.name		= "NFLOG",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts,
+};
+
+static struct xtables_target nflog6 = {
+	.family		= AF_INET6,
 	.name		= "NFLOG",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
@@ -157,5 +173,6 @@ static struct iptables_target nflog = {
 
 void _init(void)
 {
-	register_target(&nflog);
+	xtables_register_target(&nflog);
+	xtables_register_target(&nflog6);
 }
-- 
1.5.2.2
