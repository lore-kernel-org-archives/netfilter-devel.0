From: pablo@netfilter.org
Subject: [PATCH 03/14] ipvs: Remove unused parameter from ip_vs_confirm_conntrack()
Date: Tue,  1 Nov 2011 10:11:25 +0100
Message-ID: <1320138696-28048-4-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37239 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1KAJMF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:05 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>

Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |    5 ++---
 net/netfilter/ipvs/ip_vs_nfct.c |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 8fa4430..c4058bd 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1378,7 +1378,7 @@ static inline int ip_vs_conntrack_enabled(struct netns_ipvs *ipvs)
 
 extern void ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp,
 				   int outin);
-extern int ip_vs_confirm_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp);
+extern int ip_vs_confirm_conntrack(struct sk_buff *skb);
 extern void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 				      struct ip_vs_conn *cp, u_int8_t proto,
 				      const __be16 port, int from_rs);
@@ -1396,8 +1396,7 @@ static inline void ip_vs_update_conntrack(struct sk_buff *skb,
 {
 }
 
-static inline int ip_vs_confirm_conntrack(struct sk_buff *skb,
-					  struct ip_vs_conn *cp)
+static inline int ip_vs_confirm_conntrack(struct sk_buff *skb);
 {
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index f454c80..022e77e 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -127,7 +127,7 @@ ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp, int outin)
 	nf_conntrack_alter_reply(ct, &new_tuple);
 }
 
-int ip_vs_confirm_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp)
+int ip_vs_confirm_conntrack(struct sk_buff *skb)
 {
 	return nf_conntrack_confirm(skb);
 }
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ee319a4..aa2d720 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -339,7 +339,7 @@ ip_vs_dst_reset(struct ip_vs_dest *dest)
 								\
 	(skb)->ipvs_property = 1;				\
 	if (unlikely((cp)->flags & IP_VS_CONN_F_NFCT))		\
-		__ret = ip_vs_confirm_conntrack(skb, cp);	\
+		__ret = ip_vs_confirm_conntrack(skb);		\
 	if (__ret == NF_ACCEPT) {				\
 		nf_reset(skb);					\
 		skb_forward_csum(skb);				\
-- 
1.7.2.5

