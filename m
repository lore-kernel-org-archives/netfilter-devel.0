From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables] nft: fix inconsistent data type in NFT_EXPR_CMP_OP and NFT_EXPR_META_KEY
Date: Fri, 10 Jan 2014 14:32:53 +0100
Message-ID: <1389360773-3842-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57740 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaAJNdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:33:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to use uint32_t instead uint8_t to adapt this to the libnftables
changes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-ipv4.c   |    2 +-
 iptables/nft-shared.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 1afe8b6..3aeb8a7 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -131,7 +131,7 @@ static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
 		return;
 	}
 
-	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
+	op = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP);
 	if (op == NFT_CMP_EQ)
 		*inv = true;
 	else
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index e0eaa17..43f03b2 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -90,8 +90,8 @@ void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
 	if (expr == NULL)
 		return;
 
-	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_SREG, NFT_REG_1);
-	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_OP, op);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_CMP_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_CMP_OP, op);
 	nft_rule_expr_set(expr, NFT_EXPR_CMP_DATA, data, len);
 
 	nft_rule_add_expr(r, expr);
@@ -225,7 +225,7 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 	switch(key) {
 	case NFT_META_IIF:
 		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		if (nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_IN;
 
 		if_indextoname(value, iniface);
@@ -234,7 +234,7 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		break;
 	case NFT_META_OIF:
 		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		if (nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_OUT;
 
 		if_indextoname(value, outiface);
@@ -243,7 +243,7 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		break;
 	case NFT_META_IIFNAME:
 		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		if (nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_IN;
 
 		memcpy(iniface, ifname, len);
@@ -258,7 +258,7 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		break;
 	case NFT_META_OIFNAME:
 		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		if (nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_OUT;
 
 		memcpy(outiface, ifname, len);
@@ -372,7 +372,7 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 	}
 
 	memcpy(data, nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len), dlen);
-	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
+	op = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP);
 	if (op == NFT_CMP_NEQ)
 		*inv = true;
 	else
@@ -383,7 +383,7 @@ void
 nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	       int family, void *data)
 {
-	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
+	uint8_t key = nft_rule_expr_get_u32(e, NFT_EXPR_META_KEY);
 	struct nft_family_ops *ops = nft_family_ops_lookup(family);
 	const char *name;
 
-- 
1.7.10.4

