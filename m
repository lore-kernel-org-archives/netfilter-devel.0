From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] ebtables-compat: support nflog extension
Date: Tue, 03 Mar 2015 19:48:13 +0100
Message-ID: <20150303184813.2846.22439.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37339 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755044AbbCCSsY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 13:48:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's give support for the nflog extension (a watcher).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_nflog.c |  144 +++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-bridge.c     |    3 +
 iptables/xtables-eb.c     |    1 
 3 files changed, 147 insertions(+), 1 deletion(-)
 create mode 100644 extensions/libebt_nflog.c

diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
new file mode 100644
index 0000000..72bf372
--- /dev/null
+++ b/extensions/libebt_nflog.c
@@ -0,0 +1,144 @@
+/* ebt_nflog
+ *
+ * Authors:
+ * Peter Warasin <peter@endian.com>
+ *
+ *  February, 2008
+ *
+ * Based on:
+ *  ebt_ulog.c, (C) 2004, Bart De Schuymer <bdschuym@pandora.be>
+ *  libxt_NFLOG.c
+ *
+ * Adapted to libxtables for ebtables-compat in 2015 by
+ * Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+#include "iptables/nft.h"
+#include "iptables/nft-bridge.h"
+#include <linux/netfilter_bridge/ebt_nflog.h>
+
+enum {
+	NFLOG_GROUP	= 0x1,
+	NFLOG_PREFIX	= 0x2,
+	NFLOG_RANGE	= 0x4,
+	NFLOG_THRESHOLD	= 0x8,
+	NFLOG_NFLOG	= 0x16,
+};
+
+static struct option brnflog_opts[] = {
+	{ .name = "nflog-group",     .has_arg = true,  .val = NFLOG_GROUP},
+	{ .name = "nflog-prefix",    .has_arg = true,  .val = NFLOG_PREFIX},
+	{ .name = "nflog-range",     .has_arg = true,  .val = NFLOG_RANGE},
+	{ .name = "nflog-threshold", .has_arg = true,  .val = NFLOG_THRESHOLD},
+	{ .name = "nflog",           .has_arg = false, .val = NFLOG_NFLOG},
+	XT_GETOPT_TABLEEND,
+};
+
+static void brnflog_help(void)
+{
+	printf("nflog options:\n"
+	       "--nflog               : use the default nflog parameters\n"
+	       "--nflog-prefix prefix : Prefix string for log message\n"
+	       "--nflog-group group   : NETLINK group used for logging\n"
+	       "--nflog-range range   : Number of byte to copy\n"
+	       "--nflog-threshold     : Message threshold of"
+	       "in-kernel queue\n");
+}
+
+static void brnflog_init(struct xt_entry_target *t)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)t->data;
+
+	info->prefix[0]	= '\0';
+	info->group	= EBT_NFLOG_DEFAULT_GROUP;
+	info->threshold = EBT_NFLOG_DEFAULT_THRESHOLD;
+}
+
+static int brnflog_parse(int c, char **argv, int invert, unsigned int *flags,
+			 const void *entry, struct xt_entry_target **target)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)(*target)->data;
+	unsigned int i;
+
+	if (invert)
+		xtables_error(PARAMETER_PROBLEM,
+			      "The use of '!' makes no sense for the"
+			      " nflog watcher");
+
+	switch (c) {
+	case NFLOG_PREFIX:
+		EBT_CHECK_OPTION(flags, NFLOG_PREFIX);
+		if (strlen(optarg) > EBT_NFLOG_PREFIX_SIZE - 1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Prefix too long for nflog-prefix");
+		strncpy(info->prefix, optarg, EBT_NFLOG_PREFIX_SIZE);
+		break;
+	case NFLOG_GROUP:
+		EBT_CHECK_OPTION(flags, NFLOG_GROUP);
+		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
+			xtables_error(PARAMETER_PROBLEM,
+				      "--nflog-group must be a number!");
+		info->group = i;
+		break;
+	case NFLOG_RANGE:
+		EBT_CHECK_OPTION(flags, NFLOG_RANGE);
+		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
+			xtables_error(PARAMETER_PROBLEM,
+				      "--nflog-range must be a number!");
+		info->len = i;
+		break;
+	case NFLOG_THRESHOLD:
+		EBT_CHECK_OPTION(flags, NFLOG_THRESHOLD);
+		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
+			xtables_error(PARAMETER_PROBLEM,
+				      "--nflog-threshold must be a number!");
+		info->threshold = i;
+		break;
+	case NFLOG_NFLOG:
+		EBT_CHECK_OPTION(flags, NFLOG_NFLOG);
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+brnflog_print(const void *ip, const struct xt_entry_target *target,
+	      int numeric)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)target->data;
+
+	if (info->prefix[0] != '\0')
+		printf("--nflog-prefix \"%s\" ", info->prefix);
+	if (info->group)
+		printf("--nflog-group %d ", info->group);
+	if (info->len)
+		printf("--nflog-range %d ", info->len);
+	if (info->threshold != EBT_NFLOG_DEFAULT_THRESHOLD)
+		printf("--nflog-threshold %d ", info->threshold);
+}
+
+static struct xtables_target brnflog_watcher = {
+	.name		= "nflog",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_nflog_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_nflog_info)),
+	.init		= brnflog_init,
+	.help		= brnflog_help,
+	.parse		= brnflog_parse,
+	.print		= brnflog_print,
+	.extra_opts	= brnflog_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&brnflog_watcher);
+}
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index e3ab667..49e70d5 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -349,7 +349,8 @@ static void nft_bridge_parse_target(struct xtables_target *t, void *data)
 	struct ebtables_command_state *cs = data;
 
 	/* harcoded names :-( */
-	if (strcmp(t->name, "log") == 0) {
+	if (strcmp(t->name, "log") == 0
+	    || strcmp(t->name, "nflog") == 0) {
 		parse_watcher(t, &cs->match_list, false);
 		return;
 	}
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index efbb3cd..e0e521a 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -645,6 +645,7 @@ static void ebt_load_match_extensions(void)
 	ebt_load_match("mark_m");
 
 	ebt_load_watcher("log");
+	ebt_load_watcher("nflog");
 }
 
 static void ebt_add_match(struct xtables_match *m,

