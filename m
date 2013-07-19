From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  10/15] nft: Register all relevant xtables extensions into translation tree
Date: Fri, 19 Jul 2013 18:17:39 +0300
Message-ID: <1374247064-3361-11-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44027 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759754Ab3GSPSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:12 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h.in  |  3 +++
 iptables/nft-xt-ext.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 592aae9..0f02470 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -403,6 +403,9 @@ extern "C" {
 #endif
 
 extern const char *xtables_modprobe_program;
+
+extern struct xtables_match *xtables_pending_matches;
+extern struct xtables_target *xtables_pending_targets;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
 
diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index ffc53f0..2ce8b70 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -138,12 +138,25 @@ static struct nft_trans_instruction nft_ipt_xt_match = {
 
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

