From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/14] netfilter: ipv6: fix oops when defragmenting locally generated fragments
Date: Tue,  6 Nov 2018 00:28:19 +0100
Message-ID: <20181105232832.21896-2-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Unlike ipv4 and normal ipv6 defrag, netfilter ipv6 defragmentation did
not save/restore skb->dst.

This causes oops when handling locally generated ipv6 fragments, as
output path needs a valid dst.

Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Fixes: 84379c9afe01 ("netfilter: ipv6: nf_defrag: drop skb dst before queueing")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index b8ac369f98ad..d219979c3e52 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -587,11 +587,16 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	 */
 	ret = -EINPROGRESS;
 	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    fq->q.meat == fq->q.len &&
-	    nf_ct_frag6_reasm(fq, skb, dev))
-		ret = 0;
-	else
+	    fq->q.meat == fq->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		if (nf_ct_frag6_reasm(fq, skb, dev))
+			ret = 0;
+		skb->_skb_refdst = orefdst;
+	} else {
 		skb_dst_drop(skb);
+	}
 
 out_unlock:
 	spin_unlock_bh(&fq->q.lock);
-- 
2.11.0
