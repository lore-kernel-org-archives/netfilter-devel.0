From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_dup: do not use sreg_dev if the user doesn't specify it
Date: Sat, 29 Oct 2016 22:09:51 +0800
Message-ID: <1477750191-14902-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:47163 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034206AbcJ2OKg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 10:10:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

The NFTA_DUP_SREG_DEV attribute is not a must option, so we should use it
in routing lookup only when the user specify it.

Fixes: d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/ipv4/netfilter/nft_dup_ipv4.c | 6 ++++--
 net/ipv6/netfilter/nft_dup_ipv6.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index bf855e6..0c01a270 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -28,7 +28,7 @@ static void nft_dup_ipv4_eval(const struct nft_expr *expr,
 	struct in_addr gw = {
 		.s_addr = (__force __be32)regs->data[priv->sreg_addr],
 	};
-	int oif = regs->data[priv->sreg_dev];
+	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
 
 	nf_dup_ipv4(pkt->net, pkt->skb, pkt->hook, &gw, oif);
 }
@@ -59,7 +59,9 @@ static int nft_dup_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
 
-	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr) ||
+	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr))
+		goto nla_put_failure;
+	if (priv->sreg_dev &&
 	    nft_dump_register(skb, NFTA_DUP_SREG_DEV, priv->sreg_dev))
 		goto nla_put_failure;
 
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 8bfd470..831f86e 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -26,7 +26,7 @@ static void nft_dup_ipv6_eval(const struct nft_expr *expr,
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 	struct in6_addr *gw = (struct in6_addr *)&regs->data[priv->sreg_addr];
-	int oif = regs->data[priv->sreg_dev];
+	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
 
 	nf_dup_ipv6(pkt->net, pkt->skb, pkt->hook, gw, oif);
 }
@@ -57,7 +57,9 @@ static int nft_dup_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 
-	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr) ||
+	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr))
+		goto nla_put_failure;
+	if (priv->sreg_dev &&
 	    nft_dump_register(skb, NFTA_DUP_SREG_DEV, priv->sreg_dev))
 		goto nla_put_failure;
 
-- 
2.5.5


