From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/31] netfilter: nf_nat_ipv4: remove obsolete EXPORT_SYMBOL
Date: Tue,  9 Oct 2018 01:01:05 +0200
Message-ID: <20181008230125.2330-12-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There are no external callers anymore, previous change just
forgot to also remove the EXPORT_SYMBOL().

Fixes: 9971a514ed269 ("netfilter: nf_nat: add nat type hooks to nat core")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 6115bf1ff6f0..78a67f961d86 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -264,7 +264,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 
 	return nf_nat_inet_fn(priv, skb, state);
 }
-EXPORT_SYMBOL_GPL(nf_nat_ipv4_fn);
 
 static unsigned int
 nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
-- 
2.11.0
