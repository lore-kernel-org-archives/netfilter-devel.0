From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 2/7] exthdr: prepare for tcp support
Date: Tue,  7 Feb 2017 03:14:10 +0100
Message-ID: <20170207021415.22460-3-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:42007 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751618AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 7DB30B0121
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:29 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

right now exthdr only deals with ipv6 extension headers, followup
patch will enable tcp option matching.

This adds the 'op' arg to exthdr_init.

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 include/exthdr.h          | 3 ++-
 src/exthdr.c              | 5 +++--
 src/netlink_delinearize.c | 4 +++-
 src/netlink_linearize.c   | 4 ++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index d17841b..93a53f3 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -21,7 +21,8 @@ extern struct expr *exthdr_expr_alloc(const struct location *loc,
 				      uint8_t type);
 
 extern void exthdr_init_raw(struct expr *expr, uint8_t type,
-			    unsigned int offset, unsigned int len);
+			    unsigned int offset, unsigned int len,
+			    enum nft_exthdr_op op);
 
 extern bool exthdr_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
diff --git a/src/exthdr.c b/src/exthdr.c
index c641d4a..45b1b69 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -79,7 +79,8 @@ static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 };
 
 void exthdr_init_raw(struct expr *expr, uint8_t type,
-		     unsigned int offset, unsigned int len)
+		     unsigned int offset, unsigned int len,
+		     enum nft_exthdr_op op)
 {
 	const struct proto_hdr_template *tmpl;
 	unsigned int i;
@@ -123,7 +124,7 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 	off += round_up(mask->len, BITS_PER_BYTE) - mask_len;
 
 	exthdr_init_raw(expr, expr->exthdr.desc->type,
-			off, mask_len - mask_offset);
+			off, mask_len - mask_offset, NFT_EXTHDR_OP_IPV6);
 
 	/* still failed to find a template... Bug. */
 	if (expr->exthdr.tmpl == &exthdr_unknown_template)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 144edf5..d6a9fe1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -499,6 +499,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct nftnl_expr *nle)
 {
 	enum nft_registers dreg;
+	enum nft_exthdr_op op;
 	uint32_t offset, len;
 	uint8_t type;
 	struct expr *expr;
@@ -506,9 +507,10 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	type   = nftnl_expr_get_u8(nle, NFTNL_EXPR_EXTHDR_TYPE);
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_LEN) * BITS_PER_BYTE;
+	op     = NFT_EXTHDR_OP_IPV6;
 
 	expr = exthdr_expr_alloc(loc, NULL, 0);
-	exthdr_init_raw(expr, type, offset, len);
+	exthdr_init_raw(expr, type, offset, len, op);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5030135..056f113 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -162,14 +162,14 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
 {
+	unsigned int offset = expr->exthdr.tmpl->offset;
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("exthdr");
 	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_DREG, dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
 			  expr->exthdr.desc->type);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET,
-			   expr->exthdr.tmpl->offset / BITS_PER_BYTE);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_rule_add_expr(ctx->nlr, nle);
-- 
2.11.1

