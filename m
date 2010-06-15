From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2] extensions: add idletimer xt target extension
Date: Tue, 15 Jun 2010 12:48:40 +0300
Message-ID: <1276595320-10007-1-git-send-email-luciano.coelho@nokia.com>
Cc: kaber@trash.net, jengelh@medozas.de,
	Jukka Rissanen <jukka.rissanen@nokia.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58353 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0FOJs4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:48:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the extension plugin for the IDLETIMER x_tables target.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
v2: Use only 28 bytes for the label, as per change done to the kernel patch

 extensions/libxt_IDLETIMER.c           |  141 ++++++++++++++++++++++++++++++++
 extensions/libxt_IDLETIMER.man         |   19 ++++
 include/linux/netfilter/xt_IDLETIMER.h |   45 ++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_IDLETIMER.c
 create mode 100644 extensions/libxt_IDLETIMER.man
 create mode 100644 include/linux/netfilter/xt_IDLETIMER.h

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
new file mode 100644
index 0000000..565f8e3
--- /dev/null
+++ b/extensions/libxt_IDLETIMER.c
@@ -0,0 +1,141 @@
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
+#include <linux/netfilter/xt_IDLETIMER.h>
+
+enum {
+	IDLETIMER_TG_OPT_TIMEOUT = 1 << 0,
+	IDLETIMER_TG_OPT_LABEL	 = 1 << 1,
+};
+
+static const struct option idletimer_tg_opts[] = {
+	{ .name = "timeout", .has_arg = true, .flag = 0, .val = 't' },
+	{ .name = "label",   .has_arg = true, .flag = 0, .val = 'l' },
+	{ .name = NULL }
+};
+
+static void idletimer_tg_help(void)
+{
+	printf(
+"IDLETIMER target options:\n"
+" --timeout time	Timeout until the notification is sent (in seconds)\n"
+" --label string	Unique rule identifier\n"
+"\n");
+}
+
+static int idletimer_tg_parse(int c, char **argv, int invert,
+			      unsigned int *flags,
+			      const void *entry,
+			      struct xt_entry_target **target)
+{
+	struct idletimer_tg_info *info =
+		(struct idletimer_tg_info *)(*target)->data;
+
+	switch (c) {
+	case 't':
+		if (*flags & IDLETIMER_TG_OPT_TIMEOUT)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Cannot specify timeout more than once");
+
+		info->timeout = atoi(optarg);
+		*flags |= IDLETIMER_TG_OPT_TIMEOUT;
+		break;
+
+	case 'l':
+		if (*flags & IDLETIMER_TG_OPT_LABEL)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Cannot specify label more than once");
+
+		if (strlen(optarg) > MAX_IDLETIMER_LABEL_SIZE - 1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Maximum label length is %u for --label",
+				      MAX_IDLETIMER_LABEL_SIZE - 1);
+
+		strcpy(info->label, optarg);
+		*flags |= IDLETIMER_TG_OPT_LABEL;
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static void idletimer_tg_final_check(unsigned int flags)
+{
+	if (!(flags & IDLETIMER_TG_OPT_TIMEOUT))
+		xtables_error(PARAMETER_PROBLEM, "IDLETIMER target: "
+			      "--timeout parameter required");
+	if (!(flags & IDLETIMER_TG_OPT_LABEL))
+		xtables_error(PARAMETER_PROBLEM, "IDLETIMER target: "
+			      "--label parameter required");
+}
+
+static void idletimer_tg_print(const void *ip,
+			       const struct xt_entry_target *target,
+			       int numeric)
+{
+	struct idletimer_tg_info *info =
+		(struct idletimer_tg_info *) target->data;
+
+	printf("timeout:%u ", info->timeout);
+	printf("label:%s ", info->label);
+}
+
+static void idletimer_tg_save(const void *ip,
+			      const struct xt_entry_target *target)
+{
+	struct idletimer_tg_info *info =
+		(struct idletimer_tg_info *) target->data;
+
+	printf("--timeout %u ", info->timeout);
+	printf("--label %s ", info->label);
+}
+
+static struct xtables_target idletimer_tg_reg = {
+	.family	       = NFPROTO_UNSPEC,
+	.name	       = "IDLETIMER",
+	.version       = XTABLES_VERSION,
+	.revision      = 0,
+	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
+	.userspacesize = offsetof(struct idletimer_tg_info, timer),
+	.help	       = idletimer_tg_help,
+	.parse	       = idletimer_tg_parse,
+	.final_check   = idletimer_tg_final_check,
+	.print	       = idletimer_tg_print,
+	.save	       = idletimer_tg_save,
+	.extra_opts    = idletimer_tg_opts,
+};
+
+static __attribute__((constructor)) void idletimer_tg_ldr(void)
+{
+	xtables_register_target(&idletimer_tg_reg);
+}
diff --git a/extensions/libxt_IDLETIMER.man b/extensions/libxt_IDLETIMER.man
new file mode 100644
index 0000000..3266a44
--- /dev/null
+++ b/extensions/libxt_IDLETIMER.man
@@ -0,0 +1,19 @@
+This target can be used to identify when interfaces have been idle for a
+certain period of time.  Timers are identified by labels and are created when
+a rule is set with a new label.  The rules also take a timeout value (in
+seconds) as an option.  If more than one rule uses the same timer label, the
+timer will be restarted whenever any of the rules get a hit.  One entry for
+each timer is created in sysfs.  This attribute contains the timer remaining
+for the timer to expire.  The attributes are located under the xt_idletimer
+class:
+.PP
+/sys/class/xt_idletimer/timers/<label>
+.PP
+When the timer expires, the target module sends a sysfs notification to the
+userspace, which can then decide what to do (eg. disconnect to save power).
+.TP
+\fB\-\-timeout\fP \fIamount\fP
+This is the time in seconds that will trigger the notification.
+.TP
+\fB\-\-label\fP \fIstring\fP
+This is a unique identifier for the timer.
diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
new file mode 100644
index 0000000..3e1aa1b
--- /dev/null
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -0,0 +1,45 @@
+/*
+ * linux/include/linux/netfilter/xt_IDLETIMER.h
+ *
+ * Header file for Xtables timer target module.
+ *
+ * Copyright (C) 2004, 2010 Nokia Corporation
+ * Written by Timo Teras <ext-timo.teras@nokia.com>
+ *
+ * Converted to x_tables and forward-ported to 2.6.34
+ * by Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef _XT_IDLETIMER_H
+#define _XT_IDLETIMER_H
+
+#include <linux/types.h>
+
+#define MAX_IDLETIMER_LABEL_SIZE 28
+
+struct idletimer_tg_info {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute((aligned(8)));
+};
+
+#endif
-- 
1.6.3.3

