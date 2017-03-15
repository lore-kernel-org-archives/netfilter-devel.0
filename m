From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/10] netfilter: don't track fragmented packets
Date: Wed, 15 Mar 2017 18:01:03 +0100
Message-ID: <1489597272-30347-2-git-send-email-pablo@netfilter.org>
References: <1489597272-30347-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1489597272-30347-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 4 ++++
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index bc1486f2c064..2e14ed11a35c 100644
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
2.1.4
