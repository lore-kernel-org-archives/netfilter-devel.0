Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789B1C33CB8
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 470B92072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="I0OO0deM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgAQU6M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:12 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55994 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729795AbgAQU6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AtOeEw764Nfs16RteGAf5WCfBKD9ZY/Ok7g1YFS5OqM=; b=I0OO0deMS4fo4+rmzpOBPU9EyH
        Muajy90E/48evTrJkuEAi75Olfg9Mfu09PIWI2MQzf2ZCuCaGGDLECw7BWg57K9CBTFIc9duL2RR0
        60AwWvOPehh4IfcVFFhZWMESYNhmuw+gTfPGC8ek1t9/LI/Q5RB8UKPVOqK+jiCsBDKcoSf7At2jO
        CnPRxeCjGbPhhFWBp7qvpksxr73Kw0lcvFo9O8XSIR8GL+SRgt0B6waJyuIHgtkx+oKFlCISEpCnW
        j/2Jc5jkqdD4a9u1cgCYU001hzq1Hkl4R+wn8ilA6xaaTsaNUw0K3Z+s0dCAqDS1y3+ICE8LoGbLz
        NGIWbY1w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYh0-0004I2-Bl
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 5/6] bitwise: add support for new netlink attributes.
Date:   Fri, 17 Jan 2020 20:58:07 +0000
Message-Id: <20200117205808.172194-6-jeremy@azazel.net>
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

Add code to set and get the new op and data attributes.  The existing
boolean bitwise expressions will only use the op attribute.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c            | 47 ++++++++++++++++++++++++++++++++++-
 tests/nft-expr_bitwise-test.c |  4 +++
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 472bf59f7ad5..6ea39fbbe2ee 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -24,9 +24,11 @@
 struct nftnl_expr_bitwise {
 	enum nft_registers	sreg;
 	enum nft_registers	dreg;
+	enum nft_bitwise_ops	op;
 	unsigned int		len;
 	union nftnl_data_reg	mask;
 	union nftnl_data_reg	xor;
+	union nftnl_data_reg	data;
 };
 
 static int
@@ -42,6 +44,9 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_DREG:
 		memcpy(&bitwise->dreg, data, sizeof(bitwise->dreg));
 		break;
+	case NFTNL_EXPR_BITWISE_OP:
+		memcpy(&bitwise->op, data, sizeof(bitwise->op));
+		break;
 	case NFTNL_EXPR_BITWISE_LEN:
 		memcpy(&bitwise->len, data, sizeof(bitwise->len));
 		break;
@@ -53,6 +58,10 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->xor.val, data, data_len);
 		bitwise->xor.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_DATA:
+		memcpy(&bitwise->data.val, data, data_len);
+		bitwise->data.len = data_len;
+		break;
 	default:
 		return -1;
 	}
@@ -72,6 +81,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_DREG:
 		*data_len = sizeof(bitwise->dreg);
 		return &bitwise->dreg;
+	case NFTNL_EXPR_BITWISE_OP:
+		*data_len = sizeof(bitwise->op);
+		return &bitwise->op;
 	case NFTNL_EXPR_BITWISE_LEN:
 		*data_len = sizeof(bitwise->len);
 		return &bitwise->len;
@@ -81,6 +93,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_XOR:
 		*data_len = bitwise->xor.len;
 		return &bitwise->xor.val;
+	case NFTNL_EXPR_BITWISE_DATA:
+		*data_len = bitwise->data.len;
+		return &bitwise->data.val;
 	}
 	return NULL;
 }
@@ -96,12 +111,14 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_BITWISE_SREG:
 	case NFTA_BITWISE_DREG:
+	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
 	case NFTA_BITWISE_MASK:
 	case NFTA_BITWISE_XOR:
+	case NFTA_BITWISE_DATA:
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
@@ -120,6 +137,8 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG, htonl(bitwise->sreg));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_DREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_DREG, htonl(bitwise->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_OP))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_OP, htonl(bitwise->op));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_LEN))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_LEN, htonl(bitwise->len));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_MASK)) {
@@ -138,6 +157,14 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 			     bitwise->xor.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_DATA)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_BITWISE_DATA);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, bitwise->data.len,
+				bitwise->data.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
 }
 
 static int
@@ -158,6 +185,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		bitwise->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_DREG);
 	}
+	if (tb[NFTA_BITWISE_OP]) {
+		bitwise->op = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_OP]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_OP);
+	}
 	if (tb[NFTA_BITWISE_LEN]) {
 		bitwise->len = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_LEN]));
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_LEN);
@@ -170,6 +201,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->xor, tb[NFTA_BITWISE_XOR], NULL);
 		e->flags |= (1 << NFTA_BITWISE_XOR);
 	}
+	if (tb[NFTA_BITWISE_DATA]) {
+		ret = nftnl_parse_data(&bitwise->data, tb[NFTA_BITWISE_DATA], NULL);
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_DATA);
+	}
 
 	return ret;
 }
@@ -202,8 +237,18 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 					       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
+	int err = -1;
+
+	switch (bitwise->op) {
+	case NFT_BITWISE_BOOL:
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+		break;
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		break;
+	}
 
-	return nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+	return err;
 }
 
 static int
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index e37d85832072..41c0af435283 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -39,6 +39,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
 		print_err("Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err("Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
 		print_err("Expr BITWISE_DREG mismatches");
@@ -73,6 +76,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_MASK, &mask, sizeof(mask));
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(xor));
-- 
2.24.1

