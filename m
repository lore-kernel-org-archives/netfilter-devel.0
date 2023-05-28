Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36CCC7EE32
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjE1N4Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjE1N4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:56:21 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC1BD9
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vFI0Mp74OzIsFASa+oORTiYNK+wddJ8+czxTQiq8VSQ=; b=Xv0b9WFpVXaPfiVP2C719ZC7LK
        e9BV0ESuA5TvQpt1JZ6PS5kNThPjcgxMq7C2JxucF6MeDdB27hm8s3WGiE98JGN1CyA5n/mvrgRu5
        7vwoI+Zy/aeFZzqDl4hQL94lTMCZ3W4lkRT4S+mZm200ESGuJzmO4FwoSK4P2vA/FEsaEQzek4Ahj
        Uegf4R2t3VMRqJagH6SMLhFNN6jF3FxIHauq/o9D2Gr2sFxOB8u3JKoT8yIQCaZoe/0cGX0DTbLdf
        jG/Af+ZuXXKin3pMmoQHh/G28XCXyqqEFsMo9lXz0ZoXr1jeP0x/JMmbSg1bAejMk+SUUkcyyqmse
        CE/moO+A==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3GsY-008We9-GO
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:56:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v3 5/5] tests: bitwise: add tests for new boolean operations
Date:   Sun, 28 May 2023 14:56:01 +0100
Message-Id: <20230528135601.1218337-6-jeremy@azazel.net>
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

We already have tests for mask-and-xor operations with constant RHS
operands.  Add tests for new operations with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/nft-expr_bitwise-test.c | 105 ++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 7a821ed69ec1..f4b3a7ea2558 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -201,6 +201,99 @@ static void test_rshift(void)
 	test_shift(NFT_BITWISE_RSHIFT);
 }
 
+static void cmp_nftnl_expr_bool(const char *opname,
+				const struct nftnl_expr *rule_a,
+				const struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err(opname, "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err(opname, "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG2) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG2))
+		print_err(opname, "Expr BITWISE_SREG2 mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err(opname, "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err(opname, "Expr BITWISE_LEN mismatches");
+}
+
+static void test_bool(enum nft_bitwise_ops op)
+{
+	struct nftnl_rule *a, *b;
+	struct nftnl_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nftnl_expr_iter *iter_a, *iter_b;
+	struct nftnl_expr *rule_a, *rule_b;
+	const char *opname =
+		op == NFT_BITWISE_AND ? "and" :
+		op == NFT_BITWISE_OR  ? "or"  : "xor";
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err(opname, "OOM");
+	ex = nftnl_expr_alloc("bitwise");
+	if (ex == NULL)
+		print_err(opname, "OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG2, 0x90abcdef);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, op);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err(opname, "parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err(opname, "OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err(opname, "OOM");
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err(opname, "More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+
+	cmp_nftnl_expr_bool(opname, rule_a, rule_b);
+
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
+}
+
+static void test_and(void)
+{
+	test_bool(NFT_BITWISE_AND);
+}
+
+static void test_or(void)
+{
+	test_bool(NFT_BITWISE_OR);
+}
+
+static void test_xor(void)
+{
+	test_bool(NFT_BITWISE_XOR);
+}
+
 int main(int argc, char *argv[])
 {
 	test_mask_xor();
@@ -215,6 +308,18 @@ int main(int argc, char *argv[])
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
+	test_and();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_or();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_xor();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
 	printf("%s: \033[32mOK\e[0m\n", argv[0]);
 	return EXIT_SUCCESS;
 }
-- 
2.39.2

