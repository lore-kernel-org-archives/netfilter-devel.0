From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: conntrack: make netns address part of nat bysrc hash
Date: Mon,  9 May 2016 16:24:30 +0200
Message-ID: <1462803872-13497-2-git-send-email-fw@strlen.de>
References: <1462803872-13497-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33840 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbcEIOYT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 10:24:19 -0400
In-Reply-To: <1462803872-13497-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Will be needed soon when we place all in the same hash table.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d74e716..069912c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(nf_xfrm_me_harder);
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static inline unsigned int
-hash_by_src(const struct net *net, const struct nf_conntrack_tuple *tuple)
+hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 
@@ -126,9 +126,9 @@ hash_by_src(const struct net *net, const struct nf_conntrack_tuple *tuple)
 
 	/* Original src, to ensure we map it consistently if poss. */
 	hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
-		      tuple->dst.protonum ^ nf_nat_hash_rnd);
+		      tuple->dst.protonum ^ nf_nat_hash_rnd ^ net_hash_mix(n));
 
-	return reciprocal_scale(hash, net->ct.nat_htable_size);
+	return reciprocal_scale(hash, n->ct.nat_htable_size);
 }
 
 /* Is this tuple already taken? (not by us) */
-- 
2.7.3

