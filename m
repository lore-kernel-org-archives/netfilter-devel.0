Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A16BC33C9E
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC5072072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Akq7t6on"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgAQU6N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:13 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55996 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbgAQU6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=stR93YSQdc+o5akzSDxR08zrblLN4j3ZzlU6lKKXGao=; b=Akq7t6onCEISTY9uKE6xx5lfXB
        NmmxOWpM14SpDWzPKUW9kh9gWfscxMov45IGnmt+iPshSW/pkOaFs4X8FWxa5bPHQ1bKVCu9fygxd
        laXhidRI5jYJeh40bCR+dwRSBZT3lXDOrxzVIOEvrQWBm1f9A4WiOngWCy07JrriQxAzNkuADGZxD
        fcVgqR77Kr5IWqB0t8LOeWdJdLpeM+5E2Z2voZt+d+t9aQAt40uVRaD80TedO3Ya8JlRP+sRvXP2t
        OPQOowJU0lwuKBEIvpLN4lzs4dfIEOCh3e+WmmvYuQ/+6gqQpaDyVt27KjW+RuZIhAQBwvTadH8k3
        wG5H2+xg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYh0-0004I2-Qs
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 6/6] bitwise: add support for left- and right-shifts.
Date:   Fri, 17 Jan 2020 20:58:08 +0000
Message-Id: <20200117205808.172194-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel supports bitwise shifts.  Add support to libnftnl.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c            |  22 ++++
 tests/nft-expr_bitwise-test.c | 202 +++++++++++++++++++++++++++++++---
 2 files changed, 206 insertions(+), 18 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 6ea39fbbe2ee..9ea2f662b3e6 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -233,6 +233,25 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 	return offset;
 }
 
+static int
+nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
+				  const struct nftnl_expr_bitwise *bitwise)
+{	int remain = size, offset = 0, ret;
+
+	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
+		       bitwise->dreg, bitwise->sreg, op);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->data,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = snprintf(buf + offset, remain, ") ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	return offset;
+}
+
 static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 					       const struct nftnl_expr *e)
 {
@@ -244,7 +263,10 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
+		break;
 	case NFT_BITWISE_RSHIFT:
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
 		break;
 	}
 
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 41c0af435283..74a0e2aa6933 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -21,41 +21,87 @@
 
 static int test_ok = 1;
 
-static void print_err(const char *msg)
+static void print_err(const char *test, const char *msg)
 {
 	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
+	printf("\033[31mERROR:\e[0m [%s] %s\n", test, msg);
 }
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			   struct nftnl_expr *rule_b)
+static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
+				struct nftnl_expr *rule_b)
 {
 	uint32_t maska, maskb;
 	uint32_t xora, xorb;
 
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("Expr BITWISE_DREG mismatches");
+		print_err("bool", "Expr BITWISE_DREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("Expr BITWISE_SREG mismatches");
+		print_err("bool", "Expr BITWISE_SREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("Expr BITWISE_OP mismatches");
+		print_err("bool", "Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("Expr BITWISE_DREG mismatches");
+		print_err("bool", "Expr BITWISE_DREG mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
 	if (maska != maskb)
-		print_err("Size of BITWISE_MASK mismatches");
+		print_err("bool", "Size of BITWISE_MASK mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
 	if (xora != xorb)
-		print_err("Size of BITWISE_XOR mismatches");
+		print_err("bool", "Size of BITWISE_XOR mismatches");
 }
 
-int main(int argc, char *argv[])
+static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
+				  struct nftnl_expr *rule_b)
+{
+	uint32_t data_a, data_b;
+
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err("lshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err("lshift", "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err("lshift", "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err("lshift", "Expr BITWISE_LEN mismatches");
+	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
+	if (data_a != data_b)
+		print_err("lshift", "Expr BITWISE_DATA mismatches");
+}
+
+static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
+				  struct nftnl_expr *rule_b)
+{
+	uint32_t data_a, data_b;
+
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err("rshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err("rshift", "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err("rshift", "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err("rshift", "Expr BITWISE_LEN mismatches");
+	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
+	if (data_a != data_b)
+		print_err("rshift", "Expr BITWISE_DATA mismatches");
+}
+
+static void test_bool(void)
 {
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
@@ -69,10 +115,10 @@ int main(int argc, char *argv[])
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("OOM");
+		print_err("bool", "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("OOM");
+		print_err("bool", "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
@@ -87,30 +133,150 @@ int main(int argc, char *argv[])
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+		print_err("bool", "parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("bool", "OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("bool", "OOM");
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err("bool", "More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+
+	cmp_nftnl_expr_bool(rule_a,rule_b);
+
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
+}
+
+static void test_lshift(void)
+{
+	struct nftnl_rule *a, *b = NULL;
+	struct nftnl_expr *ex = NULL;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
+	struct nftnl_expr *rule_a, *rule_b = NULL;
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("lshift", "OOM");
+	ex = nftnl_expr_alloc("bitwise");
+	if (ex == NULL)
+		print_err("lshift", "OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_LSHIFT);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 13);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("lshift", "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+		print_err("lshift", "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+		print_err("lshift", "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+		print_err("lshift", "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	cmp_nftnl_expr_lshift(rule_a,rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
+}
+
+static void test_rshift(void)
+{
+	struct nftnl_rule *a, *b = NULL;
+	struct nftnl_expr *ex = NULL;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
+	struct nftnl_expr *rule_a, *rule_b = NULL;
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("rshift", "OOM");
+	ex = nftnl_expr_alloc("bitwise");
+	if (ex == NULL)
+		print_err("rshift", "OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_RSHIFT);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 17);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("rshift", "parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("rshift", "OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("rshift", "OOM");
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err("rshift", "More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+
+	cmp_nftnl_expr_rshift(rule_a,rule_b);
+
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
+}
+
+int main(int argc, char *argv[])
+{
+	test_bool();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_lshift();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
 
+	test_rshift();
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-- 
2.24.1

