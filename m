From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH next] extensions: add libxt_skbuff extension
Date: Sun,  9 Dec 2012 14:54:14 -0500
Message-ID: <1355082854-31853-1-git-send-email-willemb@google.com>
Cc: Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40646 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab2LITyW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:54:22 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so130580wey.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Dec 2012 11:54:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support filtering based on sk_buff fields
---
 extensions/libxt_skbuff.c |  157 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_skbuff.c

diff --git a/extensions/libxt_skbuff.c b/extensions/libxt_skbuff.c
new file mode 100644
index 0000000..02dba82
--- /dev/null
+++ b/extensions/libxt_skbuff.c
@@ -0,0 +1,157 @@
+/*
+ * Xtables skb match extension
+ *
+ * Written by Willem de Bruijn (willemb@google.com)
+ * Copyright Google, Inc. 2012
+ * Licensed under the GNU General Public License version 2 (GPLv2)
+*/
+
+#include <linux/netfilter/xt_skbuff.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <xtables.h>
+
+enum {	O_FIELD = 0,
+	O_VAL_EXACT,
+	O_VAL_MIN,
+	O_VAL_MAX,
+	O_VAL_MASK};
+
+const char *skbuff_field_names[] = {
+	"csum", "hatype", "iif", "len", "mark", "pkt_type", "priority",
+	"protocol", "queue_mapping", "rt_classid", "rxhash", "secmark",
+	"uid", "gid", "tstamp", "vlan_tci"};
+
+static void skbuff_help(void)
+{
+	int i, len;
+
+	printf(
+"skbuff match options:\n"
+"[!] --field <name> --val <val> [--mask <val>]\n"
+"[!] --field <name> --min <val> --max <val> [--mask <val>]\n"
+"where name is one of ");
+
+	len = sizeof(skbuff_field_names) / sizeof (void *);
+	for (i = 0; i < len; i++)
+		printf("%s ", skbuff_field_names[i]);
+	printf("\n");
+}
+
+static const struct xt_option_entry skbuff_opts[] = {
+	{.name = "field", .id = O_FIELD, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	{.name = "val", .id = O_VAL_EXACT, .type = XTTYPE_UINT64},
+	{.name = "min", .id = O_VAL_MIN, .type = XTTYPE_UINT64},
+	{.name = "max", .id = O_VAL_MAX, .type = XTTYPE_UINT64},
+	{.name = "mask", .id = O_VAL_MASK, .type = XTTYPE_UINT64},
+	XTOPT_TABLEEND,
+};
+
+static int skbuff_field_name_to_id(const char *name)
+{
+	int i, len = sizeof(skbuff_field_names) / sizeof (void *);
+
+	for (i = 0; i < len; i++)
+		if (!strcmp(skbuff_field_names[i], name))
+			return i;
+
+	xtables_error(PARAMETER_PROBLEM, "skbuff: unknown field\n");
+}
+
+static void skbuff_parse(struct xt_option_call *cb)
+{
+	struct xt_skbuff_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+		case O_FIELD:
+			info->field_id = skbuff_field_name_to_id(cb->arg);
+			if (cb->invert)
+				info->invert = 1;
+			break;
+		case O_VAL_EXACT:
+			info->min = info->max = strtoul(cb->arg, NULL, 0);
+			break;
+		case O_VAL_MIN:
+			info->min = strtoul(cb->arg, NULL, 0);
+			break;
+		case O_VAL_MAX:
+			info->max = strtoul(cb->arg, NULL, 0);
+			break;
+		case O_VAL_MASK:
+			info->mask = strtoul(cb->arg, NULL, 0);
+			break;
+		default:
+			xtables_error(PARAMETER_PROBLEM,
+				      "skbuff: unknown argument");
+			break;
+	}
+}
+
+static void skbuff_check(struct xt_fcheck_call *cb)
+{
+	struct xt_skbuff_info *info = cb->data;
+	unsigned int val_mask, ran_mask, opt_mask;
+
+	if (!info->mask)
+		info->mask = (uint64_t) -1;
+
+	val_mask = 1 << O_VAL_EXACT;
+	ran_mask = (1 << O_VAL_MIN) | (1 << O_VAL_MAX);
+	opt_mask = val_mask | ran_mask;
+
+	if (((cb->xflags & opt_mask) != val_mask) &&
+	    ((cb->xflags & opt_mask) != ran_mask))
+		xtables_error(PARAMETER_PROBLEM,
+			      "skbuff: specify one of --val or --min/--max");
+}
+
+static void skbuff_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_skbuff_info *info = (void *) match->data;
+
+	printf("%s--field %s --min %llu --max %llu --mask 0x%llx",
+	       info->invert ? "! " : "", skbuff_field_names[info->field_id],
+	       (unsigned long long) info->min,
+	       (unsigned long long) info->max,
+	       (unsigned long long) info->mask);
+}
+
+static void skbuff_print(const void *ip, const struct xt_entry_match *match,
+			 int numeric)
+{
+	const struct xt_skbuff_info *info = (void *) match->data;
+
+	printf(" skbuff match ");
+	if (numeric)
+		printf("%hu", info->field_id);
+	else
+		printf("%s", skbuff_field_names[info->field_id]);
+
+	printf("%llu %llu %llx %u",
+	       (unsigned long long) info->min,
+	       (unsigned long long) info->max,
+	       (unsigned long long) info->mask,
+	       info->invert);
+}
+
+static struct xtables_match skbuff_match = {
+	.family         = NFPROTO_UNSPEC,
+	.name           = "skbuff",
+	.version        = XTABLES_VERSION,
+	.size           = XT_ALIGN(sizeof(struct xt_skbuff_info)),
+	.help           = skbuff_help,
+	.print          = skbuff_print,
+	.save           = skbuff_save,
+	.x6_parse       = skbuff_parse,
+	.x6_fcheck	= skbuff_check,
+	.x6_options     = skbuff_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&skbuff_match);
+}
+
-- 
1.7.7.3

