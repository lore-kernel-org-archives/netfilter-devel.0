From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/17] netfilter: nft_byteorder: provide 64bit le/be conversion
Date: Fri,  8 Jan 2016 15:02:16 +0100
Message-ID: <1452261737-7475-17-git-send-email-pablo@netfilter.org>
References: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Needed to convert the (64bit) conntrack counters to BE ordering.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.1.4
