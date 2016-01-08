From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] nftables: byteorder: provide 64bit le/be conversion
Date: Fri,  8 Jan 2016 10:29:12 +0100
Message-ID: <1452245352-2899-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47821 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbcAHJgt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:36:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed to convert the (64bit) conntrack counters to BE ordering.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Also needs a small nft change, will submit it soon as part of
 ct counter support series.

 net/netfilter/nft_byteorder.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index fde5145..383c171 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -8,6 +8,7 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <asm/unaligned.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -39,6 +40,27 @@ static void nft_byteorder_eval(const struct nft_expr *expr,
 	d = (void *)dst;
 
 	switch (priv->size) {
+	case 8: {
+		u64 src64;
+
+		switch (priv->op) {
+		case NFT_BYTEORDER_NTOH:
+			for (i = 0; i < priv->len / 8; i++) {
+				src64 = get_unaligned_be64(&src[i]);
+				src64 = be64_to_cpu((__force __be64)src64);
+				put_unaligned_be64(src64, &dst[i]);
+			}
+			break;
+		case NFT_BYTEORDER_HTON:
+			for (i = 0; i < priv->len / 8; i++) {
+				src64 = get_unaligned_be64(&src[i]);
+				src64 = (__force u64)cpu_to_be64(src64);
+				put_unaligned_be64(src64, &dst[i]);
+			}
+			break;
+		}
+		break;
+	}
 	case 4:
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
@@ -101,6 +123,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	switch (priv->size) {
 	case 2:
 	case 4:
+	case 8:
 		break;
 	default:
 		return -EINVAL;
-- 
2.4.10

