From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 4/9] netlink_linearize: use NFT_REG32 values internally
Date: Fri,  5 Jun 2015 15:42:46 +0200
Message-ID: <1433511771-4620-5-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbFENmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:55 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare netlink_linearize for 32 bit register usage:

Switch to use 16 data registers of 32 bit each. A helper function takes
care of mapping the registers to the NFT_REG32 values and, if the
register refers to the beginning of an 128 bit area, the old NFT_REG_1-4
values for compatibility.

New register reservation and release helper function take the size into
account and reserve the required amount of registers.

The reservation and release functions will so far still always allocate
128 bit. If no other expression in a rule uses a 32 bit register directly,
these will be mapped to the old register values, meaning everything
continues to work with old kernel versions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h       |  5 +++++
 src/netlink_linearize.c | 43 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 9f24ea5..9b42fdb 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -53,6 +53,11 @@ struct nft_data_delinearize {
 	int		verdict;
 };
 
+static inline unsigned int netlink_register_space(unsigned int size)
+{
+	return div_round_up(size, NFT_REG32_SIZE * BITS_PER_BYTE);
+}
+
 extern void netlink_gen_data(const struct expr *expr,
 			     struct nft_data_linearize *data);
 extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index beeb0c2..6930b39 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -27,21 +27,54 @@ struct netlink_linearize_ctx {
 static void netlink_put_register(struct nft_rule_expr *nle,
 				 uint32_t attr, uint32_t reg)
 {
+	/* Convert to 128 bit register numbers if possible for compatibility */
+	if (reg != NFT_REG_VERDICT) {
+		reg -= NFT_REG_1;
+		if (reg % (NFT_REG_SIZE / NFT_REG32_SIZE) == 0)
+			reg = NFT_REG_1 + reg / (NFT_REG_SIZE / NFT_REG32_SIZE);
+		else
+			reg += NFT_REG32_00;
+	}
+
 	nft_rule_expr_set_u32(nle, attr, reg);
 }
 
+static enum nft_registers __get_register(struct netlink_linearize_ctx *ctx,
+					 unsigned int size)
+{
+	unsigned int reg, n;
+
+	n = netlink_register_space(size);
+	if (ctx->reg_low + n > NFT_REG_1 + NFT_REG32_15 - NFT_REG32_00 + 1)
+		BUG("register reg_low %u invalid\n", ctx->reg_low);
+
+	reg = ctx->reg_low;
+	ctx->reg_low += n;
+	return reg;
+}
+
+static void __release_register(struct netlink_linearize_ctx *ctx,
+			       unsigned int size)
+{
+	unsigned int n;
+
+	n = netlink_register_space(size);
+	if (ctx->reg_low < NFT_REG_1 + n)
+		BUG("register reg_low %u invalid\n", ctx->reg_low);
+
+	ctx->reg_low -= n;
+}
+
 static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
 				       const struct expr *expr)
 {
-	if (ctx->reg_low > NFT_REG_MAX)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
-	return ctx->reg_low++;
+	return __get_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
 }
 
 static void release_register(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr)
 {
-	ctx->reg_low--;
+	__release_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
 }
 
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
@@ -509,6 +542,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr,
 			     enum nft_registers dreg)
 {
+	assert(dreg < ctx->reg_low);
+
 	switch (expr->ops->type) {
 	case EXPR_VERDICT:
 	case EXPR_VALUE:
-- 
2.1.0

