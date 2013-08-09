From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 06/16] nft: Manage xtables matches through nft translation tree
Date: Fri,  9 Aug 2013 16:31:20 +0300
Message-ID: <1376055090-26551-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINbr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:47 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This add the support of compatible layer for xtables matches extension through
the nft translator. Thus feeding give command structure with the right matches.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-xt-ext.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index 70ffe35..f013493 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -64,6 +64,55 @@ static int nft_parse_xt_target(struct nft_trans_rule_context *rule_ctx,
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
@@ -74,12 +123,23 @@ static struct nft_trans_instruction nft_ipt_xt_target = {
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

