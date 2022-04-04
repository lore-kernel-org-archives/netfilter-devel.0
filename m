Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB0DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiDDMIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124873DA7F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AagCtf7xGIJ457g/dDr0GNcWght3+kazxKmjAUDNaqQ=; b=Gnm3ZkC6MYua7/QrZ0xV89a2+V
        RvWZmOtVjF9RgQ1vRoQmldeLfXDqmmLH922RPMarET+xQ311N9etpFJe/gO6nuIv47Ob47iPAevwN
        0emCKcAO7gdjerhJaCaTXWcb4f4sii78rmp+ZIhjP3hh1n/JuZePg2n0s8Z5Ej+DqcuU/Xc7Gn2B7
        kdua7qoKKNBk+E35YbtUPei0P3gKxxi93JYfk2y6xh12GGA++Bf/+Q1wiTVnLNKi67Q0A1cCamPxO
        TFvj9+lr0otE7QuyIkYrQ0ye3y4/5yUVuIuYE/iLTlwfthbgPVJ+UutrXc6X/jgSzL4PRt2SNC7lx
        cxBmwGjg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTY-007FNA-5k
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 6/9] expr: bitwise: rename some boolean operation functions
Date:   Mon,  4 Apr 2022 13:06:20 +0100
Message-Id: <20220404120623.188439-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120623.188439-1-jeremy@azazel.net>
References: <20220404120623.188439-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c            |  8 ++++----
 tests/nft-expr_bitwise-test.c | 36 +++++++++++++++++------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index d695cb1cc3a9..c7428af6adf8 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -225,8 +225,8 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
-				 const struct nftnl_expr_bitwise *bitwise)
+nftnl_expr_bitwise_snprintf_mask_xor(char *buf, size_t remain,
+				     const struct nftnl_expr_bitwise *bitwise)
 {
 	int offset = 0, ret;
 
@@ -275,8 +275,8 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 	int err = -1;
 
 	switch (bitwise->op) {
-	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+	case NFT_BITWISE_MASK_XOR:
+		err = nftnl_expr_bitwise_snprintf_mask_xor(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<",
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 9d01376a69bd..96298a4a97d2 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -27,35 +27,35 @@ static void print_err(const char *test, const char *msg)
 	printf("\033[31mERROR:\e[0m [%s] %s\n", test, msg);
 }
 
-static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
-				struct nftnl_expr *rule_b)
+static void cmp_nftnl_expr_mask_xor(struct nftnl_expr *rule_a,
+				    struct nftnl_expr *rule_b)
 {
 	uint32_t maska, maskb;
 	uint32_t xora, xorb;
 
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("bool", "Expr BITWISE_DREG mismatches");
+		print_err("mask & xor", "Expr BITWISE_DREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("bool", "Expr BITWISE_SREG mismatches");
+		print_err("mask & xor", "Expr BITWISE_SREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("bool", "Expr BITWISE_OP mismatches");
+		print_err("mask & xor", "Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("bool", "Expr BITWISE_LEN mismatches");
+		print_err("mask & xor", "Expr BITWISE_LEN mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_NBITS) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_NBITS))
-		print_err("bool", "Expr BITWISE_NBITS mismatches");
+		print_err("mask & xor", "Expr BITWISE_NBITS mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
 	if (maska != maskb)
-		print_err("bool", "Size of BITWISE_MASK mismatches");
+		print_err("mask & xor", "Size of BITWISE_MASK mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
 	if (xora != xorb)
-		print_err("bool", "Size of BITWISE_XOR mismatches");
+		print_err("mask & xor", "Size of BITWISE_XOR mismatches");
 }
 
 static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
@@ -110,7 +110,7 @@ static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
 		print_err("rshift", "Expr BITWISE_DATA mismatches");
 }
 
-static void test_bool(void)
+static void test_mask_xor(void)
 {
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
@@ -124,10 +124,10 @@ static void test_bool(void)
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
@@ -143,26 +143,26 @@ static void test_bool(void)
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("bool", "parsing problems");
+		print_err("mask & xor", "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("bool", "More 1 expr.");
+		print_err("mask & xor", "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr_bool(rule_a,rule_b);
+	cmp_nftnl_expr_mask_xor(rule_a,rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
@@ -280,7 +280,7 @@ static void test_rshift(void)
 
 int main(int argc, char *argv[])
 {
-	test_bool();
+	test_mask_xor();
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-- 
2.35.1

