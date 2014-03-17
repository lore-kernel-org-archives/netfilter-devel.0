From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/38] netfilter: remove double colon
Date: Mon, 17 Mar 2014 13:42:21 +0100
Message-ID: <1395060178-11833-2-git-send-email-pablo@netfilter.org>
References: <1395060178-11833-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1395060178-11833-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: stephen hemminger <stephen@networkplumber.org>

This is C not shell script

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index c3e0ade..7ebd6e3 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -61,7 +61,7 @@ int ip_route_me_harder(struct sk_buff *skb, unsigned int addr_type)
 		skb_dst_set(skb, NULL);
 		dst = xfrm_lookup(net, dst, flowi4_to_flowi(&fl4), skb->sk, 0);
 		if (IS_ERR(dst))
-			return PTR_ERR(dst);;
+			return PTR_ERR(dst);
 		skb_dst_set(skb, dst);
 	}
 #endif
-- 
1.7.10.4
