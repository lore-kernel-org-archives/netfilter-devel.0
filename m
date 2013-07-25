From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  01/17] nft: Remove useless function
Date: Thu, 25 Jul 2013 20:16:21 +0300
Message-ID: <1374772597-20548-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab3GYRQn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:43 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 9a857b9..a943069 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1676,33 +1676,6 @@ next:
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
 static void
 nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	       int family, struct iptables_command_state *cs)
-- 
1.8.3.2

