From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 1/3] nft: Fix a minor compilation warning
Date: Fri,  6 Sep 2013 10:51:48 +0300
Message-ID: <1378453910-17954-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3IFHvz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:51:55 -0400
In-Reply-To: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All verdicts are managed and jumpto has to get a value, but since the
compiler complains let's fix it.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index cdc3f83..5681e26 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -429,7 +429,7 @@ nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
 	struct nft_family_ops *ops;
-	const char *jumpto;
+	const char *jumpto = NULL;
 	bool nft_goto = false;
 
 	/* Standard target? */
-- 
1.8.3.2

