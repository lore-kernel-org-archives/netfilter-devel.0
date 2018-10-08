From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/31] netfilter: nat: remove duplicate skb_is_nonlinear() in __nf_nat_mangle_tcp_packet()
Date: Tue,  9 Oct 2018 01:01:16 +0200
Message-ID: <20181008230125.2330-23-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

__nf_nat_mangle_tcp_packet() and nf_nat_mangle_udp_packet() call
mangle_contents(). and __nf_nat_mangle_tcp_packet()
and mangle_contents() call skb_is_nonlinear(). so that
skb_is_nonlinear() in __nf_nat_mangle_tcp_packet() is unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_helper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 99606baedda4..38793b95d9bc 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -37,7 +37,7 @@ static void mangle_contents(struct sk_buff *skb,
 {
 	unsigned char *data;
 
-	BUG_ON(skb_is_nonlinear(skb));
+	SKB_LINEAR_ASSERT(skb);
 	data = skb_network_header(skb) + dataoff;
 
 	/* move post-replacement */
@@ -110,8 +110,6 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 	    !enlarge_skb(skb, rep_len - match_len))
 		return false;
 
-	SKB_LINEAR_ASSERT(skb);
-
 	tcph = (void *)skb->data + protoff;
 
 	oldlen = skb->len - protoff;
-- 
2.11.0
