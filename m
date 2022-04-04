Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiDDMIg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236944AbiDDMI0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127613DDC0
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KZLXTjHiBYDanp4xxjZerTaxMdfU9O/sjCutVCzFHgs=; b=AVlqtCd88amN27mi4HL5c/Bw7U
        77dzebqfoIXPyIxgP5pH6Dve5s51oKXknShPos/+3bXpbJoB0cX9cxDpiYDKN8v2V/F6nE5Xeug/p
        DGQxqbasBY7VhmtZCK5Bahni1oF+wp+vlURAHhQzl8nbNivJd+ZGzRuCnGNji8SgaM/wbmGlGYCAz
        ZXV4hWF+DjHgYMavQ3tN4ZbqPBv5KN5ZlenIm7S7juZ0mPKvonSxSb+UjWd3/fJjiRtJqTHUSrWQ8
        Huk1r/NczmoL/fsHwBa9ioFaUIzYUnMa1TV2tDiQNo/vRfAUS1HChCo+Bip7PqCEjLfzW7tIV8zv+
        U6gnZlug==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTY-007FNA-A7
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 7/9] expr: bitwise: add support for kernel space AND, OR and XOR operations
Date:   Mon,  4 Apr 2022 13:06:21 +0100
Message-Id: <20220404120623.188439-8-jeremy@azazel.net>
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
 src/expr/bitwise.c      | 55 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 6adad4c222a6..be91e2dc58ca 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -129,6 +129,7 @@ enum {
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
 	NFTNL_EXPR_BITWISE_NBITS,
+	NFTNL_EXPR_BITWISE_SREG2,
 };
 
 enum {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index c7428af6adf8..e2ebd83fee0e 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -23,6 +23,7 @@
 
 struct nftnl_expr_bitwise {
 	enum nft_registers	sreg;
+	enum nft_registers	sreg2;
 	enum nft_registers	dreg;
 	enum nft_bitwise_ops	op;
 	unsigned int		len;
@@ -42,6 +43,11 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
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
@@ -60,6 +66,8 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		bitwise->xor.len = data_len;
 		break;
 	case NFTNL_EXPR_BITWISE_DATA:
+		if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+			return -1;
 		memcpy(&bitwise->data.val, data, data_len);
 		bitwise->data.len = data_len;
 		break;
@@ -82,6 +90,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_SREG:
 		*data_len = sizeof(bitwise->sreg);
 		return &bitwise->sreg;
+	case NFTNL_EXPR_BITWISE_SREG2:
+		*data_len = sizeof(bitwise->sreg2);
+		return &bitwise->sreg2;
 	case NFTNL_EXPR_BITWISE_DREG:
 		*data_len = sizeof(bitwise->dreg);
 		return &bitwise->dreg;
@@ -117,6 +128,7 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_BITWISE_SREG:
+	case NFTA_BITWISE_SREG2:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
@@ -143,6 +155,8 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG, htonl(bitwise->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG2, htonl(bitwise->sreg2));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_DREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_DREG, htonl(bitwise->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_OP))
@@ -192,6 +206,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
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
@@ -267,6 +285,31 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
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
@@ -286,6 +329,18 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>",
 							bitwise);
 		break;
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
+		break;
 	}
 
 	return err;
-- 
2.35.1

