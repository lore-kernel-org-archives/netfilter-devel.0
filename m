From: luciano.coelho@nokia.com
Subject: [PATCH iptables-next 1/2] extensions: add condition match extension
Date: Tue, 31 Aug 2010 10:28:58 +0300
Message-ID: <1283239739-5739-2-git-send-email-luciano.coelho@nokia.com>
References: <1283239739-5739-1-git-send-email-luciano.coelho@nokia.com>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:33541 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0HaH2Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:28:25 -0400
In-Reply-To: <1283239739-5739-1-git-send-email-luciano.coelho@nokia.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

This match extension was taken from xtables-addons and it has been
modified to implement the change from boolean conditions to u32 values.
It is possible to match when the condition is equal to the value passed
or when it is not equal to the value passed (by using the invert
option).

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 extensions/libxt_condition.c   |  128 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_condition.man |   10 +++
 2 files changed, 138 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_condition.c
 create mode 100644 extensions/libxt_condition.man

diff --git a/extensions/libxt_condition.c b/extensions/libxt_condition.c
new file mode 100644
index 0000000..6132083
--- /dev/null
+++ b/extensions/libxt_condition.c
@@ -0,0 +1,128 @@
+/*
+ *	"condition" match extension for iptables
+ *	Stephane Ouellette <ouellettes [at] videotron ca>, 2002-10-22
+ *	Massimiliano Hofer <max [at] nucleus it>, 2006-05-15
+ *	Jan Engelhardt <jengelh [at] medozas de>, 2008
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License; either version 2
+ *	or 3 of the License, as published by the Free Software Foundation.
+ */
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_condition.h>
+
+enum {
+	CONDITION_MT_OPT_NAME  = 1 << 0,
+	CONDITION_MT_OPT_VALUE = 1 << 1,
+};
+
+static void condition_help(void)
+{
+	printf(
+"condition match options:\n"
+"    --name string	Unique identifier (file name used in procfs)\n"
+"[!] --value uint	Value to match\n"
+);
+}
+
+static const struct option condition_opts[] = {
+	{.name = "name",  .has_arg = true, .val = 'n'},
+	{.name = "value", .has_arg = true, .val = 'v'},
+	{NULL},
+};
+
+static int condition_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_match **match)
+{
+	struct xt_condition_mtinfo *info = (void *)(*match)->data;
+
+	switch (c) {
+	case 'n':
+		xtables_param_act(XTF_ONLY_ONCE, "condition", "--name",
+				  *flags & CONDITION_MT_OPT_NAME);
+
+		if (strlen(optarg) < sizeof(info->name))
+			strcpy(info->name, optarg);
+		else
+			xtables_param_act(XTF_BAD_VALUE, "condition", "--name",
+					  optarg);
+
+		xtables_param_act(XTF_NO_INVERT, "condition", "--name", invert);
+
+		*flags |= CONDITION_MT_OPT_NAME;
+
+		break;
+
+	case 'v':
+		xtables_param_act(XTF_ONLY_ONCE, "condition", "--value",
+				  *flags & CONDITION_MT_OPT_VALUE);
+		if (!xtables_strtoui(optarg, NULL, &info->value, 0, UINT32_MAX))
+			xtables_param_act(XTF_BAD_VALUE, "condition",
+					  "--value", optarg);
+
+		info->invert = invert;
+
+		*flags |= CONDITION_MT_OPT_VALUE;
+
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static void condition_check(unsigned int flags)
+{
+	if (!(flags & CONDITION_MT_OPT_NAME))
+		xtables_error(PARAMETER_PROBLEM, "condition match: "
+			      "--name parameter required");
+	if (!(flags & CONDITION_MT_OPT_VALUE))
+		xtables_error(PARAMETER_PROBLEM, "condition match: "
+			      "--value parameter required");
+}
+
+static void condition_print(const void *ip, const struct xt_entry_match *match,
+                            int numeric)
+{
+	const struct xt_condition_mtinfo *info = (const void *)match->data;
+
+	printf("condition %s %s %u ", info->name, (info->invert) ? "!=" : "==",
+	       info->value);
+}
+
+
+static void condition_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_condition_mtinfo *info = (const void *)match->data;
+
+	printf("%s--name \"%s\" --value %u ", info->invert ? "! " : "",
+	       info->name, info->value);
+}
+
+static struct xtables_match condition_mt_reg = {
+	.name 		= "condition",
+	.revision	= 2,
+	.family		= NFPROTO_UNSPEC,
+	.version 	= XTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_condition_mtinfo)),
+	.userspacesize 	= XT_ALIGN(sizeof(struct xt_condition_mtinfo)),
+	.help 		= condition_help,
+	.parse 		= condition_parse,
+	.final_check	= condition_check,
+	.print 		= condition_print,
+	.save 		= condition_save,
+	.extra_opts 	= condition_opts,
+};
+
+static __attribute__((constructor)) void condition_mt_ldr(void)
+{
+	xtables_register_match(&condition_mt_reg);
+}
diff --git a/extensions/libxt_condition.man b/extensions/libxt_condition.man
new file mode 100644
index 0000000..63d7e7e
--- /dev/null
+++ b/extensions/libxt_condition.man
@@ -0,0 +1,10 @@
+Match if the condition variable is equal to the value specified.  If
+the inverse flag is used, match if the variable is not equal to the
+value.
+.TP
+[\fB!\fP] \fB\-\-value\fP \fIinteger\fP
+The unsigned integer value to be used in the comparison.
+.TP
+\fB\-\-name\fP \fIstring\fP
+This is a unique identifier for the condition.  It is the file name
+that will be used in procfs (max length 27 chars).
-- 
1.7.0.4

