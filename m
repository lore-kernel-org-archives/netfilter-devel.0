From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_ct: include direction when dumping NFT_CT_L3PROTOCOL key
Date: Fri, 18 Dec 2015 14:32:07 +0100
Message-ID: <1450445527-13225-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39411 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbbLRNgD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 08:36:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

one nft userspace test case fails with

'ct l3proto original ipv4' mismatches 'ct l3proto ipv4'

... because NFTA_CT_DIRECTION attr is missing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8cbca34..9399215 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -366,6 +366,7 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 
 	switch (priv->key) {
+	case NFT_CT_L3PROTOCOL:
 	case NFT_CT_PROTOCOL:
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-- 
2.4.10

