From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: nft: fix endianness in dump function
Date: Thu, 12 Dec 2013 08:51:59 +0100
Message-ID: <1386834719-29204-2-git-send-email-eric@regit.org>
References: <1386834719-29204-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56360 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LLHwW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:52:22 -0500
In-Reply-To: <1386834719-29204-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dump function in nft_reject_ipv4 was not converting a u32
field to network order before sending it to userspace.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/ipv4/netfilter/nft_reject_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index fff5ba1..4a5e94a 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -72,7 +72,7 @@ static int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_reject *priv = nft_expr_priv(expr);
 
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, priv->type))
+	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
 		goto nla_put_failure;
 
 	switch (priv->type) {
-- 
1.8.5.1

