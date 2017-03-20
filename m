From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/22] netfilter: nf_reject: remove unused variable
Date: Mon, 20 Mar 2017 11:08:37 +0100
Message-ID: <1490004530-9128-10-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

variable oiph is not used.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 146d86105183..7cd8d0d918f8 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -104,7 +104,6 @@ EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
-	const struct iphdr *oiph;
 	struct iphdr *niph;
 	const struct tcphdr *oth;
 	struct tcphdr _oth;
@@ -116,8 +115,6 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
-	oiph = ip_hdr(oldskb);
-
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
 			 LL_MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
-- 
2.1.4
