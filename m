From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] nft: Calculate properly the target size when parsing it back
Date: Thu,  3 Oct 2013 16:00:59 +0300
Message-ID: <1380805259-12404-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5195 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab3JCNBH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:01:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this, we might allocate less space for the xt_entry_target as we
should, thus leading to a possible bug.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c9bde90..25cb177 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -292,18 +292,21 @@ void nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	struct xtables_target *target;
 	struct xt_entry_target *t;
 	struct nft_family_ops *ops;
+	size_t size;
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
 	if (target == NULL)
 		return;
 
-	t = calloc(1, sizeof(struct xt_entry_target) + tg_len);
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
+
+	t = calloc(1, size);
 	if (t == NULL) {
 		fprintf(stderr, "OOM");
 		exit(EXIT_FAILURE);
 	}
 	memcpy(&t->data, targinfo, tg_len);
-	t->u.target_size = tg_len + XT_ALIGN(sizeof(struct xt_entry_target));
+	t->u.target_size = size;
 	t->u.user.revision = nft_rule_expr_get_u32(e, NFT_EXPR_TG_REV);
 	strcpy(t->u.user.name, target->name);
 
-- 
1.8.3.2

