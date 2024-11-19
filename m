Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103501D0174
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030975; cv=none; b=kF/K725EGAThGwS5sVwdRjBb1yb+qiRl8QsgyhVwDSaSkFSJaPf8wlWoweKMaSkP5t2ibHgnH9Sa9VuwOzjVD08e3uEKXYrH1l/UAho6M7oUD0kVwzZoHjlTHwU6sSS/PtRsdIObZ2N1aAcCg8deg0/SueXXdL6hHbjw+2L8hEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030975; c=relaxed/simple;
	bh=itRAIvMgrZVYohe4N2aLBxEWXIizi7M9VQfVPXc7Qyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NjzsNPrWz/k5wbwAzUUKzvn+U3H5omOoPvhl1pCifenShC8SJNX3pqnUERvovK0FQnfTzPH/MUI2L88g60omXcXQQm7sU17Cokfel8JBiZzk/zdi47PK6joCdEGJAITQrASCJxHYUmhXxqIFbawpZCEwiNsL4w0RuHYfEWEnZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl,v2 3/5] expr: bitwise: add support for kernel space AND, OR and XOR operations
Date: Tue, 19 Nov 2024 16:42:43 +0100
Message-Id: <20241119154245.442961-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241119154245.442961-1-pablo@netfilter.org>
References: <20241119154245.442961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

Hitherto, the kernel has only supported boolean operations of the form:

  dst = (src & mask) ^ xor

where `src` is held in a register, and `mask` and `xor` are immediate
values.  User space has converted AND, OR and XOR operations to this
form, and so one operand has had to be immediate.  The kernel now
supports performing AND, OR and XOR operations directly, on one register
and an immediate value or on two registers, so we make that support
available to user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h |  1 +
 src/expr/bitwise.c      | 57 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index fba121062244..1c07b54139a5 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -139,6 +139,7 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	NFTNL_EXPR_BITWISE_SREG2,
 	__NFTNL_EXPR_BITWISE_MAX
 };
 
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9385219a38b5..cac47a550099 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -19,6 +19,7 @@
 
 struct nftnl_expr_bitwise {
 	enum nft_registers	sreg;
+	enum nft_registers	sreg2;
 	enum nft_registers	dreg;
 	enum nft_bitwise_ops	op;
 	unsigned int		len;
@@ -37,6 +38,9 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_SREG:
 		memcpy(&bitwise->sreg, data, data_len);
 		break;
+	case NFTNL_EXPR_BITWISE_SREG2:
+		memcpy(&bitwise->sreg2, data, sizeof(bitwise->sreg2));
+		break;
 	case NFTNL_EXPR_BITWISE_DREG:
 		memcpy(&bitwise->dreg, data, data_len);
 		break;
@@ -66,6 +70,9 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_SREG:
 		*data_len = sizeof(bitwise->sreg);
 		return &bitwise->sreg;
+	case NFTNL_EXPR_BITWISE_SREG2:
+		*data_len = sizeof(bitwise->sreg2);
+		return &bitwise->sreg2;
 	case NFTNL_EXPR_BITWISE_DREG:
 		*data_len = sizeof(bitwise->dreg);
 		return &bitwise->dreg;
@@ -98,6 +105,7 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_BITWISE_SREG:
+	case NFTA_BITWISE_SREG2:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
@@ -123,6 +131,8 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG, htonl(bitwise->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG2))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG2, htonl(bitwise->sreg2));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_DREG))
 		mnl_attr_put_u32(nlh, NFTA_BITWISE_DREG, htonl(bitwise->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_OP))
@@ -169,6 +179,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
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
@@ -240,6 +254,31 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
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
@@ -252,10 +291,24 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
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
2.30.2

