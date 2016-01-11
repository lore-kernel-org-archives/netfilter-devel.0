From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] nftables: byteorder: avoid uneeded le/be conversion steps
Date: Mon, 11 Jan 2016 22:49:32 +0100
Message-ID: <1452548972-24454-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55081 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932851AbcAKVuR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 16:50:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David points out that we to three le/be conversions instead
of just one.  Doesn't matter on x86_64 w. gcc, but other
architectures might be less lucky.

Since it also simplifies code just follow his advice.

Fixes: c0f3275f5cb ("nftables: byteorder: provide le/be 64 bit conversion helper")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
NB: This still has the 'potential' cast issue David mentioned
but since other users in the tree do the same thing I think
its okay (if not, someone else needs to fix get/put unaligned api,
I'm not familiar with requirements).

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 383c171..b78c28b 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -46,16 +46,14 @@ static void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned_be64(&src[i]);
-				src64 = be64_to_cpu((__force __be64)src64);
+				src64 = get_unaligned((u64 *)&src[i]);
 				put_unaligned_be64(src64, &dst[i]);
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned_be64(&src[i]);
-				src64 = (__force u64)cpu_to_be64(src64);
-				put_unaligned_be64(src64, &dst[i]);
+				put_unaligned(src64, (u64 *)&dst[i]);
 			}
 			break;
 		}
-- 
2.4.10

