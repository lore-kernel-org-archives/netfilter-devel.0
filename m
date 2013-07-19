From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  13/15] nft: Remove useless function
Date: Fri, 19 Jul 2013 18:17:42 +0300
Message-ID: <1374247064-3361-14-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760172Ab3GSPSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:16 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4476fcd..009c3b3 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1677,33 +1677,6 @@ next:
 	return 0;
 }
 
-static inline int
-match_different(const struct xt_entry_match *a,
-		const unsigned char *a_elems,
-		const unsigned char *b_elems,
-		unsigned char **maskptr)
-{
-	const struct xt_entry_match *b;
-	unsigned int i;
-
-	/* Offset of b is the same as a. */
-	b = (void *)b_elems + ((unsigned char *)a - a_elems);
-
-	if (a->u.match_size != b->u.match_size)
-		return 1;
-
-	if (strcmp(a->u.user.name, b->u.user.name) != 0)
-		return 1;
-
-	*maskptr += XT_ALIGN(sizeof(*a));
-
-	for (i = 0; i < a->u.match_size - XT_ALIGN(sizeof(*a)); i++)
-		if (((a->data[i] ^ b->data[i]) & (*maskptr)[i]) != 0)
-			return 1;
-	*maskptr += i;
-	return 0;
-}
-
 static int nft_parse_counters(struct nft_trans_rule_context *rule_ctx,
 			      struct nft_trans_instruction_context *first,
 			      struct nft_trans_instruction_context *useless,
-- 
1.8.3.2

