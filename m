From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] iptables: Add APPROVE target
Date: Thu, 20 Jan 2011 23:47:08 +0100
Message-ID: <1295563629-14996-5-git-send-email-richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
 <1295563629-14996-2-git-send-email-richard@nod.at>
 <1295563629-14996-3-git-send-email-richard@nod.at>
 <1295563629-14996-4-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39948 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1ATWra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:30 -0500
In-Reply-To: <1295563629-14996-4-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Richard Weinberger <richard@nod.at>
---
 extensions/libxt_APPROVE.c           |   83 ++++++++++++++++++++++++++++++++++
 extensions/libxt_APPROVE.man         |    1 +
 include/linux/netfilter/xt_APPROVE.h |    8 +++
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_APPROVE.c
 create mode 100644 extensions/libxt_APPROVE.man
 create mode 100644 include/linux/netfilter/xt_APPROVE.h

diff --git a/extensions/libxt_APPROVE.c b/extensions/libxt_APPROVE.c
new file mode 100644
index 0000000..4142bfa
--- /dev/null
+++ b/extensions/libxt_APPROVE.c
@@ -0,0 +1,83 @@
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <stddef.h>
+
+#include <xtables.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_APPROVE.h>
+
+static const struct option approve_opts[] = {
+	{.name = "rule-id", .has_arg = true, .val = 'i'},
+	XT_GETOPT_TABLEEND
+};
+
+static void approve_help(void)
+{
+	printf("APPROVE target options:\n"
+		"--rule-id id		assign numberic id to the rule.\n");
+}
+
+static int approve_parse(int c, char **argv, int invert, unsigned int *flags,
+	const void *entry, struct xt_entry_target **target)
+{
+	struct nf_approve_info *ridi = (void *)(*target)->data;
+
+	if(c == 'i') {
+		xtables_param_act(XTF_NO_INVERT, "APPROVE", "--rule-id", invert);
+		ridi->ruleid = strtoul(optarg, NULL, 0);
+
+		if(ridi->ruleid < 1)
+			xtables_error(PARAMETER_PROBLEM,
+				"--rule-id must be greater than 0");
+
+		*flags = 1;
+
+		return true;
+	}
+
+	return false;
+}
+
+static void approve_print(const void *ip, const struct xt_entry_target *target,
+	int numeric)
+{
+	struct nf_approve_info *ridi = (void *)target->data;
+
+	printf("--rule-id %i\n", ridi->ruleid);
+}
+
+static void approve_save(const void *ip, const struct xt_entry_target *target)
+{
+	struct nf_approve_info *ridi = (void *)target->data;
+
+	printf("--rule-id %i\n", ridi->ruleid);
+}
+
+static void approve_final_check(unsigned int flags)
+{
+	if(flags != 1)
+		xtables_error(PARAMETER_PROBLEM,
+			"--rule-id must be specified");
+}
+
+static struct xtables_target approve_target = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "APPROVE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct nf_approve_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_approve_info)),
+	.help		= approve_help,
+	.parse		= approve_parse,
+	.final_check	= approve_final_check,
+	.extra_opts	= approve_opts,
+	.print		= approve_print,
+	.save		= approve_save
+};
+
+void _init(void)
+{
+	xtables_register_target(&approve_target);
+}
diff --git a/extensions/libxt_APPROVE.man b/extensions/libxt_APPROVE.man
new file mode 100644
index 0000000..ce08911
--- /dev/null
+++ b/extensions/libxt_APPROVE.man
@@ -0,0 +1 @@
+Richard was too lazy to write a manpage...
diff --git a/include/linux/netfilter/xt_APPROVE.h b/include/linux/netfilter/xt_APPROVE.h
new file mode 100644
index 0000000..c62c6bc
--- /dev/null
+++ b/include/linux/netfilter/xt_APPROVE.h
@@ -0,0 +1,8 @@
+#ifndef _XT_APPROVE_H
+#define _XT_APPROVE_H
+
+struct nf_approve_info {
+	u_int16_t ruleid;
+};
+
+#endif /* _XT_APPROVE_H */
-- 
1.6.6.1

