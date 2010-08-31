From: luciano.coelho@nokia.com
Subject: [PATCH iptables-next 2/2] extensions: add condition target extension.
Date: Tue, 31 Aug 2010 10:28:59 +0300
Message-ID: <1283239739-5739-3-git-send-email-luciano.coelho@nokia.com>
References: <1283239739-5739-1-git-send-email-luciano.coelho@nokia.com>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:45542 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab0HaH21 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:28:27 -0400
In-Reply-To: <1283239739-5739-1-git-send-email-luciano.coelho@nokia.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Add support for condition targets.  The condition targets allow the
condition variables to be changed to the specified value when the target
is hit.  This allows for automatically changing the condition without
intervention from the userspace.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 extensions/libxt_CONDITION.c   |  144 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_CONDITION.man |    9 +++
 2 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_CONDITION.c
 create mode 100644 extensions/libxt_CONDITION.man

diff --git a/extensions/libxt_CONDITION.c b/extensions/libxt_CONDITION.c
new file mode 100644
index 0000000..3c2ead8
--- /dev/null
+++ b/extensions/libxt_CONDITION.c
@@ -0,0 +1,144 @@
+/*
+ * Shared library add-on for iptables to add IDLETIMER support.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <stddef.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_condition.h>
+
+enum {
+	CONDITION_TG_OPT_NAME  = 1 << 0,
+	CONDITION_TG_OPT_VALUE = 1 << 1,
+};
+
+static const struct option condition_tg_opts[] = {
+	{ .name = "name",   .has_arg = true, .val = 'n' },
+	{ .name = "value",  .has_arg = true, .val = 'v' },
+	{ .name = NULL }
+};
+
+static void condition_tg_help(void)
+{
+	printf(
+"CONDITION target options:\n"
+" --name  string		Unique identifier (file name used in procfs)\n"
+" --value uint			Set the condition value\n"
+"\n");
+}
+
+static int condition_tg_parse(int c, char **argv, int invert,
+			      unsigned int *flags,
+			      const void *entry,
+			      struct xt_entry_target **target)
+{
+	struct condition_tginfo *info =
+		(struct condition_tginfo *)(*target)->data;
+	bool ret;
+	unsigned int value;
+
+	switch (c) {
+	case 'v':
+		xtables_param_act(XTF_ONLY_ONCE, "CONDITION", "--value",
+				  *flags & CONDITION_TG_OPT_VALUE);
+
+		*flags |= CONDITION_TG_OPT_VALUE;
+		ret =  xtables_strtoui(optarg, NULL, &value, 0, 1);
+		if (!ret)
+			return false;
+
+		info->value = value;
+		break;
+
+	case 'n':
+		xtables_param_act(XTF_ONLY_ONCE, "CONDITION", "--name",
+				  *flags & CONDITION_TG_OPT_NAME);
+
+		if (strlen(optarg) > XT_CONDITION_MAX_NAME_SIZE)
+			xtables_param_act(XTF_BAD_VALUE, "CONDITION", "--name",
+					 optarg);
+
+		strcpy(info->name, optarg);
+		*flags |= CONDITION_TG_OPT_NAME;
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static void condition_tg_final_check(unsigned int flags)
+{
+	if (!(flags & CONDITION_TG_OPT_NAME))
+		xtables_error(PARAMETER_PROBLEM, "CONDITION target: "
+			      "--name parameter required");
+	if (!(flags & CONDITION_TG_OPT_VALUE))
+		xtables_error(PARAMETER_PROBLEM, "CONDITION target: "
+			      "--value parameter required");
+}
+
+static void condition_tg_print(const void *ip,
+			       const struct xt_entry_target *target,
+			       int numeric)
+{
+	struct condition_tginfo *info =
+		(struct condition_tginfo *) target->data;
+
+	printf("value:%u ", info->value);
+	printf("name:%s ", info->name);
+}
+
+static void condition_tg_save(const void *ip,
+			      const struct xt_entry_target *target)
+{
+	struct condition_tginfo *info =
+		(struct condition_tginfo *) target->data;
+
+	printf("--value %u ", info->value);
+	printf("--name %s ", info->name);
+}
+
+static struct xtables_target condition_tg_reg = {
+	.family	       = NFPROTO_UNSPEC,
+	.name	       = "CONDITION",
+	.version       = XTABLES_VERSION,
+	.revision      = 0,
+	.size	       = XT_ALIGN(sizeof(struct condition_tginfo)),
+	.userspacesize = offsetof(struct condition_tginfo, condvar),
+	.help	       = condition_tg_help,
+	.parse	       = condition_tg_parse,
+	.final_check   = condition_tg_final_check,
+	.print	       = condition_tg_print,
+	.save	       = condition_tg_save,
+	.extra_opts    = condition_tg_opts,
+};
+
+static __attribute__((constructor)) void condition_tg_ldr(void)
+{
+	xtables_register_target(&condition_tg_reg);
+}
diff --git a/extensions/libxt_CONDITION.man b/extensions/libxt_CONDITION.man
new file mode 100644
index 0000000..348814a
--- /dev/null
+++ b/extensions/libxt_CONDITION.man
@@ -0,0 +1,9 @@
+This target allows a condition to be changed to the specified u32
+value when the target is hit.
+.TP
+\fB\-\-value\fP \fIinteger\fP
+The unsigned integer value to set the condition variable to.
+.TP
+\fB\-\-name\fP \fIstring\fP
+This is a unique identifier for the condition.  It is the file name
+that will be used in procfs (max length 27 chars).
-- 
1.7.0.4

