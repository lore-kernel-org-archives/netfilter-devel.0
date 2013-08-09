From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 05/16] nft: Manage xtables target parsing through translation tree
Date: Fri,  9 Aug 2013 16:31:19 +0300
Message-ID: <1376055090-26551-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:46 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This add the support of compatible layer for xtables target extension through
the nft translator. Thus feeding give command structure with the right target.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/Makefile.am  |  1 +
 iptables/nft-shared.c |  3 ++
 iptables/nft-xt-ext.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-xt-ext.h | 12 ++++++++
 4 files changed, 101 insertions(+)
 create mode 100644 iptables/nft-xt-ext.c
 create mode 100644 iptables/nft-xt-ext.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 3a7983c..7ba2990 100644
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
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 614b7ae..b3682c4 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -27,6 +27,7 @@
 
 #include "nft-shared.h"
 #include "xshared.h"
+#include "nft-xt-ext.h"
 
 struct nft_trans_instruction_tree *xt_nft_tree;
 
@@ -754,6 +755,8 @@ int nft_initiate_translation_tree(void)
 	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_1);
 	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_2);
 
+	nft_xt_ext_into_translation_tree(xt_nft_tree);
+
 	return 0;
 }
 
diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
new file mode 100644
index 0000000..70ffe35
--- /dev/null
+++ b/iptables/nft-xt-ext.c
@@ -0,0 +1,85 @@
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
+#include <stdlib.h>
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
-- 
1.8.3.2

