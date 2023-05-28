Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A73DC7EE39
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjE1N4Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjE1N4U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:56:20 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E91D8
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1kGfJ5xQfZaknTJPEvjHVAWSAjzTIxXJJ55SlP5VrE8=; b=PnUek/rFeEdTzVS8v7TF4BU0x+
        gn8eUCVR/XS1pwF3oXzg9aDXFChGzGOX4D02LwiE3kuLtaaXPXmwh9mV4IX2QuTA/vfsJujA0H1t+
        afuPH9NVRc0e1wTFMLkPdpIGsH0DnMmrCC8nHplCCdGwjvDrI3Y0e2/GuPM6WbP8DIjpS4QMNiLTk
        aJJp4Q7Izu27o5msNG1zGYa2+yj1BLYr+XqHQp6sZoGpQOa5JiI7NHE/pBfR45E8AbS/f6T9BJnaX
        7V7UEWN6GicaaBD6P14Q+ppOyd8uqEAJJsNLX5e5uOQoQSEBMBvoPo5YlUhP8Lanfd8uiRrY1giEA
        Rw32/LIA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3GsY-008We9-DD
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:56:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v3 3/5] expr: bitwise: add support for kernel space AND, OR and XOR operations
Date:   Sun, 28 May 2023 14:55:59 +0100
Message-Id: <20230528135601.1218337-4-jeremy@azazel.net>
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

Hitherto, the kernel has only supported boolean operations of the form:

  dst = (src & mask) ^ xor

where `src` is held in a register, and `mask` and `xor` are immediate
values.  User space has converted AND, OR and XOR operations to this
form, and so one operand has had to be immediate.  The kernel now
supports performing AND, OR and XOR operations directly, on one register
and an immediate value or on two registers, so we make that support
available to user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h |  1 +
 src/expr/bitwise.c      | 61 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9873228dd794..f2d79c8adbef 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -128,6 +128,7 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	NFTNL_EXPR_BITWISE_SREG2,
 };
 
 enum {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 4cac017736fe..06aed46a0e37 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -23,6 +23,7 @@
 
 struct nftnl_expr_bitwise {
 	enum nft_registers	sreg;
+	enum nft_registers	sreg2;
 	enum nft_registers	dreg;
 	enum nft_bitwise_ops	op;
 	unsigned int		len;
@@ -41,6 +42,11 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_SREG:
 		memcpy(&bitwise->sreg, data, sizeof(bitwise->sreg));
 		break;
+	case NFTNL_EXPR_BITWISE_SREG2:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_DATA))
+			return -1;
+		memcpy(&bitwise->sreg2, data, sizeof(bitwise->sreg2));
+		break;
 	case NFTNL_EXPR_BITWISE_DREG:
 		memcpy(&bitwise->dreg, data, sizeof(bitwise->dreg));
 		break;
@@ -59,6 +65,8 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		bitwise->xor.len = data_len;
 		break;
 	case NFTNL_EXPR_BITWISE_DATA:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+			return -1;
 		memcpy(&bitwise->data.val, data, data_len);
 		bitwise->data.len = data_len;
 		break;
@@ -78,6 +86,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_SREG:
 		*data_len = sizeof(bitwise->sreg);
 		return &bitwise->sreg;
+	case NFTNL_EXPR_BITWISE_SREG2:
+		*data_len = sizeof(bitwise->sreg2);
+		return &bitwise->sreg2;
 	case NFTNL_EXPR_BITWISE_DREG:
 		*data_len = sizeof(bitwise->dreg);
 		return &bitwise->dreg;
@@ -110,6 +121,7 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_BITWISE_SREG:
+	case NFTA_BITWISE_SREG2:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
@@ -135,6 +147,8 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG, htonl(bitwise->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG2, htonl(bitwise->sreg2));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_DREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_DREG, htonl(bitwise->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_OP))
@@ -181,6 +195,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		bitwise->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_SREG);
 	}
+	if (tb[NFTA_BITWISE_SREG2]) {
+		bitwise->sreg2 = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_SREG2]));
+		e->flags |= (1 << NFTNL_EXPR_BITWISE_SREG2);
+	}
 	if (tb[NFTA_BITWISE_DREG]) {
 		bitwise->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_DREG);
@@ -252,6 +270,31 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
 	return offset;
 }
 
+static int
+nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain, const char *op,
+				 const struct nftnl_expr *e,
+				 const struct nftnl_expr_bitwise *bitwise)
+{
+	int offset = 0, ret;
+
+	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
+		       bitwise->dreg, bitwise->sreg, op);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+		ret = snprintf(buf + offset, remain, "reg %u ", bitwise->sreg2);
+	else
+		ret = nftnl_data_reg_snprintf(buf + offset, remain,
+					      &bitwise->data,
+					      0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = snprintf(buf + offset, remain, ") ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	return offset;
+}
+
 static int
 nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 			    uint32_t flags, const struct nftnl_expr *e)
@@ -264,10 +307,24 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 		err = nftnl_expr_bitwise_snprintf_mask_xor(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<",
+							bitwise);
 		break;
 	case NFT_BITWISE_RSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>",
+							bitwise);
+		break;
+	case NFT_BITWISE_AND:
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, "&", e,
+						       bitwise);
+		break;
+	case NFT_BITWISE_OR:
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, "|", e,
+						       bitwise);
+		break;
+	case NFT_BITWISE_XOR:
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, "^", e,
+						       bitwise);
 		break;
 	}
 
-- 
2.39.2

