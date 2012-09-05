From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: fix out-of-bounds access in nat addr selection
Date: Wed,  5 Sep 2012 22:10:28 +0200
Message-ID: <1346875828-14054-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56034 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab2IEUMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:12:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

include/linux/jhash.h:138:16: warning: array subscript is above array bounds
[jhash2() expects the number of u32 in the key]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
Only affects -next.
note that I also get same warning for hash_by_src(); but
hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
	      tuple->dst.protonum ^ zone ^ nf_conntrack_hash_rnd);
looks correct to me.

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 29d4452..1816ad3 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -255,7 +255,7 @@ find_best_ips_proto(u16 zone, struct nf_conntrack_tuple *tuple,
 	 * client coming from the same IP (some Internet Banking sites
 	 * like this), even across reboots.
 	 */
-	j = jhash2((u32 *)&tuple->src.u3, sizeof(tuple->src.u3),
+	j = jhash2((u32 *)&tuple->src.u3, sizeof(tuple->src.u3) / sizeof(u32),
 		   range->flags & NF_NAT_RANGE_PERSISTENT ?
 			0 : (__force u32)tuple->dst.u3.all[max] ^ zone);
 
-- 
1.7.8.6

