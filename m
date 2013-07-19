From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  05/15] nft: Manage xtables target parsing through translation tree
Date: Fri, 19 Jul 2013 18:17:34 +0300
Message-ID: <1374247064-3361-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab3GSPSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:04 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/Makefile.am  |  1 +
 iptables/nft-xt-ext.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-xt-ext.h | 12 +++++++
 iptables/nft.c        |  3 ++
 4 files changed, 104 insertions(+)
 create mode 100644 iptables/nft-xt-ext.c
 create mode 100644 iptables/nft-xt-ext.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 2b6a037..8bc38ca 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -31,6 +31,7 @@ xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c \
+			 nft-xt-ext.c \
 			 xtables-config.c xtables-events.c
 xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS} ../libnfttrans/libnfttrans.la
 xtables_multi_CFLAGS  += -DENABLE_NFTABLES
diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
new file mode 100644
index 0000000..ad9a7f7
--- /dev/null
+++ b/iptables/nft-xt-ext.c
@@ -0,0 +1,88 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <string.h>
+
+#include <xtables.h>
+
+#include <nft-xt-ext.h>
+#include <nft-shared.h>
+
+static int nft_parse_xt_target(struct nft_trans_rule_context *rule_ctx,
+			       struct nft_trans_instruction_context *first,
+			       struct nft_trans_instruction_context *useless,
+			       nft_trans_parse_callback_f user_cb,
+			       void *user_data)
+{
+	struct nft_to_cs_data *i2cs = user_data;
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+	struct nft_rule_expr *e;
+	const char *target_name;
+	const void *info;
+	size_t length;
+	uint32_t rev;
+
+	e = nft_trans_instruction_context_get_expr(first);
+
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_TG_NAME) ||
+				!nft_rule_expr_is_set(e, NFT_EXPR_TG_REV) ||
+				!nft_rule_expr_is_set(e, NFT_EXPR_TG_INFO))
+		return -1;
+
+	target_name = nft_rule_expr_get_str(e, NFT_EXPR_TG_NAME);
+	if (target_name == NULL)
+		return -1;
+
+	target = xtables_find_target(target_name, XTF_TRY_LOAD);
+	if (target == NULL)
+		return -1;
+
+	info = nft_rule_expr_get(e, NFT_EXPR_TG_INFO, &length);
+
+	t = calloc(1, sizeof(struct xt_entry_target) + length);
+	if (t == NULL)
+		return -1;
+
+	memcpy(&t->data, info, length);
+	t->u.target_size = length + XT_ALIGN(sizeof(struct xt_entry_target));
+
+	rev = nft_rule_expr_get_u32(e, NFT_EXPR_TG_REV);
+	t->u.user.revision = rev;
+	strcpy(t->u.user.name, target->name);
+
+	target->t = t;
+	i2cs->cs->target = target;
+
+	/* There cannot be more than 1 target */
+	nft_trans_rulecontext_inhibate_instruction(rule_ctx,
+							nft_parse_xt_target);
+
+	return 0;
+}
+
+static enum nft_instruction nft_ipt_xt_target_instructions[] = {
+	NFT_INSTRUCTION_TARGET,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_xt_target = {
+	.instructions = nft_ipt_xt_target_instructions,
+	.function = nft_parse_xt_target,
+};
+
+int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree)
+{
+	if (tree == NULL)
+		return -1;
+
+	nft_trans_add_instruction(tree, &nft_ipt_xt_target);
+
+	return 0;
+}
diff --git a/iptables/nft-xt-ext.h b/iptables/nft-xt-ext.h
new file mode 100644
index 0000000..a367277
--- /dev/null
+++ b/iptables/nft-xt-ext.h
@@ -0,0 +1,12 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <nft-translator.h>
+
+int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree);
diff --git a/iptables/nft.c b/iptables/nft.c
index 155a9d3..2f00486 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -51,6 +51,7 @@
 #include "xshared.h" /* proto_to_name */
 #include "nft-shared.h"
 #include "xtables-config-parser.h"
+#include "nft-xt-ext.h"
 
 static void initiate_nft_translation_tree(void);
 
@@ -2881,6 +2882,8 @@ static void initiate_nft_translation_tree(void)
 	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_io_ifs);
 	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_1);
 	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_2);
+
+	nft_xt_ext_into_translation_tree(xt_nft_tree);
 }
 
 int nft_xtables_config_load(struct nft_handle *h, const char *filename,
-- 
1.8.3.2

