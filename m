Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C77C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiDDMI1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5B43DA7B
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I2bzdxL+k6W681H/Dr3y/gUjY9mgCEGFw8dlPh+wGxc=; b=ZU15z2VzOTMIsFAGtS3GaAxAuO
        LwZFHI2QtzsCSEytimDDlZs8sieytJVkqXrAICckFEdL/7qz4aJJd8WJYmoutGtvQNc0Xu0BCSZO5
        v5qMNcLBKVOcB3Hbxce5afR1i2DxkFXEvT6sZYnbv1IG4W2CfwW+YCt6AqPgpFGB7vY3dtbB/v+Jl
        QRqzrgyA6x0WsRy8dAD4lz7d1ijqAq4XJerHbDNS7kmj0ylcG8mUMbXlxgYjt0L8TNpdZXhKf5hv2
        gvXdwXfq2rd6XRHYzqcKKoH/KNsL1JlLSMLFqgnYiJDHiZQJLiYlX0/9ErWDR6KN8IE8ayf1NhaoZ
        3r0ythBg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTX-007FNA-QM
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 3/9] expr: bitwise: pass bit-length to and from the kernel
Date:   Mon,  4 Apr 2022 13:06:17 +0100
Message-Id: <20220404120623.188439-4-jeremy@azazel.net>
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

The kernel can now keep track of the bit-length of bitwise operations in
order to help user space eliminate generated operations during
delinearization.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h       |  1 +
 src/expr/bitwise.c            | 15 +++++++++++++++
 tests/nft-expr_bitwise-test.c | 12 ++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 00c63ab9d19b..6adad4c222a6 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -128,6 +128,7 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	NFTNL_EXPR_BITWISE_NBITS,
 };
 
 enum {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index d0c7827eacec..3fa627d7905d 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -29,6 +29,7 @@ struct nftnl_expr_bitwise {
 	union nftnl_data_reg	mask;
 	union nftnl_data_reg	xor;
 	union nftnl_data_reg	data;
+	unsigned int		nbits;
 };
 
 static int
@@ -62,6 +63,9 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->data.val, data, data_len);
 		bitwise->data.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_NBITS:
+		memcpy(&bitwise->nbits, data, sizeof(bitwise->nbits));
+		break;
 	default:
 		return -1;
 	}
@@ -96,6 +100,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_DATA:
 		*data_len = bitwise->data.len;
 		return &bitwise->data.val;
+	case NFTNL_EXPR_BITWISE_NBITS:
+		*data_len = sizeof(bitwise->nbits);
+		return &bitwise->nbits;
 	}
 	return NULL;
 }
@@ -113,6 +120,7 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
+	case NFTA_BITWISE_NBITS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -141,6 +149,9 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_OP, htonl(bitwise->op));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_LEN))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_LEN, htonl(bitwise->len));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_NBITS))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_NBITS,
+				 htonl(bitwise->nbits));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_MASK)) {
 		struct nlattr *nest;
 
@@ -205,6 +216,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->data, tb[NFTA_BITWISE_DATA], NULL);
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_DATA);
 	}
+	if (tb[NFTA_BITWISE_NBITS]) {
+		bitwise->nbits = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_NBITS]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_NBITS);
+	}
 
 	return ret;
 }
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index f134728fdd86..9d01376a69bd 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -45,6 +45,9 @@ static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
 		print_err("bool", "Expr BITWISE_LEN mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_NBITS) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_NBITS))
+		print_err("bool", "Expr BITWISE_NBITS mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
 	if (maska != maskb)
@@ -72,6 +75,9 @@ static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
 		print_err("lshift", "Expr BITWISE_LEN mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_NBITS) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_NBITS))
+		print_err("lshift", "Expr BITWISE_NBITS mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
 	if (data_a != data_b)
@@ -95,6 +101,9 @@ static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
 		print_err("rshift", "Expr BITWISE_LEN mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_NBITS) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_NBITS))
+		print_err("rshift", "Expr BITWISE_NBITS mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
 	if (data_a != data_b)
@@ -124,6 +133,7 @@ static void test_bool(void)
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_NBITS, 0x11223344);
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_MASK, &mask, sizeof(mask));
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(xor));
 
@@ -179,6 +189,7 @@ static void test_lshift(void)
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_LSHIFT);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_NBITS, 0x11223344);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 13);
 
 	nftnl_rule_add_expr(a, ex);
@@ -233,6 +244,7 @@ static void test_rshift(void)
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_RSHIFT);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_NBITS, 0x11223344);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 17);
 
 	nftnl_rule_add_expr(a, ex);
-- 
2.35.1

