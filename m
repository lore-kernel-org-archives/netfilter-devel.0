Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F2BC5519F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 13:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8244E206E5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 13:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgKYNcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 08:32:06 -0500
Received: from correo.us.es ([193.147.175.20]:38456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKYNcF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 08:32:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 874582EFEA2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2020 14:31:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 602F7FC5E6
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2020 14:31:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 55A55FC5E4; Wed, 25 Nov 2020 14:31:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92667FC5E6;
        Wed, 25 Nov 2020 14:31:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Nov 2020 14:31:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 64EF942EE38F;
        Wed, 25 Nov 2020 14:31:51 +0100 (CET)
Date:   Wed, 25 Nov 2020 14:31:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Stabilize
 nft-only/0009-needless-bitwise_0
Message-ID: <20201125133151.GA28996@salvia>
References: <20201120175757.8063-1-phil@nwl.cc>
 <20201120185000.GA17769@salvia>
 <20201120193723.GN11766@orbyte.nwl.cc>
 <20201121121154.GA21180@salvia>
 <20201123001321.GQ11766@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20201123001321.GQ11766@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Nov 23, 2020 at 01:13:21AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Sat, Nov 21, 2020 at 01:11:54PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Nov 20, 2020 at 08:37:23PM +0100, Phil Sutter wrote:
> > > Hi,
> > > 
> > > On Fri, Nov 20, 2020 at 07:50:00PM +0100, Pablo Neira Ayuso wrote:
> > > > On Fri, Nov 20, 2020 at 06:57:57PM +0100, Phil Sutter wrote:
> > > > > Netlink debug output varies depending on host's endianness and therefore
> > > > > the test fails on Big Endian machines. Since for the sake of asserting
> > > > > no needless bitwise expressions in output the actual data values are not
> > > > > relevant, simply crop the output to just the expression names.
> > > > 
> > > > Probably we can fix this in libnftnl before we apply patches like this
> > > > to nft as well?
> > > 
> > > You're right, ignoring the problems in nft testsuite is pretty
> > > inconsistent. OTOH this is the first test that breaks iptables testsuite
> > > on Big Endian while nft testsuite is entirely broken. ;)
> > 
> > Do you think we can fix this from the testsuite site? It would require
> > to replicate payload files. The snprintf printing is used for
> > debugging only at this stage. That would fix nft and this specific case.
> > 
> > > I had a look at libnftnl and it seems like even kernel support is needed
> > > to carry the endianness info from input to output. IMHO data should be
> > > in a consistent format in netlink messages, but I fear we can't change
> > > this anymore. I tried to print the data byte-by-byte, but we obviously
> > > still get problems with any data in host byte order. Do you see an
> > > easier way to fix this than adding extra info to all expressions
> > > containing data?
> > 
> > Probably we can make assumptions based on context, such as payload
> > expression always express things in network byte order, and annotate
> > that such register stores something in network byteorder. For meta,
> > assume host byte order. Unless there is an explicit byteorder
> > expression.
> 
> I like this simple approach, but it's not easy to implement: libnftnl
> doesn't know about other expressions, so 'cmp' for instance doesn't know
> which expression stored data in reg 1 and therefore can't deduce the
> likely endianness of its stored data.
> 
> Any idea how to solve that?

Probably tracking endianess like this? See attached patch. Then,
default to network byteorder in all cases when printing.

We know the key endianess for meta, ct, ... this allows to annotate
this information on the register.

For "meta mark set 10", the immediate expression is used which comes
_before_ the "meta mark" that provides the endianness information,
this still needs to be fixed somehow.

Note also that this patch sets host byteorder for all ct keys, which
is not correct. We should set the endianess based on the key.

We'll have to fix nft tests after this too.

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="libnftnl-track-byteorder.patch"

diff --git a/include/common.h b/include/common.h
index d05a81ad542c..26cfad8e8858 100644
--- a/include/common.h
+++ b/include/common.h
@@ -18,4 +18,19 @@ enum nftnl_parse_input {
 	NFTNL_PARSE_FILE,
 };
 
+enum nftnl_byteorder {
+	NFTNL_BYTEORDER_UNSET	= 0,
+	NFTNL_BYTEORDER_HOST,
+	NFTNL_BYTEORDER_NETWORK,
+};
+
+struct nftnl_print_ctx {
+	enum nftnl_byteorder byteorder[NFT_REG32_15 + 1];
+};
+
+void nftnl_print_ctx_set(struct nftnl_print_ctx *ctx, uint32_t reg,
+			 enum nftnl_byteorder byteorder);
+enum nftnl_byteorder nftnl_print_ctx_get(struct nftnl_print_ctx *ctx,
+					 uint32_t reg);
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
index be45e954df5b..a30da9e64e41 100644
--- a/include/expr.h
+++ b/include/expr.h
@@ -14,6 +14,8 @@ struct nlmsghdr;
 
 void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr);
 struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr);
-
+int __nftnl_expr_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			  const struct nftnl_expr *expr,
+			  uint32_t type, uint32_t flags);
 
 #endif
diff --git a/include/expr_ops.h b/include/expr_ops.h
index a7f1b9a6abfd..ae71b1659c5a 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -7,6 +7,7 @@
 struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
+struct nftnl_print_ctx;
 
 struct expr_ops {
 	const char *name;
@@ -17,7 +18,7 @@ struct expr_ops {
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
-	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
+	int	(*snprintf)(struct nftnl_print_ctx *ctx, char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
 };
 
 struct expr_ops *nftnl_expr_ops_lookup(const char *name);
diff --git a/src/expr.c b/src/expr.c
index ed2f60e1429f..377126bb6a9f 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -266,12 +266,12 @@ err1:
 	return NULL;
 }
 
-EXPORT_SYMBOL(nftnl_expr_snprintf);
-int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
-			uint32_t type, uint32_t flags)
+int __nftnl_expr_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			  const struct nftnl_expr *expr,
+			  uint32_t type, uint32_t flags)
 {
-	int ret;
 	unsigned int offset = 0, remain = size;
+	int ret;
 
 	if (size)
 		buf[0] = '\0';
@@ -279,12 +279,21 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 	if (!expr->ops->snprintf)
 		return 0;
 
-	ret = expr->ops->snprintf(buf + offset, remain, type, flags, expr);
+	ret = expr->ops->snprintf(ctx, buf + offset, remain, type, flags, expr);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_expr_snprintf);
+int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
+			uint32_t type, uint32_t flags)
+{
+	struct nftnl_print_ctx ctx = {};
+
+	return __nftnl_expr_snprintf(&ctx, buf, size, expr, type, flags);
+}
+
 static int nftnl_expr_do_snprintf(char *buf, size_t size, const void *e,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
 {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ba379a84485e..148eb0b2cfac 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -210,40 +210,51 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
+nftnl_expr_bitwise_snprintf_bool(struct nftnl_print_ctx *ctx,
+				 char *buf, size_t size,
 				 const struct nftnl_expr_bitwise *bitwise)
 {
 	int remain = size, offset = 0, ret;
+	enum nftnl_byteorder byteorder;
 
 	ret = snprintf(buf, remain, "reg %u = ( reg %u & ",
 		       bitwise->dreg, bitwise->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	byteorder = nftnl_print_ctx_get(ctx, bitwise->sreg);
+
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
 }
 
 static int
-nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
+nftnl_expr_bitwise_snprintf_shift(struct nftnl_print_ctx *ctx,
+				  char *buf, size_t size, const char *op,
 				  const struct nftnl_expr_bitwise *bitwise)
 {	int remain = size, offset = 0, ret;
+	enum nftnl_byteorder byteorder;
 
 	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
 		       bitwise->dreg, bitwise->sreg, op);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	byteorder = nftnl_print_ctx_get(ctx, bitwise->sreg);
+
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->data,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ");
@@ -252,7 +263,8 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
 	return offset;
 }
 
-static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
+static int nftnl_expr_bitwise_snprintf_default(struct nftnl_print_ctx *ctx,
+					       char *buf, size_t size,
 					       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
@@ -260,13 +272,13 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 
 	switch (bitwise->op) {
 	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+		err = nftnl_expr_bitwise_snprintf_bool(ctx, buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(ctx, buf, size, "<<", bitwise);
 		break;
 	case NFT_BITWISE_RSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(ctx, buf, size, ">>", bitwise);
 		break;
 	}
 
@@ -274,12 +286,13 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
-			    uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_bitwise_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			    uint32_t type, uint32_t flags,
+			    const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_bitwise_snprintf_default(buf, size, e);
+		return nftnl_expr_bitwise_snprintf_default(ctx, buf, size, e);
 	default:
 		break;
 	}
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index efdfa2b5eca4..7b115f3b1ab7 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -197,11 +197,26 @@ static inline int nftnl_str2ntoh(const char *op)
 	}
 }
 
-static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
+static int nftnl_expr_byteorder_snprintf_default(struct nftnl_print_ctx *ctx,
+						 char *buf, size_t size,
 						 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
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
+		bo = NFTNL_BYTEORDER_UNSET;
+		break;
+	}
+	nftnl_print_ctx_set(ctx, byteorder->dreg, bo);
 
 	ret = snprintf(buf, remain, "reg %u = %s(reg %u, %u, %u) ",
 		       byteorder->dreg, bo2str(byteorder->op),
@@ -212,12 +227,13 @@ static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
+nftnl_expr_byteorder_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+			      size_t size, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_byteorder_snprintf_default(buf, size, e);
+		return nftnl_expr_byteorder_snprintf_default(ctx, buf, size, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 86d7842d0813..a6077a24dbab 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -176,30 +176,36 @@ static inline int nftnl_str2cmp(const char *op)
 	}
 }
 
-static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
+static int nftnl_expr_cmp_snprintf_default(struct nftnl_print_ctx *ctx,
+					   char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
+	enum nftnl_byteorder byteorder;
 
 	ret = snprintf(buf, remain, "%s reg %u ",
 		       cmp2str(cmp->op), cmp->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	byteorder = nftnl_print_ctx_get(ctx, cmp->sreg);
+
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &cmp->data,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
 
 static int
-nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_cmp_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			uint32_t type, uint32_t flags,
+			const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_cmp_snprintf_default(buf, size, e);
+		return nftnl_expr_cmp_snprintf_default(ctx, buf, size, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 53af93bd8db9..91141aca890b 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -126,9 +126,10 @@ static int nftnl_expr_connlimit_snprintf_default(char *buf, size_t len,
 			connlimit->count, connlimit->flags);
 }
 
-static int nftnl_expr_connlimit_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_expr *e)
+static int nftnl_expr_connlimit_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+					 size_t len, uint32_t type,
+					 uint32_t flags,
+					 const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 89a602e0dcb6..2f777bb26356 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -124,7 +124,8 @@ static int nftnl_expr_counter_snprintf_default(char *buf, size_t len,
 			ctr->pkts, ctr->bytes);
 }
 
-static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
+static int nftnl_expr_counter_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+				       size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_expr *e)
 {
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 124de9dd2b33..87c5934fed46 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -223,19 +223,21 @@ static inline int str2ctdir(const char *str, uint8_t *ctdir)
 }
 
 static int
-nftnl_expr_ct_snprintf_default(char *buf, size_t size,
-			       const struct nftnl_expr *e)
+nftnl_expr_ct_snprintf_default(struct nftnl_print_ctx *ctx, char *buf,
+			       size_t size, const struct nftnl_expr *e)
 {
 	int ret, remain = size, offset = 0;
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG)) {
+		nftnl_print_ctx_set(ctx, ct->sreg, NFTNL_BYTEORDER_HOST);
 		ret = snprintf(buf, size, "set %s with reg %u ",
 				ctkey2str(ct->key), ct->sreg);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_DREG)) {
+		nftnl_print_ctx_set(ctx, ct->dreg, NFTNL_BYTEORDER_HOST);
 		ret = snprintf(buf, remain, "load %s => reg %u ",
 			       ctkey2str(ct->key), ct->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -251,12 +253,13 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_ct_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+		       uint32_t type, uint32_t flags,
+		       const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_ct_snprintf_default(buf, len, e);
+		return nftnl_expr_ct_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 4e35a799e959..2cfe15ddac01 100644
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
+		if (byteorder == NFTNL_BYTEORDER_HOST)
+			value = htonl(reg->val[i]);
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
diff --git a/src/expr/dup.c b/src/expr/dup.c
index ac398394aed0..784983d7e310 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -131,7 +131,8 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
+static int nftnl_expr_dup_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+				   size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 91dbea930715..cfa7b6dbd2cd 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -258,8 +258,9 @@ nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_dynset_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index e5f714b07366..82e44f2eea96 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -254,8 +254,9 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_exthdr_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 9475af404738..aaef241213b4 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -191,8 +191,9 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_fib_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_fib_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			uint32_t type, uint32_t flags,
+			const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 6ccec9a13396..a3b82eff2205 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -104,7 +104,8 @@ static int nftnl_expr_flow_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_expr_flow_snprintf(char *buf, size_t size, uint32_t type,
+static int nftnl_expr_flow_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+				    size_t size, uint32_t type,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
 	switch(type) {
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 2ec63c16dfe6..b452b0234cc1 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -151,7 +151,8 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
+static int nftnl_expr_fwd_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+				   size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 2c801d28661f..95892f8b8823 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -219,8 +219,9 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_hash_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			 uint32_t type, uint32_t flags,
+			 const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 7f34772bd001..4f2c6f69d016 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -184,29 +184,33 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
+nftnl_expr_immediate_snprintf_default(struct nftnl_print_ctx *ctx,
+				      char *buf, size_t len,
 				      const struct nftnl_expr *e,
 				      uint32_t flags)
 {
-	int remain = len, offset = 0, ret;
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
+	int remain = len, offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u ", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE);
+					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE,
+					NFTNL_BYTEORDER_UNSET);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT);
+				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT,
+				NFTNL_BYTEORDER_UNSET);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN);
+					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN,
+					NFTNL_BYTEORDER_UNSET);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
@@ -214,12 +218,13 @@ nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
+nftnl_expr_immediate_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+			      size_t len, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_immediate_snprintf_default(buf, len, e, flags);
+		return nftnl_expr_immediate_snprintf_default(ctx, buf, len, e, flags);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5872e276dbb8..75194709815b 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -194,8 +194,9 @@ static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_limit_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			  uint32_t type, uint32_t flags,
+			  const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/log.c b/src/expr/log.c
index bbe43d2dc6bc..bc10a1e60846 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -237,8 +237,9 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_log_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			uint32_t type, uint32_t flags,
+			const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index a495ac0fdcfc..12d368f1d72d 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -168,7 +168,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
+nftnl_expr_lookup_snprintf_default(struct nftnl_print_ctx *ctx,
+				   char *buf, size_t size,
 				   const struct nftnl_expr *e)
 {
 	int remain = size, offset = 0, ret;
@@ -191,12 +192,13 @@ nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_lookup_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_lookup_snprintf_default(buf, size, e);
+		return nftnl_expr_lookup_snprintf_default(ctx, buf, size, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 622ba282ff16..07abb0401405 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -151,7 +151,8 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
+static int nftnl_expr_masq_snprintf(struct nftnl_print_ctx *ctx, char *buf,
+				    size_t len, uint32_t type,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
diff --git a/src/expr/match.c b/src/expr/match.c
index 4fa74b2da893..bb224aeb58dc 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -165,8 +165,9 @@ static int nftnl_expr_match_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_match_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			  uint32_t type, uint32_t flags,
+			  const struct nftnl_expr *e)
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6ed8ee5645c4..692c095b5541 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -192,16 +192,18 @@ static inline int str2meta_key(const char *str)
 }
 
 static int
-nftnl_expr_meta_snprintf_default(char *buf, size_t len,
-				 const struct nftnl_expr *e)
+nftnl_expr_meta_snprintf_default(struct nftnl_print_ctx *ctx, char *buf,
+				 size_t len, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_META_SREG)) {
+		nftnl_print_ctx_set(ctx, meta->sreg, NFTNL_BYTEORDER_HOST);
 		return snprintf(buf, len, "set %s with reg %u ",
 				meta_key2str(meta->key), meta->sreg);
 	}
 	if (e->flags & (1 << NFTNL_EXPR_META_DREG)) {
+		nftnl_print_ctx_set(ctx, meta->dreg, NFTNL_BYTEORDER_HOST);
 		return snprintf(buf, len, "load %s => reg %u ",
 				meta_key2str(meta->key), meta->dreg);
 	}
@@ -209,12 +211,13 @@ nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_meta_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			 uint32_t type, uint32_t flags,
+			 const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_meta_snprintf_default(buf, len, e);
+		return nftnl_expr_meta_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 408521626d89..b9db070e2ff7 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -257,8 +257,9 @@ nftnl_expr_nat_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_nat_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			uint32_t type, uint32_t flags,
+			const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 4e0d54158646..9a5f09a8a5a9 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -173,8 +173,9 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_ng_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+		       uint32_t type, uint32_t flags,
+		       const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 2eb5c47f8e56..a078c5498fca 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -195,8 +195,9 @@ static void nftnl_expr_objref_free(const struct nftnl_expr *e)
 	xfree(objref->set.name);
 }
 
-static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
-				      uint32_t flags,
+static int nftnl_expr_objref_snprintf(struct nftnl_print_ctx *ctx,
+				      char *buf, size_t len,
+				      uint32_t type, uint32_t flags,
 				      const struct nftnl_expr *e)
 {
 	switch (type) {
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 98d0df96aa06..47b07c5140de 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -124,7 +124,8 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_osf_snprintf_default(char *buf, size_t size,
+static int nftnl_expr_osf_snprintf_default(struct nftnl_print_ctx *ctx,
+					   char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
@@ -139,12 +140,13 @@ static int nftnl_expr_osf_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_osf_snprintf(char *buf, size_t len, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_osf_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			uint32_t type, uint32_t flags,
+			const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_osf_snprintf_default(buf, len, e);
+		return nftnl_expr_osf_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 2192dad5f15d..153fe1ef367a 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -232,8 +232,9 @@ static inline int nftnl_str2base(const char *base)
 }
 
 static int
-nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_payload_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			    uint32_t type, uint32_t flags,
+			    const struct nftnl_expr *e)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 051ef71e72fd..a154f42d0301 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -143,7 +143,8 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
+static int nftnl_expr_queue_snprintf_default(struct nftnl_print_ctx *ctx,
+					     char *buf, size_t len,
 					     const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
@@ -185,12 +186,13 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_queue_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			  uint32_t type, uint32_t flags,
+			  const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_queue_snprintf_default(buf, len, e);
+		return nftnl_expr_queue_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 39a92e6ed696..74d5d1d3d76c 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -138,9 +138,10 @@ static int nftnl_expr_quota_snprintf_default(char *buf, size_t len,
 			quota->bytes, quota->consumed, quota->flags);
 }
 
-static int nftnl_expr_quota_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_expr *e)
+static int nftnl_expr_quota_snprintf(struct nftnl_print_ctx *ctx,
+				     char *buf, size_t len, uint32_t type,
+				     uint32_t flags,
+				     const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/range.c b/src/expr/range.c
index d1d50832a450..5324893ce657 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -184,33 +184,42 @@ static inline int nftnl_str2range(const char *op)
 	}
 }
 
-static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+static int nftnl_expr_range_snprintf_default(struct nftnl_print_ctx *ctx,
+					     char *buf, size_t size,
+					     const struct nftnl_expr *e)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
+	enum nftnl_byteorder byteorder;
 
 	ret = snprintf(buf, remain, "%s reg %u ",
 		       range2str(range->op), range->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_from,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	byteorder = nftnl_print_ctx_get(ctx, range->sreg);
+
+	ret = nftnl_data_reg_snprintf(buf + offset, remain,
+				      &range->data_from,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	ret = nftnl_data_reg_snprintf(buf + offset, remain,
+				      &range->data_to,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE,
+				      byteorder);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
 
-static int nftnl_expr_range_snprintf(char *buf, size_t size, uint32_t type,
+static int nftnl_expr_range_snprintf(struct nftnl_print_ctx *ctx,
+				     char *buf, size_t size, uint32_t type,
 				     uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_range_snprintf_default(buf, size, e);
+		return nftnl_expr_range_snprintf_default(ctx, buf, size, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 477659a320db..50b8bdffbf86 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -131,7 +131,8 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
+static int nftnl_expr_redir_snprintf_default(struct nftnl_print_ctx *ctx,
+					     char *buf, size_t len,
 					     const struct nftnl_expr *e)
 {
 	int ret, remain = len, offset = 0;
@@ -159,12 +160,13 @@ static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_redir_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			  uint32_t type, uint32_t flags,
+			  const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_redir_snprintf_default(buf, len, e);
+		return nftnl_expr_redir_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 141942e6941f..61f8152f81e8 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -126,8 +126,9 @@ static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_reject_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 0fce72d9a845..a88242abc1ce 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -142,7 +142,8 @@ static inline int str2rt_key(const char *str)
 }
 
 static int
-nftnl_expr_rt_snprintf_default(char *buf, size_t len,
+nftnl_expr_rt_snprintf_default(struct nftnl_print_ctx *ctx,
+			       char *buf, size_t len,
 			       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_rt *rt = nftnl_expr_data(e);
@@ -155,12 +156,13 @@ nftnl_expr_rt_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_rt_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_rt_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+		       uint32_t type, uint32_t flags,
+		       const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_rt_snprintf_default(buf, len, e);
+		return nftnl_expr_rt_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 8cd4536a7a8e..729b213f9e87 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -140,8 +140,9 @@ static inline int str2socket_key(const char *str)
 }
 
 static int
-nftnl_expr_socket_snprintf_default(char *buf, size_t len,
-			       const struct nftnl_expr *e)
+nftnl_expr_socket_snprintf_default(struct nftnl_print_ctx *ctx,
+				   char *buf, size_t len,
+				   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_socket *socket = nftnl_expr_data(e);
 
@@ -153,12 +154,13 @@ nftnl_expr_socket_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_socket_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_socket_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_socket_snprintf_default(buf, len, e);
+		return nftnl_expr_socket_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index 245f4fb5a41b..ddc8c5b6b675 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -144,8 +144,9 @@ static int nftnl_expr_synproxy_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_synproxy_snprintf(char *buf, size_t len, uint32_t type,
-			     uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_synproxy_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			     uint32_t type, uint32_t flags,
+			     const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/target.c b/src/expr/target.c
index 91000386704a..e697b8eb009c 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -165,8 +165,9 @@ static int nftnl_expr_target_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_target_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 3827b75ed221..6e991cbd8524 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -163,8 +163,9 @@ nftnl_expr_tproxy_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_tproxy_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_tproxy_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t size,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index b2b8d7243a26..0b8147b9cf3b 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -138,8 +138,9 @@ static inline int str2tunnel_key(const char *str)
 }
 
 static int
-nftnl_expr_tunnel_snprintf_default(char *buf, size_t len,
-				 const struct nftnl_expr *e)
+nftnl_expr_tunnel_snprintf_default(struct nftnl_print_ctx *ctx,
+				   char *buf, size_t len,
+				   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_tunnel *tunnel = nftnl_expr_data(e);
 
@@ -151,12 +152,13 @@ nftnl_expr_tunnel_snprintf_default(char *buf, size_t len,
 }
 
 static int
-nftnl_expr_tunnel_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_tunnel_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			   uint32_t type, uint32_t flags,
+			   const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_tunnel_snprintf_default(buf, len, e);
+		return nftnl_expr_tunnel_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 8fe5438bd792..97f84d387fb4 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -200,8 +200,9 @@ static int str2xfmrdir(const char *s)
 #endif
 
 static int
-nftnl_expr_xfrm_snprintf_default(char *buf, size_t size,
-			       const struct nftnl_expr *e)
+nftnl_expr_xfrm_snprintf_default(struct nftnl_print_ctx *ctx,
+				 char *buf, size_t size,
+				 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_xfrm *x = nftnl_expr_data(e);
 	int ret, remain = size, offset = 0;
@@ -217,12 +218,13 @@ nftnl_expr_xfrm_snprintf_default(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_xfrm_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
+nftnl_expr_xfrm_snprintf(struct nftnl_print_ctx *ctx, char *buf, size_t len,
+			 uint32_t type, uint32_t flags,
+			 const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_xfrm_snprintf_default(buf, len, e);
+		return nftnl_expr_xfrm_snprintf_default(ctx, buf, len, e);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 	default:
diff --git a/src/rule.c b/src/rule.c
index 480afc8ffc1b..9a6d0e9bc7a5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -545,7 +545,26 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 	return nftnl_rule_do_parse(r, type, fp, err, NFTNL_PARSE_FILE);
 }
 
-static int nftnl_rule_snprintf_default(char *buf, size_t size,
+void nftnl_print_ctx_set(struct nftnl_print_ctx *ctx, uint32_t reg,
+			 enum nftnl_byteorder byteorder)
+{
+	if (reg > NFT_REG32_15)
+		return;
+
+	ctx->byteorder[reg] = byteorder;
+}
+
+enum nftnl_byteorder nftnl_print_ctx_get(struct nftnl_print_ctx *ctx,
+					 uint32_t reg)
+{
+	if (reg > NFT_REG32_15)
+		return NFTNL_BYTEORDER_HOST;
+
+	return ctx->byteorder[reg];
+}
+
+static int nftnl_rule_snprintf_default(struct nftnl_print_ctx *ctx,
+				       char *buf, size_t size,
 				       const struct nftnl_rule *r,
 				       uint32_t type, uint32_t flags)
 {
@@ -598,8 +617,8 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 		ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_expr_snprintf(buf + offset, remain, expr,
-					     type, flags);
+		ret = __nftnl_expr_snprintf(ctx, buf + offset, remain, expr,
+					    type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = snprintf(buf + offset, remain, "]\n");
@@ -626,7 +645,8 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
+static int nftnl_rule_cmd_snprintf(struct nftnl_print_ctx *ctx,
+				   char *buf, size_t size,
 				   const struct nftnl_rule *r, uint32_t cmd,
 				   uint32_t type, uint32_t flags)
 {
@@ -637,8 +657,8 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_rule_snprintf_default(buf + offset, remain, r, type,
-						inner_flags);
+		ret = nftnl_rule_snprintf_default(ctx, buf + offset, remain,
+						  r, type, inner_flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	case NFTNL_OUTPUT_JSON:
@@ -654,11 +674,13 @@ EXPORT_SYMBOL(nftnl_rule_snprintf);
 int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
 			uint32_t type, uint32_t flags)
 {
+	struct nftnl_print_ctx ctx = {};
+
 	if (size)
 		buf[0] = '\0';
 
-	return nftnl_rule_cmd_snprintf(buf, size, r, nftnl_flag2cmd(flags), type,
-				     flags);
+	return nftnl_rule_cmd_snprintf(&ctx, buf, size, r,
+				       nftnl_flag2cmd(flags), type, flags);
 }
 
 static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,

--IJpNTDwzlM2Ie8A6--
