Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDC4C33CA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B34320721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nF46nsw4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgAJMej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:34:39 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39668 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgAJMei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rrIxsmr2atM6jozOd0SHB8w5tTqq6dtiAuAcaHeQm0c=; b=nF46nsw49bsLYx8SE0DGpA/E3t
        Ry/Hi7Uxbjim7BhnPAWPT828tQfSC649hObbxSC3dV7BrkPvO2on32b2e/8ou9z9z+k2tRdC8Vvcv
        YRWRNBCO1K9ByvEi9XejqG7LRvx2YrDO/kSC3lpiJ5Dz0idGXYyZfnA/FI07rGhevS0nUKlWqsxZQ
        XKqEyqLrcbNAT165zE+e/0CR9zKREwP9vr3lC1vvhKLK1s3tQFc9cZHtLl1GCt2XDLJuNMPcTdBUZ
        6/4KOZGlYKciXMkoSEflwQ6UDwWcUQ+Dea9sPseKwMR3WITlQXHV+LgO/y6URKeYwqxNAXAZclrDC
        1sP+h+NA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptUq-0003du-TA
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:34:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 2/2] bitwise: add support for left and right shifts.
Date:   Fri, 10 Jan 2020 12:34:36 +0000
Message-Id: <20200110123436.106488-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123436.106488-1-jeremy@azazel.net>
References: <20200110123436.106488-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new attributes to bitwise expressions to implement bit-shifts.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h             |   2 +
 include/linux/netfilter/nf_tables.h |   4 +
 src/expr/bitwise.c                  |  52 +++++++-
 tests/nft-expr_bitwise-test.c       | 186 +++++++++++++++++++++++++---
 4 files changed, 225 insertions(+), 19 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 3e0f5b078c7a..062261a2dc38 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -116,6 +116,8 @@ enum {
 	NFTNL_EXPR_BITWISE_LEN,
 	NFTNL_EXPR_BITWISE_MASK,
 	NFTNL_EXPR_BITWISE_XOR,
+	NFTNL_EXPR_BITWISE_LSHIFT,
+	NFTNL_EXPR_BITWISE_RSHIFT,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e237ecbdcd8a..36cc99407eb6 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -492,6 +492,8 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_LSHIFT: left shift value (NLA_U32)
+ * @NFTA_BITWISE_RSHIFT: right shift value (NLA_U32)
  *
  * The bitwise expression performs the following operation:
  *
@@ -512,6 +514,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_LSHIFT,
+	NFTA_BITWISE_RSHIFT,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index c9d40df34b54..49595c7ff442 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -27,6 +27,8 @@ struct nftnl_expr_bitwise {
 	unsigned int		len;
 	union nftnl_data_reg	mask;
 	union nftnl_data_reg	xor;
+	unsigned int		lshift;
+	unsigned int		rshift;
 };
 
 static int
@@ -53,6 +55,12 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->xor.val, data, data_len);
 		bitwise->xor.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_LSHIFT:
+		memcpy(&bitwise->lshift, data, sizeof(bitwise->lshift));
+		break;
+	case NFTNL_EXPR_BITWISE_RSHIFT:
+		memcpy(&bitwise->rshift, data, sizeof(bitwise->rshift));
+		break;
 	default:
 		return -1;
 	}
@@ -81,6 +89,12 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_XOR:
 		*data_len = bitwise->xor.len;
 		return &bitwise->xor.val;
+	case NFTNL_EXPR_BITWISE_LSHIFT:
+		*data_len = sizeof(bitwise->lshift);
+		return &bitwise->lshift;
+	case NFTNL_EXPR_BITWISE_RSHIFT:
+		*data_len = sizeof(bitwise->rshift);
+		return &bitwise->rshift;
 	}
 	return NULL;
 }
@@ -97,6 +111,8 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	case NFTA_BITWISE_SREG:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_LEN:
+	case NFTA_BITWISE_LSHIFT:
+	case NFTA_BITWISE_RSHIFT:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -138,6 +154,12 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 				bitwise->xor.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_LSHIFT))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_LSHIFT,
+				 htonl(bitwise->lshift));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_RSHIFT))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_RSHIFT,
+				 htonl(bitwise->rshift));
 }
 
 static int
@@ -170,6 +192,14 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->xor, tb[NFTA_BITWISE_XOR], NULL);
 		e->flags |= (1 << NFTA_BITWISE_XOR);
 	}
+	if (tb[NFTA_BITWISE_LSHIFT]) {
+		bitwise->lshift = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_LSHIFT]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_LSHIFT);
+	}
+	if (tb[NFTA_BITWISE_RSHIFT]) {
+		bitwise->rshift = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_RSHIFT]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_RSHIFT);
+	}
 
 	return ret;
 }
@@ -180,19 +210,37 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
 
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_LSHIFT)) {
+
+		ret = snprintf(buf, remain, "reg %u = (reg %u << %u) ",
+			       bitwise->dreg, bitwise->sreg, bitwise->lshift);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		return offset;
+
+	}
+
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_RSHIFT)) {
+
+		ret = snprintf(buf, remain, "reg %u = (reg %u >> %u) ",
+			       bitwise->dreg, bitwise->sreg, bitwise->rshift);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		return offset;
+
+	}
+
 	ret = snprintf(buf, remain, "reg %u = (reg=%u & ",
 		       bitwise->dreg, bitwise->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 64c14466dbd2..83cfdc71a790 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -21,38 +21,72 @@
 
 static int test_ok = 1;
 
-static void print_err(const char *msg)
+static void print_err(const char *test, const char *msg)
 {
 	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
+	printf("\033[31mERROR:\e[0m [%s] %s\n", test, msg);
 }
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
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
+}
 
+static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
+				  struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err("lshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err("lshift", "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err("lshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_LSHIFT) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_LSHIFT))
+		print_err("lshift", "Expr BITWISE_LSHIFT mismatches");
 }
-int main(int argc, char *argv[])
+
+static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
+				  struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err("rshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err("rshift", "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err("rshift", "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_RSHIFT) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_RSHIFT))
+		print_err("rshift", "Expr BITWISE_RSHIFT mismatches");
+}
+
+static void test_bool(void)
 {
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
@@ -66,10 +100,10 @@ int main(int argc, char *argv[])
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
@@ -83,30 +117,148 @@ int main(int argc, char *argv[])
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
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LSHIFT, 13);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("lshift", "parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("lshift", "OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("lshift", "OOM");
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err("lshift", "More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+
+	cmp_nftnl_expr_lshift(rule_a,rule_b);
+
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
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
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_RSHIFT, 17);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("rshift", "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+		print_err("rshift", "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+		print_err("rshift", "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+		print_err("rshift", "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	cmp_nftnl_expr_rshift(rule_a,rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
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

