From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 13/15] ipvs: SCTP ports should be writable in ICMP packets
Date: Tue,  2 Jul 2013 16:51:03 +0200
Message-ID: <1372776665-6795-13-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Make sure that SCTP ports are writable when embedded in ICMP
from client, so that ip_vs_nat_icmp can translate them safely.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
Cherry-pick: 06f3d7f973ec04290d86b7dd91b48d38d90433dc

 net/netfilter/ipvs/ip_vs_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 505a09e..3c3a7b4 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1456,7 +1456,8 @@ ignore_ipip:
 
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
-	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol)
+	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol ||
+	    IPPROTO_SCTP == cih->protocol)
 		offset += 2 * sizeof(__u16);
 	verdict = ip_vs_icmp_xmit(skb, cp, pp, offset, hooknum, &ciph);
 
-- 
1.7.10.4
