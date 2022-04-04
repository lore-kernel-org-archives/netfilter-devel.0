Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01828C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiDDMIc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbiDDMI0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D43DA61
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7y2adnOkir0FaL/gNIRALlSBxnY1d9TpGCPzRTo0gBQ=; b=sMa9fQSU6kBj84C53FrMvq0kzF
        NpmiKYEpmHrI1MsXsjg6ZVhrTFy2eUbSAqkFynwKuPk0RiPR0bvEFg1XBqrJ5bc8acf7qkQkA7RxR
        PV4p4Si7KV5pQzE7482Yt1AfNGelyXui6RTv4fDt68movGzlESt7sRWTITR43++V9C9laHOh9KTfY
        5oBXBnvT2udaidTd8qmK1r97G71eEZwk8ChW7xr4noM5rovQ0Q+ZAl9cUoQeSmM+8P38QnWECJvnK
        aotKl4ja4pdd7BiMVX5d4e9PZdAYQ9H92k7Vf49ChqpPy4Xf30YpSOqUX7V+MuuTb553IewW2DGGN
        940EvImA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTY-007FNA-Fx
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 9/9] tests: bitwise: add tests for new boolean operations
Date:   Mon,  4 Apr 2022 13:06:23 +0100
Message-Id: <20220404120623.188439-10-jeremy@azazel.net>
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

We already have tests for mask-and-xor operations with constant RHS
operands.  Add tests for new operations with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/nft-expr_bitwise-test.c | 109 ++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 5e7e277a5081..b613d7d70d49 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -209,6 +209,103 @@ static void test_rshift(void)
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
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_NBITS) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_NBITS))
+		print_err(opname, "Expr BITWISE_NBITS mismatches");
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
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_NBITS, 0x11223344);
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
@@ -223,6 +320,18 @@ int main(int argc, char *argv[])
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
2.35.1

