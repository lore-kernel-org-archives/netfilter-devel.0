From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_nat: don't bug when mapping already exists
Date: Thu, 31 Aug 2017 13:45:24 +0200
Message-ID: <20170831114524.7511-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751586AbdHaLpG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2017 07:45:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems preferrable to limp along if we have a conflicting mapping,
its certainly better than a BUG().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
This can be triggered with nfqueue and bridge netfilter.
So far we found no good way to fix this problem (bridge netfilter
violates conntrack assumption wrt. ownership of ct by single cpu).

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b1d3740ae36a..c1587e8427ef 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -416,7 +416,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 
 	NF_CT_ASSERT(maniptype == NF_NAT_MANIP_SRC ||
 		     maniptype == NF_NAT_MANIP_DST);
-	BUG_ON(nf_nat_initialized(ct, maniptype));
+	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
+		return NF_DROP;
 
 	/* What we've got will look like inverse of reply. Normally
 	 * this is what is in the conntrack, except for prior
-- 
2.13.0

