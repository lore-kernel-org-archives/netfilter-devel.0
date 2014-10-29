From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [ebtables-compat PATCH] extensions: libebt_log
Date: Wed, 29 Oct 2014 16:21:54 +0100
Message-ID: <1414596114-11301-1-git-send-email-giuseppelng@gmail.com>
Cc: pablo@netfilter.org, Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47544 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaJ2PWB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:22:01 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3574800wgh.10
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:21:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This implements libebt_log extensions for ebtables-compat layer.
Based on the ebt_log code, but adapted for libxtables parser.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 extensions/libebt_log.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)
 create mode 100644 extensions/libebt_log.c

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
new file mode 100644
index 0000000..416ad85
--- /dev/null
+++ b/extensions/libebt_log.c
@@ -0,0 +1,184 @@
+/*
+ * (C) 2014 Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * Based on code from ebt_log from:
+ *
+ * Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter_bridge/ebt_log.h>
+
+#define LOG_DEFAULT_LEVEL LOG_INFO
+
+typedef struct _code {
+	char *c_name;
+	int c_val;
+} CODE;
+
+static CODE eight_priority[] = {
+	{ "emerg", LOG_EMERG },
+	{ "alert", LOG_ALERT },
+	{ "crit", LOG_CRIT },
+	{ "error", LOG_ERR },
+	{ "warning", LOG_WARNING },
+	{ "notice", LOG_NOTICE },
+	{ "info", LOG_INFO },
+	{ "debug", LOG_DEBUG }
+};
+
+static int name_to_loglevel(const char *arg)
+{
+	int i;
+
+	for (i = 0; i < 8; i++)
+		if (!strcmp(arg, eight_priority[i].c_name))
+			return eight_priority[i].c_val;
+
+	/* return bad loglevel */
+	return 9;
+}
+
+enum {
+	O_LOG_PREFIX = 1,
+	O_LOG_LEVEL,
+	O_LOG_ARP,
+	O_LOG_IP,
+	O_LOG_LOG,
+	O_LOG_IP6,
+};
+
+#define s struct ebt_log_info
+static const struct xt_option_entry LOG_opts[] = {
+	{.name = "log-prefix", .id = O_LOG_PREFIX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, prefix), .min = 1},
+	{.name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, loglevel)},
+	{.name = "log-arp", .id = O_LOG_ARP, .type = XTTYPE_NONE},
+	{.name = "log-ip", .id = O_LOG_IP, .type = XTTYPE_NONE},
+	{.name = "log", .id = O_LOG_LOG, .type = XTTYPE_NONE},
+	{.name = "log-ip6", .id = O_LOG_IP6, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static void LOG_help()
+{
+	int i;
+
+	printf(
+"log options:\n"
+"--log               : use this if you're not specifying anything\n"
+"--log-level level   : level = [1-8] or a string\n"
+"--log-prefix prefix : max. %d chars.\n"
+"--log-ip            : put ip info. in the log for ip packets\n"
+"--log-arp           : put (r)arp info. in the log for (r)arp packets\n"
+"--log-ip6           : put ip6 info. in the log for ip6 packets\n"
+	, EBT_LOG_PREFIX_SIZE - 1);
+	for (i = 0; i < 8; i++)
+		printf("%d = %s\n", eight_priority[i].c_val,
+				    eight_priority[i].c_name);
+}
+
+static void LOG_init(struct xt_entry_target *t)
+{
+	struct ebt_log_info *loginfo = (struct ebt_log_info *)t->data;
+
+	loginfo->bitmask = 0;
+	loginfo->prefix[0] = '\0';
+	loginfo->loglevel = LOG_NOTICE;
+}
+
+static void LOG_print(const struct xt_entry_target *target)
+{
+	const struct ebt_log_info *loginfo
+		= (const struct ebt_log_info *)target->data;
+
+	printf("--log-level %s --log-prefix \"%s\"",
+		eight_priority[loginfo->loglevel].c_name,
+		loginfo->prefix);
+
+	if (loginfo->bitmask & EBT_LOG_IP)
+		printf(" --log-ip");
+	if (loginfo->bitmask & EBT_LOG_ARP)
+		printf(" --log-arp");
+	if (loginfo->bitmask & EBT_LOG_IP6)
+		printf(" --log-ip6");
+	printf(" ");
+}
+
+static void LOG_parse(struct xt_option_call *cb)
+{
+	struct ebt_log_info *loginfo = cb->data;
+	long int i;
+	char *end;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LOG_PREFIX:
+		if (strlen(cb->arg) > sizeof(loginfo->prefix) -1 )
+			xtables_error(PARAMETER_PROBLEM,
+				      "Prefix too long");
+		if (strchr(cb->arg, '\"') != NULL)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Use of \\\" is not allowed" 
+				      " in the prefix");
+		if (strchr(cb->arg, '\n') != NULL)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Newlines not allowed in --log-prefix");
+
+		strcpy((char *)loginfo->prefix, (char *)cb->arg);
+		break;
+	case O_LOG_LEVEL:
+		i = strtol(cb->arg, &end, 16);
+		if (*end != '\0' || i < 0 || i > 7)
+			loginfo->loglevel = name_to_loglevel(cb->arg);
+		else
+			loginfo->loglevel = i;
+
+		if (loginfo->loglevel == 9) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with the log-level");
+		break;
+	case O_LOG_IP:
+		loginfo->bitmask |= EBT_LOG_IP;
+		break;
+	case O_LOG_ARP:
+		loginfo->bitmask |= EBT_LOG_ARP;
+	case O_LOG_LOG:
+		break;
+	case O_LOG_IP6:
+		loginfo->bitmask |= EBT_LOG_IP6;
+		break;
+	default:
+		return;
+	}
+}
+
+static struct xtables_target ebt_log_tg_reg = {
+	.name		= "EBT_LOG",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_log_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_log_info)),
+	.help		= LOG_help,
+	.init		= LOG_init,
+	.print		= LOG_print,
+	.save		= NULL,
+	.x6_parse	= LOG_parse,
+	.x6_options	= LOG_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&ebt_log_tg_reg);
+}
+
-- 
1.9.1

