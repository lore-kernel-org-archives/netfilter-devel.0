From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 2/5 v2] nft: alloc bitwise operation for ipv4/ipv6 addresses
Date: Fri, 22 Aug 2014 11:16:30 +0200
Message-ID: <1408698993-17706-2-git-send-email-giuseppelng@gmail.com>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45728 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHVJM4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:12:56 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so9872116wib.8
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:12:55 -0700 (PDT)
In-Reply-To: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch permits to add a bitwise operation for IPv4/IPv6 address and mask

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-shared.c | 34 ++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 05fb29b..3ffe877 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -82,6 +82,40 @@ void add_bitwise_u16(struct nft_rule *r, int mask, int xor)
 	nft_rule_add_expr(r, expr);
 }
 
+void add_bitwise_u32(struct nft_rule *r, int mask, int xor)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, sizeof(uint32_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, &mask, sizeof(uint32_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, &xor, sizeof(uint32_t));
+
+	nft_rule_add_expr(r, expr);
+}
+
+void add_bitwise_u128(struct nft_rule *r, uint8_t *mask, uint8_t *xor)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, 16);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, mask, 16);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, xor, 16);
+
+	nft_rule_add_expr(r, expr);
+}
+
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
 {
 	struct nft_rule_expr *expr;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c4936dd..f2896bb 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -75,6 +75,8 @@ struct nft_family_ops {
 void add_meta(struct nft_rule *r, uint32_t key);
 void add_payload(struct nft_rule *r, int offset, int len);
 void add_bitwise_u16(struct nft_rule *r, int mask, int xor);
+void add_bitwise_u32(struct nft_rule *r, int mask, int xor);
+void add_bitwise_u128(struct nft_rule *r, uint8_t *mask, uint8_t *xor);
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nft_rule *r, uint8_t val, uint32_t op);
 void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op);
-- 
1.8.3.2

