Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A17C7EE33
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjE1N4Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjE1N4U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:56:20 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60CD2
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9+q6DIkqDJToMJwJU4sYVKFyIMa/shaYP4Lkzrc9ZXo=; b=S++PVVrQARh2Wge2Y1ws1+FdC7
        zjYL6I9kr+pxByZexopILVRFXRufJV7kApgdqEPImqxSqcLd2OfTCiedQgqAR3w5hupKZO1q08Ofv
        JDnAT+dm6nZ3U/rooOpBDersKpVS3pf1lrPIAGdQLr8QdOICxTJcZOEWOgERoqq9daVroXHo27SuX
        rEcUtt+kOz3obHzvK5GSOwqLhOA53kW3699u+sJxLbNAmZOqicB8ibk1r50f+lZX7JvrTGCjw0sfh
        kmEA+faXkegfecpxzjPSZ2vH65NsqIbdyT0grbt/1/c4TNNAc+UUglL5YBFMmhn2sU24XQRE00ALb
        JuhVeg/Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3GsY-008We9-Ev
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:56:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v3 4/5] tests: bitwise: refactor shift tests
Date:   Sun, 28 May 2023 14:56:00 +0100
Message-Id: <20230528135601.1218337-5-jeremy@azazel.net>
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

Deduplicate shift tests: instead of having separate implementations
for left- and right-shifts, have one and pass the operation to it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/nft-expr_bitwise-test.c | 153 ++++++++++------------------------
 1 file changed, 44 insertions(+), 109 deletions(-)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 95e9a1952084..7a821ed69ec1 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -55,52 +55,6 @@ static void cmp_nftnl_expr_mask_xor(struct nftnl_expr *rule_a,
 		print_err("mask & xor", "Size of BITWISE_XOR mismatches");
 }
 
-static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
-				  struct nftnl_expr *rule_b)
-{
-	uint32_t data_a, data_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("lshift", "Expr BITWISE_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("lshift", "Expr BITWISE_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("lshift", "Expr BITWISE_OP mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("lshift", "Expr BITWISE_LEN mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
-	if (data_a != data_b)
-		print_err("lshift", "Expr BITWISE_DATA mismatches");
-}
-
-static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
-				  struct nftnl_expr *rule_b)
-{
-	uint32_t data_a, data_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("rshift", "Expr BITWISE_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("rshift", "Expr BITWISE_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("rshift", "Expr BITWISE_OP mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("rshift", "Expr BITWISE_LEN mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
-	if (data_a != data_b)
-		print_err("rshift", "Expr BITWISE_DATA mismatches");
-}
-
 static void test_mask_xor(void)
 {
 	struct nftnl_rule *a, *b = NULL;
@@ -158,26 +112,51 @@ static void test_mask_xor(void)
 	nftnl_rule_free(b);
 }
 
-static void test_lshift(void)
+static void cmp_nftnl_expr_shift(const char *opname,
+				 const struct nftnl_expr *rule_a,
+				 const struct nftnl_expr *rule_b)
 {
-	struct nftnl_rule *a, *b = NULL;
-	struct nftnl_expr *ex = NULL;
+	uint32_t data_a, data_b;
+
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err(opname, "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err(opname, "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err(opname, "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err(opname, "Expr BITWISE_LEN mismatches");
+	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
+	if (data_a != data_b)
+		print_err(opname, "Expr BITWISE_DATA mismatches");
+}
+
+static void test_shift(enum nft_bitwise_ops op)
+{
+	struct nftnl_rule *a, *b;
+	struct nftnl_expr *ex;
 	struct nlmsghdr *nlh;
 	char buf[4096];
-	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
-	struct nftnl_expr *rule_a, *rule_b = NULL;
+	struct nftnl_expr_iter *iter_a, *iter_b;
+	struct nftnl_expr *rule_a, *rule_b;
+	const char *opname = op == NFT_BITWISE_LSHIFT ? "lshift" : "rshift";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_LSHIFT);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, op);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 13);
 
@@ -187,83 +166,39 @@ static void test_lshift(void)
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("lshift", "parsing problems");
+		print_err(opname, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("lshift", "More 1 expr.");
+		print_err(opname, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr_lshift(rule_a,rule_b);
+	cmp_nftnl_expr_shift(opname, rule_a, rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 }
 
-static void test_rshift(void)
+static void test_lshift(void)
 {
-	struct nftnl_rule *a, *b = NULL;
-	struct nftnl_expr *ex = NULL;
-	struct nlmsghdr *nlh;
-	char buf[4096];
-	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
-	struct nftnl_expr *rule_a, *rule_b = NULL;
-
-	a = nftnl_rule_alloc();
-	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("rshift", "OOM");
-	ex = nftnl_expr_alloc("bitwise");
-	if (ex == NULL)
-		print_err("rshift", "OOM");
-
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_RSHIFT);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 17);
-
-	nftnl_rule_add_expr(a, ex);
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
-	nftnl_rule_nlmsg_build_payload(nlh, a);
-
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("rshift", "parsing problems");
-
-	iter_a = nftnl_expr_iter_create(a);
-	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("rshift", "OOM");
-
-	rule_a = nftnl_expr_iter_next(iter_a);
-	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("rshift", "OOM");
-
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("rshift", "More 1 expr.");
-
-	nftnl_expr_iter_destroy(iter_a);
-	nftnl_expr_iter_destroy(iter_b);
-
-	cmp_nftnl_expr_rshift(rule_a,rule_b);
+	test_shift(NFT_BITWISE_LSHIFT);
+}
 
-	nftnl_rule_free(a);
-	nftnl_rule_free(b);
+static void test_rshift(void)
+{
+	test_shift(NFT_BITWISE_RSHIFT);
 }
 
 int main(int argc, char *argv[])
-- 
2.39.2

