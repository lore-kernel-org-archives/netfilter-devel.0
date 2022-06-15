Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCA1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 08:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiFOIxG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 04:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiFOIxG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 04:53:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00611F2EF
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 01:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w2WOhjiZx5oX1bMy2Mhgd0sLp/tusGCexUHicr4AflQ=; b=W8c+pqsQhxabala8gQz/N3ilsY
        N4xyCjgJrFz5bF9RScGX6YtvCsnZ3uvgcovYwsDkPJS8pEAzEdl+a5P93C6G7DIUFKpEwx707sEjo
        tBOxB3DL1yP3iYrIauFXB8UfOigLvGeJvP2ly+YCbAmBMYGAHmQIoRK4u2b++2KfwM+gUQgRRkoJp
        Nu38qz3boGbDGHxg2B6zr8tqdad5R63Kru4kW9bO6envtPaFzox8lVjnPobUuI5z8CmowpeFMUFxu
        t2324DhTr1r6yKi80Tx2d+U5TzirC8qvQOYbqOxU/GTeQXEdDI0lUrM4N3XD2IdoFznsf/oI6+PAw
        /cJ9UKbw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o1Olr-000069-4F; Wed, 15 Jun 2022 10:53:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH v2] nft: Exit if nftnl_alloc_expr fails
Date:   Wed, 15 Jun 2022 10:52:54 +0200
Message-Id: <20220615085254.26208-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In some code-paths, 'reg' pointer remaining uninitialized is used later
so at least minimal error checking is necessary. Given that a call to
nftnl_alloc_expr() with sane argument should never fail, complain and
exit if it happens.

Fixes: 7e38890c6b4fb ("nft: prepare for dynamic register allocation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Use a better name for the helper function
- Drop extra newline
- Review commit message for clarity
---
 iptables/nft-shared.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 27e95c1ae4f38..74e19ccad226d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -40,15 +40,24 @@ extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
 extern struct nft_family_ops nft_family_ops_bridge;
 
+static struct nftnl_expr *xt_nftnl_expr_alloc(const char *name)
+{
+	struct nftnl_expr *expr = nftnl_expr_alloc(name);
+
+	if (expr)
+		return expr;
+
+	xtables_error(RESOURCE_PROBLEM,
+		      "Failed to allocate nftnl expression '%s'", name);
+}
+
 void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
 	      uint8_t *dreg)
 {
 	struct nftnl_expr *expr;
 	uint8_t reg;
 
-	expr = nftnl_expr_alloc("meta");
-	if (expr == NULL)
-		return;
+	expr = xt_nftnl_expr_alloc("meta");
 
 	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
@@ -64,9 +73,7 @@ void add_payload(struct nft_handle *h, struct nftnl_rule *r,
 	struct nftnl_expr *expr;
 	uint8_t reg;
 
-	expr = nftnl_expr_alloc("payload");
-	if (expr == NULL)
-		return;
+	expr = xt_nftnl_expr_alloc("payload");
 
 	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
@@ -85,9 +92,7 @@ void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
 	struct nftnl_expr *expr;
 	uint8_t reg;
 
-	expr = nftnl_expr_alloc("bitwise");
-	if (expr == NULL)
-		return;
+	expr = xt_nftnl_expr_alloc("bitwise");
 
 	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
@@ -107,9 +112,7 @@ void add_bitwise(struct nft_handle *h, struct nftnl_rule *r,
 	uint32_t xor[4] = { 0 };
 	uint8_t reg = *dreg;
 
-	expr = nftnl_expr_alloc("bitwise");
-	if (expr == NULL)
-		return;
+	expr = xt_nftnl_expr_alloc("bitwise");
 
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
@@ -126,9 +129,7 @@ void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len,
 {
 	struct nftnl_expr *expr;
 
-	expr = nftnl_expr_alloc("cmp");
-	if (expr == NULL)
-		return;
+	expr = xt_nftnl_expr_alloc("cmp");
 
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_OP, op);
-- 
2.34.1

