From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 10/16] nft: Register all relevant xtables extensions into translation tree
Date: Fri,  9 Aug 2013 16:31:24 +0300
Message-ID: <1376055090-26551-11-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:54 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On the contrary of legacy code or current compatible xtables layer in nftables,
pure nft expression list, representing an extension, won't provide any extension
name.

What use to be one target expressions with a name and a data like for instance:
target(foo,<memory blob>)
will become:
imm bitwise cmp payload imm cmp

Thus, it's necessary to know the expression patterns, before hand to be able to
match the right extension.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h     |  2 ++
 iptables/nft-xt-ext.c | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index 03139a0..0a07f22 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -422,6 +422,8 @@ extern "C" {
 #endif
 
 extern const char *xtables_modprobe_program;
+extern struct xtables_match *xtables_pending_matches;
+extern struct xtables_target *xtables_pending_targets;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
 
diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index 660e417..b2b29a7 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -135,12 +135,25 @@ static struct nft_trans_instruction nft_ipt_xt_match = {
 
 int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree)
 {
+	struct xtables_target *t;
+	struct xtables_match *m;
+
 	if (tree == NULL)
 		return -1;
 
 	nft_trans_add_instruction(tree, &nft_ipt_xt_target);
 	nft_trans_add_instruction(tree, &nft_ipt_xt_match);
 
+	for (t = xtables_pending_targets; t; t = t->next) {
+		if (t->register_nft_instructions != NULL)
+			t->register_nft_instructions(tree);
+	}
+
+	for (m = xtables_pending_matches; m; m = m->next) {
+		if (m->register_nft_instructions != NULL)
+			m->register_nft_instructions(tree);
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2

