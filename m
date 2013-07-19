From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  06/15] nft: Manage xtables matches through nft translation tree
Date: Fri, 19 Jul 2013 18:17:35 +0300
Message-ID: <1374247064-3361-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759754Ab3GSPSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:04 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-xt-ext.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index ad9a7f7..387d6fa 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -67,6 +67,55 @@ static int nft_parse_xt_target(struct nft_trans_rule_context *rule_ctx,
 	return 0;
 }
 
+static int nft_parse_xt_match(struct nft_trans_rule_context *rule_ctx,
+			      struct nft_trans_instruction_context *first,
+			      struct nft_trans_instruction_context *useless,
+			      nft_trans_parse_callback_f user_cb,
+			      void *user_data)
+{
+	struct nft_to_cs_data *i2cs = user_data;
+	struct xtables_match *match;
+	struct xt_entry_match *m;
+	struct nft_rule_expr *e;
+	const char *match_name;
+	const void *info;
+	size_t length;
+	uint32_t rev;
+
+	e = nft_trans_instruction_context_get_expr(first);
+
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_MT_NAME) ||
+				!nft_rule_expr_is_set(e, NFT_EXPR_MT_REV) ||
+				!nft_rule_expr_is_set(e, NFT_EXPR_MT_INFO))
+		return -1;
+
+	match_name = nft_rule_expr_get_str(e, NFT_EXPR_MT_NAME);
+	if (match_name == NULL)
+		return -1;
+
+	match = xtables_find_match(match_name,
+					XTF_TRY_LOAD, &i2cs->cs->matches);
+	if (match == NULL)
+		return -1;
+
+	info = nft_rule_expr_get(e, NFT_EXPR_TG_INFO, &length);
+
+	m = calloc(1, sizeof(struct xt_entry_match) + length);
+	if (m == NULL)
+		return -1;
+
+	memcpy(&m->data, info, length);
+	m->u.match_size = length + XT_ALIGN(sizeof(struct xt_entry_match));
+
+	rev = nft_rule_expr_get_u32(e, NFT_EXPR_TG_REV);
+	m->u.user.revision = rev;
+	strcpy(m->u.user.name, match->name);
+
+	match->m = m;
+
+	return 0;
+}
+
 static enum nft_instruction nft_ipt_xt_target_instructions[] = {
 	NFT_INSTRUCTION_TARGET,
 	NFT_INSTRUCTION_MAX,
@@ -77,12 +126,23 @@ static struct nft_trans_instruction nft_ipt_xt_target = {
 	.function = nft_parse_xt_target,
 };
 
+static enum nft_instruction nft_ipt_xt_match_instructions[] = {
+	NFT_INSTRUCTION_MATCH,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_xt_match = {
+	.instructions = nft_ipt_xt_match_instructions,
+	.function = nft_parse_xt_match,
+};
+
 int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree)
 {
 	if (tree == NULL)
 		return -1;
 
 	nft_trans_add_instruction(tree, &nft_ipt_xt_target);
+	nft_trans_add_instruction(tree, &nft_ipt_xt_match);
 
 	return 0;
 }
-- 
1.8.3.2

