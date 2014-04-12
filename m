From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/1] netfilter: nf_tables: fix nft_cmp_fast failure on big endian for size < 4
Date: Sat, 12 Apr 2014 13:17:57 +0200
Message-ID: <1397301477-16204-2-git-send-email-kaber@trash.net>
References: <1397301477-16204-1-git-send-email-kaber@trash.net>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42493 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaDLLSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:18:06 -0400
In-Reply-To: <1397301477-16204-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_cmp_fast is used for equality comparisions of size <= 4. For
comparisions of size < 4 byte a mask is calculated that is applied to
both the data from userspace (during initialization) and the register
value (during runtime). Both values are stored using (in effect) memcpy
to a memory area that is then interpreted as u32 by nft_cmp_fast.

This works fine on little endian since smaller types have the same base
address, however on big endian this is not true and the smaller types
are interpreted as a big number with trailing zero bytes.

The mask therefore must not include the lower bytes, but the higher bytes
on big endian. Add a helper function that does a cpu_to_le32 to switch
the bytes on big endian. Since we're dealing with a mask of just consequitive
bits, this works out fine.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables_core.h | 10 ++++++++++
 net/netfilter/nf_tables_core.c         |  3 +--
 net/netfilter/nft_cmp.c                |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index cf2b7ae..a75fc8e 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -13,6 +13,16 @@ struct nft_cmp_fast_expr {
 	u8			len;
 };
 
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static inline u32 nft_cmp_fast_mask(unsigned int len)
+{
+	return cpu_to_le32(~0U >> (FIELD_SIZEOF(struct nft_cmp_fast_expr,
+						data) * BITS_PER_BYTE - len));
+}
+
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 
 int nft_cmp_module_init(void);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 90998a6..8041053 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -25,9 +25,8 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_data data[NFT_REG_MAX + 1])
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	u32 mask;
+	u32 mask = nft_cmp_fast_mask(priv->len);
 
-	mask = ~0U >> (sizeof(priv->data) * BITS_PER_BYTE - priv->len);
 	if ((data[priv->sreg].data[0] & mask) == priv->data)
 		return;
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 954925d..e2b3f51 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -128,7 +128,7 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	BUG_ON(err < 0);
 	desc.len *= BITS_PER_BYTE;
 
-	mask = ~0U >> (sizeof(priv->data) * BITS_PER_BYTE - desc.len);
+	mask = nft_cmp_fast_mask(desc.len);
 	priv->data = data.data[0] & mask;
 	priv->len  = desc.len;
 	return 0;
-- 
1.9.0

