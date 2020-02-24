Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E80FC11D32
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C66C20828
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZXd1Tn67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBXNME (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:12:04 -0500
Received: from kadath.azazel.net ([81.187.231.250]:58260 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbgBXNME (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 08:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l7/6JrBZ0aYOf1+mbdhLPbImLPNs+v5NuNSa0f5rSa0=; b=ZXd1Tn67xtAFsMA34A4+6bEUFM
        7Hj8SramyMtP5BZnn1crJBDcAl/vBdxhFOStQZQtIkaeBiEbOztjXwQu5Ozw93lJ/JqsefCyVt7JK
        ufWUNXGyTb+AXVrPQmTT1AT9LIBLKV8F2oWH0a/poywIa755g2f2DBzjq4CGUYoiyvoUpyUIfC8XE
        oQHgPFg775P1po43qoNTgEThbQXSPVHADKGvKB/X7VUZrFmVqCTBuN9uqBHF4ugb+3TMPB6GLyym6
        a4rCErDHQyYdsYx+sjb0/5ikDhk6z0Ilr1u3JhZ1MhKmP4lGfY2y15N7i2/Aj8ENrPZweIJvbQT7v
        T/P+uyPQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DWk-0001wB-7S; Mon, 24 Feb 2020 13:12:02 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 3/3] bitwise: add support for passing mask and xor via registers.
Date:   Mon, 24 Feb 2020 13:12:01 +0000
Message-Id: <20200224131201.512755-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224131201.512755-1-jeremy@azazel.net>
References: <20200224131201.512755-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel supports passing mask and xor values for bitwise boolean
operations via registers.  These are mutually exclusive with the
existing data attributes: e.g., setting both NFTA_EXPR_BITWISE_MASK and
NFTA_EXPR_BITWISE_MREG is an error.  Add support to libnftnl.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h       |  2 +
 src/expr/bitwise.c            | 60 +++++++++++++++++++++++++++---
 tests/nft-expr_bitwise-test.c | 70 +++++++++++++++++++++++------------
 3 files changed, 102 insertions(+), 30 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfe456dbc7a5..edeeeb1ec234 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -118,6 +118,8 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	NFTNL_EXPR_BITWISE_MREG,
+	NFTNL_EXPR_BITWISE_XREG,
 };
 
 enum {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ea2f662b3e6..1ad4f087fec4 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -29,6 +29,8 @@ struct nftnl_expr_bitwise {
 	union nftnl_data_reg	mask;
 	union nftnl_data_reg	xor;
 	union nftnl_data_reg	data;
+	enum nft_registers	mreg;
+	enum nft_registers	xreg;
 };
 
 static int
@@ -51,10 +53,14 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->len, data, sizeof(bitwise->len));
 		break;
 	case NFTNL_EXPR_BITWISE_MASK:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_MREG))
+			return -1;
 		memcpy(&bitwise->mask.val, data, data_len);
 		bitwise->mask.len = data_len;
 		break;
 	case NFTNL_EXPR_BITWISE_XOR:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_XREG))
+			return -1;
 		memcpy(&bitwise->xor.val, data, data_len);
 		bitwise->xor.len = data_len;
 		break;
@@ -62,6 +68,16 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->data.val, data, data_len);
 		bitwise->data.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_MREG:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_MASK))
+			return -1;
+		memcpy(&bitwise->mreg, data, sizeof(bitwise->mreg));
+		break;
+	case NFTNL_EXPR_BITWISE_XREG:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_XOR))
+			return -1;
+		memcpy(&bitwise->xreg, data, sizeof(bitwise->xreg));
+		break;
 	default:
 		return -1;
 	}
@@ -96,6 +112,12 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_DATA:
 		*data_len = bitwise->data.len;
 		return &bitwise->data.val;
+	case NFTNL_EXPR_BITWISE_MREG:
+		*data_len = sizeof(bitwise->mreg);
+		return &bitwise->mreg;
+	case NFTNL_EXPR_BITWISE_XREG:
+		*data_len = sizeof(bitwise->xreg);
+		return &bitwise->xreg;
 	}
 	return NULL;
 }
@@ -113,6 +135,8 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
+	case NFTA_BITWISE_MREG:
+	case NFTA_BITWISE_XREG:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -165,6 +189,10 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 				bitwise->data.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_MREG))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_MREG, htonl(bitwise->mreg));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_XREG))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_XREG, htonl(bitwise->xreg));
 }
 
 static int
@@ -205,13 +233,22 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->data, tb[NFTA_BITWISE_DATA], NULL);
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_DATA);
 	}
+	if (tb[NFTA_BITWISE_MREG]) {
+		bitwise->mreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_MREG]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_MREG);
+	}
+	if (tb[NFTA_BITWISE_XREG]) {
+		bitwise->xreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_XREG]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_XREG);
+	}
 
 	return ret;
 }
 
 static int
 nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
-				 const struct nftnl_expr_bitwise *bitwise)
+				 const struct nftnl_expr_bitwise *bitwise,
+				 uint32_t flags)
 {
 	int remain = size, offset = 0, ret;
 
@@ -219,15 +256,25 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 		       bitwise->dreg, bitwise->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	if (flags & (1 << NFTA_BITWISE_MASK))
+		ret = nftnl_data_reg_snprintf(buf + offset, remain,
+					      &bitwise->mask,
+					      NFTNL_OUTPUT_DEFAULT, 0,
+					      DATA_VALUE);
+	else
+		ret = snprintf(buf + offset, remain, "reg %u ", bitwise->mreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	if (flags & (1 << NFTA_BITWISE_XOR))
+		ret = nftnl_data_reg_snprintf(buf + offset, remain,
+					      &bitwise->xor,
+					      NFTNL_OUTPUT_DEFAULT, 0,
+					      DATA_VALUE);
+	else
+		ret = snprintf(buf + offset, remain, "reg %u ", bitwise->xreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -260,7 +307,8 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 
 	switch (bitwise->op) {
 	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise,
+						       e->flags);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index f134728fdd86..c1d59571b7d5 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -28,31 +28,42 @@ static void print_err(const char *test, const char *msg)
 }
 
 static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
-				struct nftnl_expr *rule_b)
+				struct nftnl_expr *rule_b,
+				bool data)
 {
+	const char *test_name = data ? "bool data" : "bool reg";
 	uint32_t maska, maskb;
 	uint32_t xora, xorb;
 
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("bool", "Expr BITWISE_DREG mismatches");
+		print_err(test_name, "Expr BITWISE_DREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("bool", "Expr BITWISE_SREG mismatches");
+		print_err(test_name, "Expr BITWISE_SREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("bool", "Expr BITWISE_OP mismatches");
+		print_err(test_name, "Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("bool", "Expr BITWISE_LEN mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
-	if (maska != maskb)
-		print_err("bool", "Size of BITWISE_MASK mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
-	if (xora != xorb)
-		print_err("bool", "Size of BITWISE_XOR mismatches");
+		print_err(test_name, "Expr BITWISE_LEN mismatches");
+	if (data) {
+		nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
+		nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
+		if (maska != maskb)
+			print_err(test_name, "Size of BITWISE_MASK mismatches");
+		nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
+		nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
+		if (xora != xorb)
+			print_err(test_name, "Size of BITWISE_XOR mismatches");
+	} else {
+		if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_MREG) !=
+		    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_MREG))
+			print_err("bool reg", "Expr BITWISE_MREG mismatches");
+		if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_XREG) !=
+		    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_XREG))
+			print_err("bool reg", "Expr BITWISE_XREG mismatches");
+	}
 }
 
 static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
@@ -101,8 +112,9 @@ static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
 		print_err("rshift", "Expr BITWISE_DATA mismatches");
 }
 
-static void test_bool(void)
+static void test_bool(bool data)
 {
+	const char *test_name = data ? "bool data" : "bool reg";
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
 	struct nlmsghdr *nlh;
@@ -115,17 +127,23 @@ static void test_bool(void)
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("bool", "OOM");
+		print_err(test_name, "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("bool", "OOM");
+		print_err(test_name, "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
-	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_MASK, &mask, sizeof(mask));
-	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(xor));
+	if (data) {
+		nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_MASK, &mask,
+			       sizeof(mask));
+		nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(xor));
+	} else {
+		nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_MREG, mask);
+		nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_XREG, xor);
+	}
 
 	nftnl_rule_add_expr(a, ex);
 
@@ -133,26 +151,26 @@ static void test_bool(void)
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("bool", "parsing problems");
+		print_err(test_name, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("bool", "OOM");
+		print_err(test_name, "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("bool", "OOM");
+		print_err(test_name, "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("bool", "More 1 expr.");
+		print_err(test_name, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr_bool(rule_a,rule_b);
+	cmp_nftnl_expr_bool(rule_a, rule_b, data);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
@@ -268,7 +286,11 @@ static void test_rshift(void)
 
 int main(int argc, char *argv[])
 {
-	test_bool();
+	test_bool(true);
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_bool(false);
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-- 
2.25.0

