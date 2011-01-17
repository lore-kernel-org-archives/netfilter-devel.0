From: Thomas Graf <tgraf@infradead.org>
Subject: [PATCH] libxt_AUDIT: add AUDIT target
Date: Mon, 17 Jan 2011 04:19:24 -0500
Message-ID: <20110117091924.GF22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:41173 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1AQJTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:19:24 -0500
Received: from tgr by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat Linux))
	id 1PelFE-0006fq-85
	for netfilter-devel@vger.kernel.org; Mon, 17 Jan 2011 09:19:24 +0000
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libxt module for the AUDIT target.

-j AUDIT --type (accept|reject|drop)

Signed-off-by: Thomas Graf <tgraf@redhat.com>

diff --git a/extensions/libxt_AUDIT.c b/extensions/libxt_AUDIT.c
new file mode 100644
index 0000000..1f2dee4
--- /dev/null
+++ b/extensions/libxt_AUDIT.c
@@ -0,0 +1,123 @@
+/* Shared library add-on to xtables for AUDIT
+ *
+ * (C) 2010-2011, Thomas Graf <tgraf@redhat.com>
+ * (C) 2010-2011, Red Hat, Inc.
+ *
+ * This program is distributed under the terms of GNU GPL v2, 1991
+ */
+
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_AUDIT.h>
+
+static void audit_help(void)
+{
+	printf(
+"AUDIT target options\n"
+"  --type TYPE		Action type to be recorded.\n");
+}
+
+static const struct option audit_opts[] = {
+	{.name = "type", .has_arg = true, .val = 't'},
+	XT_GETOPT_TABLEEND,
+};
+
+static int audit_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
+{
+	struct xt_audit_info *einfo
+		= (struct xt_audit_info *)(*target)->data;
+
+	switch (c) {
+	case 't':
+		if (!strcasecmp(optarg, "accept"))
+			einfo->type = XT_AUDIT_TYPE_ACCEPT;
+		else if (!strcasecmp(optarg, "drop"))
+			einfo->type = XT_AUDIT_TYPE_DROP;
+		else if (!strcasecmp(optarg, "reject"))
+			einfo->type = XT_AUDIT_TYPE_REJECT;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				   "Bad action type value `%s'", optarg);
+
+		if (*flags)
+			xtables_error(PARAMETER_PROBLEM,
+			           "AUDIT: Can't specify --type twice");
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void audit_final_check(unsigned int flags)
+{
+	if (!flags)
+		xtables_error(PARAMETER_PROBLEM,
+		           "AUDIT target: Parameter --type is required");
+}
+
+static void audit_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
+{
+	const struct xt_audit_info *einfo =
+		(const struct xt_audit_info *)target->data;
+
+	printf("AUDIT ");
+
+	switch(einfo->type) {
+	case XT_AUDIT_TYPE_ACCEPT:
+		printf("accept");
+		break;
+	case XT_AUDIT_TYPE_DROP:
+		printf("drop");
+		break;
+	case XT_AUDIT_TYPE_REJECT:
+		printf("reject");
+		break;
+	}
+}
+
+static void audit_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_audit_info *einfo =
+		(const struct xt_audit_info *)target->data;
+
+	switch(einfo->type) {
+	case XT_AUDIT_TYPE_ACCEPT:
+		printf("--type=accept");
+		break;
+	case XT_AUDIT_TYPE_DROP:
+		printf("--type=drop");
+		break;
+	case XT_AUDIT_TYPE_REJECT:
+		printf("--type=reject");
+		break;
+	}
+}
+
+static struct xtables_target audit_tg_reg = {
+	.name		= "AUDIT",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_UNSPEC,
+	.size		= XT_ALIGN(sizeof(struct xt_audit_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_audit_info)),
+	.help		= audit_help,
+	.parse		= audit_parse,
+	.final_check	= audit_final_check,
+	.print		= audit_print,
+	.save		= audit_save,
+	.extra_opts	= audit_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&audit_tg_reg);
+}
diff --git a/include/linux/netfilter/xt_AUDIT.h b/include/linux/netfilter/xt_AUDIT.h
new file mode 100644
index 0000000..38751d2
--- /dev/null
+++ b/include/linux/netfilter/xt_AUDIT.h
@@ -0,0 +1,30 @@
+/*
+ * Header file for iptables xt_AUDIT target
+ *
+ * (C) 2010-2011 Thomas Graf <tgraf@redhat.com>
+ * (C) 2010-2011 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _XT_AUDIT_TARGET_H
+#define _XT_AUDIT_TARGET_H
+
+#include <linux/types.h>
+
+enum {
+	XT_AUDIT_TYPE_ACCEPT = 0,
+	XT_AUDIT_TYPE_DROP,
+	XT_AUDIT_TYPE_REJECT,
+	__XT_AUDIT_TYPE_MAX,
+};
+
+#define XT_AUDIT_TYPE_MAX (__XT_AUDIT_TYPE_MAX - 1)
+
+struct xt_audit_info {
+	__u8 type; /* XT_AUDIT_TYPE_* */
+};
+
+#endif /* _XT_AUDIT_TARGET_H */
