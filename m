From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf] netfilter: don't track fragmented packets
Date: Fri,  3 Mar 2017 21:44:00 +0100
Message-ID: <20170303204400.21565-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51930 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752076AbdCCV0d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 16:26:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andrey reports syzkaller splat caused by

NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));

in ipv4 nat.  But this assertion (and the comment) are wrong, this function
does see fragments when IP_NODEFRAG setsockopt is used.

As conntrack doesn't track packets without complete l4 header, only the
first fragment is tracked.

Because applying nat to first packet but not the rest makes no sense this
also turns off tracking of all fragments.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
  - turn off tracking completely

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 4 ++++
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       | 5 -----
 net/netfilter/nf_conntrack_ecache.c            | 2 ++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index fcfd071f4705..ec3e2934dd44 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -165,6 +165,10 @@ static unsigned int ipv4_conntrack_local(void *priv,
 	if (skb->len < sizeof(struct iphdr) ||
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
 		return NF_ACCEPT;
+
+	if (ip_is_fragment(ip_hdr(skb))) /* IP_NODEFRAG setsockopt set */
+		return NF_ACCEPT;
+
 	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
 }
 
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

