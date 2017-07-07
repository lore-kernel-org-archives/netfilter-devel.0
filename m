From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nat: fix src map lookup
Date: Fri,  7 Jul 2017 13:07:17 +0200
Message-ID: <20170707110717.4746-1-fw@strlen.de>
Cc: jaco@uls.co.za, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41028 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdGGLHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 07:07:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When doing initial conversion to rhashtable I replaced the bucket
walk with a single rhashtable_lookup_fast().

When moving to rhlist I failed to properly walk the list of identical
tuples, but that is what is needed for this to work correctly.
The table contains the original tuples, so the reply tuples are all
distinct.

We currently decide that mapping is (not) in range only based on the
first entry, but in case its not we need to try the reply tuple of the
next entry until we either find an in-range mapping or we checked
all the entries.

This bug makes nat core attempt collision resolution while it might be
able to use the mapping as-is.

Fixes: 870190a9ec90 ("netfilter: nat: convert nat bysrc hash to rhashtable")
Reported-by: Jaco Kroon <jaco@uls.co.za>
Tested-by: Jaco Kroon <jaco@uls.co.za>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 832c5a0..eb54178 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -222,20 +222,21 @@ find_appropriate_src(struct net *net,
 		.tuple = tuple,
 		.zone = zone
 	};
-	struct rhlist_head *hl;
+	struct rhlist_head *hl, *h;
 
 	hl = rhltable_lookup(&nf_nat_bysource_table, &key,
 			     nf_nat_bysource_params);
-	if (!hl)
-		return 0;
 
-	ct = container_of(hl, typeof(*ct), nat_bysource);
+	rhl_for_each_entry_rcu(ct, h, hl, nat_bysource) {
+		nf_ct_invert_tuplepr(result,
+				     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		result->dst = tuple->dst;
 
-	nf_ct_invert_tuplepr(result,
-			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-	result->dst = tuple->dst;
+		if (in_range(l3proto, l4proto, result, range))
+			return 1;
+	}
 
-	return in_range(l3proto, l4proto, result, range);
+	return 0;
 }
 
 /* For [FUTURE] fragmentation handling, we want the least-used
-- 
2.9.4

