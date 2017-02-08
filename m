From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Wed,  8 Feb 2017 23:14:29 +0100
Message-ID: <20170208221429.3555-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36642 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751449AbdBHWOL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 17:14:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The comment is incorrect, this function does see fragments when
IP_NODEFRAG is used.  Remove the wrong assertion.

As conntrack doesn't track fragments skb->nfct will be null
and no nat is performed.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index f8aad03d674b..6f5e8d01b876 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -255,11 +255,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 	/* maniptype == SRC for postrouting. */
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
 
-	/* We never see fragments: conntrack defrags on pre-routing
-	 * and local-out, and nf_nat_out protects post-routing.
-	 */
-	NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));
-
 	ct = nf_ct_get(skb, &ctinfo);
 	/* Can't track?  It's not due to stress, or conntrack would
 	 * have dropped it.  Hence it's the user's responsibilty to
-- 
2.10.2

