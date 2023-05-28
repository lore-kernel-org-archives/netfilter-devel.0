Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B25C7EE31
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjE1N4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjE1N4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:56:18 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE72C9
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ng8PjlQ/1C8/4RrRNiSrwn3iSG41Pq3rvQ3hGBvjkFM=; b=X5mRk2IlhrE8Gd+RIurO4W+5Cw
        fdMpk1/BlT0xtuBgXrWzFjGeCW2IBGn3Mbpr/ACWOssNyGvJ9a3ipwDE0wqACpLhyitZ+MAd1/dTl
        hLSLwFUXZ0EAF66QMP7hHoywRzJ2e1Xv6pJIkKkPiwVuzKovhcfk5hamNc+8WNPylV+2/JdkPyeTP
        hGUyJEh5U5qucOh9L7tgZMb9XkPd6uK28M2znEhektJfPGcPNJISfEjFfL7x/x2Z6i7Gg+XMUW2Pn
        g3Ki/CPnnz/k5ZFqtqlFbf3K3sgRU/3r0rmW70qd0ONhdzRTiPubljg0CY6RbiuHFqu/9/Mu9oh8C
        r+gS+A7A==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3GsY-008We9-Ba
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:56:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v3 2/5] expr: bitwise: rename some boolean operation functions
Date:   Sun, 28 May 2023 14:55:58 +0100
Message-Id: <20230528135601.1218337-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528135601.1218337-1-jeremy@azazel.net>
References: <20230528135601.1218337-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c            |  8 ++++----
 tests/nft-expr_bitwise-test.c | 34 +++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 2d272335e377..4cac017736fe 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -210,8 +210,8 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
-				 const struct nftnl_expr_bitwise *bitwise)
+nftnl_expr_bitwise_snprintf_mask_xor(char *buf, size_t remain,
+				     const struct nftnl_expr_bitwise *bitwise)
 {
 	int offset = 0, ret;
 
@@ -260,8 +260,8 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 	int err = -1;
 
 	switch (bitwise->op) {
-	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+	case NFT_BITWISE_MASK_XOR:
+		err = nftnl_expr_bitwise_snprintf_mask_xor(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 44c4bf06f041..95e9a1952084 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -27,32 +27,32 @@ static void print_err(const char *test, const char *msg)
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
@@ -101,7 +101,7 @@ static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
 		print_err("rshift", "Expr BITWISE_DATA mismatches");
 }
 
-static void test_bool(void)
+static void test_mask_xor(void)
 {
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
@@ -115,10 +115,10 @@ static void test_bool(void)
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
@@ -133,26 +133,26 @@ static void test_bool(void)
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
@@ -268,7 +268,7 @@ static void test_rshift(void)
 
 int main(int argc, char *argv[])
 {
-	test_bool();
+	test_mask_xor();
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-- 
2.39.2

