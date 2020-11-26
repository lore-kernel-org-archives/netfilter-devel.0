Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390B8C63697
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 10:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10882158C
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 10:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388469AbgKZKtE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 05:49:04 -0500
Received: from correo.us.es ([193.147.175.20]:56160 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbgKZKtE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 05:49:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97A95DA720
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2020 11:48:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88AB8DA730
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2020 11:48:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87B8B17B3A2; Thu, 26 Nov 2020 11:48:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4B0EDA73D;
        Thu, 26 Nov 2020 11:48:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Nov 2020 11:48:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7CB8C42EE38F;
        Thu, 26 Nov 2020 11:48:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libftnl,RFC] src: add infrastructure to infer byteorder from keys
Date:   Thu, 26 Nov 2020 11:48:50 +0100
Message-Id: <20201126104850.30953-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new .byteorder callback to expressions to allow infer
the data byteorder that is placed in registers. Given that keys have a
fixed datatype, this patch tracks register operations to obtain the data
byteorder. This new infrastructure is internal and it is only used by
the nftnl_rule_snprintf() function to make it portable regardless the
endianess.

A few examples after this patch running on x86_64:

netdev
  [ meta load protocol => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ immediate reg 1 0x01020304 ]
  [ payload write reg 1 => 4b @ network header + 12 csum_type 1 csum_off 10 csum_flags 0x1 ]

root@salvia:/home/pablo/devel/scm/git-netfilter/libnftnl# nft --debug=netlink add rule netdev x z ip saddr 1.2.3.4
netdev
  [ meta load protocol => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x01020304 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Phil,

This patch is incomplete. Many expressions are still missing the byteorder.
This is adding minimal infrastructure to "delinearize" expression for printing
on the debug information.

The set infrastructure is also missing, this requires to move the TYPE_
definitions to libnftnl (this is part of existing technical debt) and
add minimal code to "delinearize" the set element again from snprintf
based in the NFTNL_SET_DATATYPE / userdata information of the set
definition.

 include/common.h     | 29 +++++++++++++++++++++++++
 include/data_reg.h   |  3 ++-
 include/expr.h       |  2 +-
 include/expr_ops.h   |  2 ++
 src/expr.c           | 51 ++++++++++++++++++++++++++++++++++++++++++++
 src/expr/bitwise.c   | 36 +++++++++++++++++++++++--------
 src/expr/byteorder.c | 21 ++++++++++++++++++
 src/expr/cmp.c       | 12 ++++++++++-
 src/expr/ct.c        | 14 ++++++++++++
 src/expr/data_reg.c  | 16 ++++++++++----
 src/expr/immediate.c | 18 +++++++++++++---
 src/expr/meta.c      | 18 ++++++++++++++--
 src/expr/payload.c   | 14 ++++++++++++
 src/expr/range.c     | 23 +++++++++++++++-----
 src/rule.c           |  9 +++++++-
 15 files changed, 241 insertions(+), 27 deletions(-)

diff --git a/include/common.h b/include/common.h
index d05a81ad542c..13d709b247f9 100644
--- a/include/common.h
+++ b/include/common.h
@@ -18,4 +18,33 @@ enum nftnl_parse_input {
 	NFTNL_PARSE_FILE,
 };
 
+enum nftnl_byteorder {
+	NFTNL_BYTEORDER_UNKNOWN	= 0,
+	NFTNL_BYTEORDER_HOST,
+	NFTNL_BYTEORDER_NETWORK,
+};
+
+#define NFTNL_CTX_BYTEORDER_MAX_EXPRS	16
+
+struct nftnl_byteorder_ctx {
+	struct {
+		const struct nftnl_expr	*expr;
+		enum nftnl_byteorder	byteorder;
+	} expr[NFT_REG32_15 + 1];
+	struct {
+		uint32_t		reg;
+		struct nftnl_expr	*expr;
+	} pending[NFTNL_CTX_BYTEORDER_MAX_EXPRS];
+	uint32_t			num_pending;
+};
+
+void nftnl_reg_byteorder_set(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+			     enum nftnl_byteorder byteorder);
+enum nftnl_byteorder nftnl_reg_byteorder_get(struct nftnl_byteorder_ctx *ctx,
+					     uint32_t reg);
+void nftnl_reg_byteorder_unknown(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+				 struct nftnl_expr *expr);
+void nftnl_reg_byteorder_resolve(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+				 enum nftnl_byteorder byteorder);
+
 #endif
diff --git a/include/data_reg.h b/include/data_reg.h
index d9578aa47990..718661356e64 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -5,6 +5,7 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <unistd.h>
+#include "common.h"
 
 enum {
 	DATA_NONE,
@@ -28,7 +29,7 @@ union nftnl_data_reg {
 int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
 			    uint32_t output_format, uint32_t flags,
-			    int reg_type);
+			    int reg_type, enum nftnl_byteorder byteorder);
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
diff --git a/include/expr.h b/include/expr.h
index be45e954df5b..50959724492e 100644
--- a/include/expr.h
+++ b/include/expr.h
@@ -6,6 +6,7 @@ struct expr_ops;
 struct nftnl_expr {
 	struct list_head	head;
 	uint32_t		flags;
+	uint32_t		byteorder;
 	struct expr_ops		*ops;
 	uint8_t			data[];
 };
@@ -15,5 +16,4 @@ struct nlmsghdr;
 void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr);
 struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr);
 
-
 #endif
diff --git a/include/expr_ops.h b/include/expr_ops.h
index a7f1b9a6abfd..5f77bfb2b5d6 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -7,6 +7,7 @@
 struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
+struct nftnl_print_ctx;
 
 struct expr_ops {
 	const char *name;
@@ -17,6 +18,7 @@ struct expr_ops {
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
+	void	(*byteorder)(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
 };
 
diff --git a/src/expr.c b/src/expr.c
index ed2f60e1429f..e78e1328d71a 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -298,3 +298,54 @@ int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
 	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
 			     nftnl_expr_do_snprintf);
 }
+
+void nftnl_reg_byteorder_set(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+			     enum nftnl_byteorder byteorder)
+{
+       if (reg > NFT_REG32_15)
+	       return;
+
+       ctx->expr[reg].byteorder = byteorder;
+}
+
+enum nftnl_byteorder nftnl_reg_byteorder_get(struct nftnl_byteorder_ctx *ctx,
+					     uint32_t reg)
+{
+       if (reg > NFT_REG32_15)
+	       return NFTNL_BYTEORDER_UNKNOWN;
+
+       return ctx->expr[reg].byteorder;
+}
+
+void nftnl_reg_byteorder_unknown(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+				 struct nftnl_expr *expr)
+{
+       int k;
+
+       if (reg > NFT_REG32_15)
+	       return;
+
+       k = ctx->num_pending++;
+       if (k >= NFTNL_CTX_BYTEORDER_MAX_EXPRS)
+	       return;
+
+       ctx->pending[k].reg = reg;
+       ctx->pending[k].expr = expr;
+}
+
+void nftnl_reg_byteorder_resolve(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
+				 enum nftnl_byteorder byteorder)
+{
+       struct nftnl_expr *expr;
+       int i;
+
+       for (i = 0; i < ctx->num_pending; i++) {
+	       if (!ctx->pending[i].expr)
+		       continue;
+	       if (ctx->pending[i].reg == reg) {
+		       expr = ctx->pending[i].expr;
+		       expr->byteorder = byteorder;
+		       ctx->pending[i].expr = NULL;
+	       }
+       }
+}
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ba379a84485e..4f48a78e99b8 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -209,9 +209,18 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
+static void
+nftnl_expr_bitwise_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
+{
+	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
+
+	e->byteorder = nftnl_reg_byteorder_get(ctx, bitwise->sreg);
+}
+
 static int
 nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
-				 const struct nftnl_expr_bitwise *bitwise)
+				 const struct nftnl_expr_bitwise *bitwise,
+				 enum nftnl_byteorder byteorder)
 {
 	int remain = size, offset = 0, ret;
 
@@ -220,14 +229,16 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -235,15 +246,18 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 
 static int
 nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
-				  const struct nftnl_expr_bitwise *bitwise)
-{	int remain = size, offset = 0, ret;
+				  const struct nftnl_expr_bitwise *bitwise,
+				  enum nftnl_byteorder byteorder)
+{
+	int remain = size, offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
 		       bitwise->dreg, bitwise->sreg, op);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->data,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ");
@@ -260,13 +274,16 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 
 	switch (bitwise->op) {
 	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise,
+						       e->byteorder);
 		break;
 	case NFT_BITWISE_LSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<",
+							bitwise, e->byteorder);
 		break;
 	case NFT_BITWISE_RSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>",
+							bitwise, e->byteorder);
 		break;
 	}
 
@@ -294,5 +311,6 @@ struct expr_ops expr_ops_bitwise = {
 	.get		= nftnl_expr_bitwise_get,
 	.parse		= nftnl_expr_bitwise_parse,
 	.build		= nftnl_expr_bitwise_build,
+	.byteorder	= nftnl_expr_bitwise_byteorder,
 	.snprintf	= nftnl_expr_bitwise_snprintf,
 };
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index efdfa2b5eca4..66c56b5a597a 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -197,6 +197,26 @@ static inline int nftnl_str2ntoh(const char *op)
 	}
 }
 
+static void nftnl_expr_byteorder_byteorder(struct nftnl_byteorder_ctx *ctx,
+					   struct nftnl_expr *e)
+{
+	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
+	enum nftnl_byteorder bo;
+
+	switch (byteorder->op) {
+	case NFT_BYTEORDER_NTOH:
+		bo = NFTNL_BYTEORDER_HOST;
+		break;
+	case NFT_BYTEORDER_HTON:
+		bo = NFTNL_BYTEORDER_NETWORK;
+		break;
+	default:
+		bo = NFTNL_BYTEORDER_UNKNOWN;
+		break;
+	}
+	nftnl_reg_byteorder_set(ctx, byteorder->dreg, bo);
+}
+
 static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
 						 const struct nftnl_expr *e)
 {
@@ -234,5 +254,6 @@ struct expr_ops expr_ops_byteorder = {
 	.get		= nftnl_expr_byteorder_get,
 	.parse		= nftnl_expr_byteorder_parse,
 	.build		= nftnl_expr_byteorder_build,
+	.byteorder	= nftnl_expr_byteorder_byteorder,
 	.snprintf	= nftnl_expr_byteorder_snprintf,
 };
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 86d7842d0813..893b78304f80 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -176,6 +176,14 @@ static inline int nftnl_str2cmp(const char *op)
 	}
 }
 
+static void
+nftnl_expr_cmp_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
+{
+	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
+
+	e->byteorder = nftnl_reg_byteorder_get(ctx, cmp->sreg);
+}
+
 static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
@@ -187,7 +195,8 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &cmp->data,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      e->byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -216,5 +225,6 @@ struct expr_ops expr_ops_cmp = {
 	.get		= nftnl_expr_cmp_get,
 	.parse		= nftnl_expr_cmp_parse,
 	.build		= nftnl_expr_cmp_build,
+	.byteorder	= nftnl_expr_cmp_byteorder,
 	.snprintf	= nftnl_expr_cmp_snprintf,
 };
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 124de9dd2b33..f1c48fd8fc64 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -222,6 +222,19 @@ static inline int str2ctdir(const char *str, uint8_t *ctdir)
 	return -1;
 }
 
+static void
+nftnl_expr_ct_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
+{
+	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_CT_SREG))
+		nftnl_reg_byteorder_resolve(ctx, ct->sreg, NFTNL_BYTEORDER_HOST);
+	if (e->flags & (1 << NFTNL_EXPR_CT_DREG))
+		nftnl_reg_byteorder_set(ctx, ct->dreg, NFTNL_BYTEORDER_HOST);
+
+	e->byteorder = NFTNL_BYTEORDER_HOST;
+}
+
 static int
 nftnl_expr_ct_snprintf_default(char *buf, size_t size,
 			       const struct nftnl_expr *e)
@@ -273,5 +286,6 @@ struct expr_ops expr_ops_ct = {
 	.get		= nftnl_expr_ct_get,
 	.parse		= nftnl_expr_ct_parse,
 	.build		= nftnl_expr_ct_build,
+	.byteorder	= nftnl_expr_ct_byteorder,
 	.snprintf	= nftnl_expr_ct_snprintf,
 };
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 4e35a799e959..f7de56361999 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -27,12 +27,19 @@
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
 				      const union nftnl_data_reg *reg,
-				      uint32_t flags)
+				      uint32_t flags,
+				      enum nftnl_byteorder byteorder)
 {
 	int remain = size, offset = 0, ret, i;
+	uint32_t value;
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf + offset, remain, "0x%.8x ", reg->val[i]);
+		if (byteorder == NFTNL_BYTEORDER_NETWORK)
+			value = ntohl(reg->val[i]);
+		else
+			value = reg->val[i];
+
+		ret = snprintf(buf + offset, remain, "0x%.8x ", value);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
@@ -60,14 +67,15 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
 			    uint32_t output_format, uint32_t flags,
-			    int reg_type)
+			    int reg_type, enum nftnl_byteorder byteorder)
 {
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
 		case NFTNL_OUTPUT_DEFAULT:
 			return nftnl_data_reg_value_snprintf_default(buf, size,
-								   reg, flags);
+								     reg, flags,
+								     byteorder);
 		case NFTNL_OUTPUT_JSON:
 		case NFTNL_OUTPUT_XML:
 		default:
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 7f34772bd001..718394d4d647 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -183,6 +183,14 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
+static void
+nftnl_expr_immediate_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
+{
+	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
+
+	nftnl_reg_byteorder_unknown(ctx, imm->dreg, e);
+}
+
 static int
 nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 				      const struct nftnl_expr *e,
@@ -196,17 +204,20 @@ nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 
 	if (e->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE);
+					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE,
+					e->byteorder);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT);
+				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT,
+				NFTNL_BYTEORDER_UNKNOWN);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN);
+					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN,
+					NFTNL_BYTEORDER_UNKNOWN);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
@@ -245,5 +256,6 @@ struct expr_ops expr_ops_immediate = {
 	.get		= nftnl_expr_immediate_get,
 	.parse		= nftnl_expr_immediate_parse,
 	.build		= nftnl_expr_immediate_build,
+	.byteorder	= nftnl_expr_immediate_byteorder,
 	.snprintf	= nftnl_expr_immediate_snprintf,
 };
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6ed8ee5645c4..7ab4e551fb26 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -191,6 +191,19 @@ static inline int str2meta_key(const char *str)
 	return -1;
 }
 
+static void nftnl_expr_meta_byteorder(struct nftnl_byteorder_ctx *ctx,
+				      struct nftnl_expr *e)
+{
+	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_META_SREG))
+		nftnl_reg_byteorder_resolve(ctx, meta->sreg, NFTNL_BYTEORDER_HOST);
+	if (e->flags & (1 << NFTNL_EXPR_META_DREG))
+		nftnl_reg_byteorder_set(ctx, meta->dreg, NFTNL_BYTEORDER_HOST);
+
+	e->byteorder = NFTNL_BYTEORDER_HOST;
+}
+
 static int
 nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 				 const struct nftnl_expr *e)
@@ -209,8 +222,8 @@ nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type, uint32_t flags,
+			 const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -231,5 +244,6 @@ struct expr_ops expr_ops_meta = {
 	.get		= nftnl_expr_meta_get,
 	.parse		= nftnl_expr_meta_parse,
 	.build		= nftnl_expr_meta_build,
+	.byteorder	= nftnl_expr_meta_byteorder,
 	.snprintf	= nftnl_expr_meta_snprintf,
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 2192dad5f15d..c6116f0fdedd 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -231,6 +231,19 @@ static inline int nftnl_str2base(const char *base)
 	}
 }
 
+static void
+nftnl_expr_payload_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
+{
+	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
+
+	if (payload->sreg)
+		nftnl_reg_byteorder_resolve(ctx, payload->sreg, NFTNL_BYTEORDER_NETWORK);
+	else
+                nftnl_reg_byteorder_set(ctx, payload->dreg, NFTNL_BYTEORDER_NETWORK);
+
+	e->byteorder = NFTNL_BYTEORDER_NETWORK;
+}
+
 static int
 nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, const struct nftnl_expr *e)
@@ -266,5 +279,6 @@ struct expr_ops expr_ops_payload = {
 	.get		= nftnl_expr_payload_get,
 	.parse		= nftnl_expr_payload_parse,
 	.build		= nftnl_expr_payload_build,
+	.byteorder	= nftnl_expr_payload_byteorder,
 	.snprintf	= nftnl_expr_payload_snprintf,
 };
diff --git a/src/expr/range.c b/src/expr/range.c
index d1d50832a450..eb65d96e921a 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -184,8 +184,16 @@ static inline int nftnl_str2range(const char *op)
 	}
 }
 
+static void nftnl_expr_range_byteorder(struct nftnl_byteorder_ctx *ctx,
+				       struct nftnl_expr *e)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+
+	e->byteorder = nftnl_reg_byteorder_get(ctx, range->sreg);
+}
+
 static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+					    const struct nftnl_expr *e)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -194,12 +202,16 @@ static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
 		       range2str(range->op), range->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_from,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	ret = nftnl_data_reg_snprintf(buf + offset, remain,
+				      &range->data_from,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      e->byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	ret = nftnl_data_reg_snprintf(buf + offset, remain,
+				      &range->data_to,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      e->byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -227,5 +239,6 @@ struct expr_ops expr_ops_range = {
 	.get		= nftnl_expr_range_get,
 	.parse		= nftnl_expr_range_parse,
 	.build		= nftnl_expr_range_build,
+	.byteorder	= nftnl_expr_range_byteorder,
 	.snprintf	= nftnl_expr_range_snprintf,
 };
diff --git a/src/rule.c b/src/rule.c
index 480afc8ffc1b..b9d4604e0c73 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -549,8 +549,9 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 				       const struct nftnl_rule *r,
 				       uint32_t type, uint32_t flags)
 {
-	struct nftnl_expr *expr;
 	int ret, remain = size, offset = 0, i;
+	struct nftnl_byteorder_ctx ctx = {};
+	struct nftnl_expr *expr;
 
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
 		ret = snprintf(buf + offset, remain, "%s ",
@@ -594,6 +595,12 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 	ret = snprintf(buf + offset, remain, "\n");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	list_for_each_entry(expr, &r->expr_list, head) {
+		if (!expr->ops->byteorder)
+			continue;
+		expr->ops->byteorder(&ctx, expr);
+	}
+
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-- 
2.20.1

