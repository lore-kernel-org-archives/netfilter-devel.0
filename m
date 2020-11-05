Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122DBC4741F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B825A206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgKEOMJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOMJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:12:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBC7C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:12:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzj-0006Gk-IC; Thu, 05 Nov 2020 15:12:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/7] tcpopt: split tcpopt_hdr_fields into per-option enum
Date:   Thu,  5 Nov 2020 15:11:41 +0100
Message-Id: <20201105141144.31430-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently we're limited to ten template fields in exthdr_desc struct.
Using a single enum for all tpc option fields thus won't work
indefinitely (TCPOPTHDR_FIELD_TSECR is 9) when new option templates get
added.

Fortunately we can just use one enum per tcp option to avoid this.
As a side effect this also allows to simplify the sack offset
calculations.  Rather than computing that on-the-fly, just add extra
fields to the SACK template.

expr->exthdr.offset now holds the 'raw' value, filled in from the option
template. This would ease implementation of 'raw option matching'
using offset and length to load from the option.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/tcpopt.h          |  46 +++++++++++----
 src/evaluate.c            |  16 ++---
 src/exthdr.c              |   1 +
 src/ipopt.c               |   2 +-
 src/netlink_delinearize.c |   2 +-
 src/netlink_linearize.c   |   4 +-
 src/parser_bison.y        |  18 +++---
 src/parser_json.c         |  36 ++++++++++--
 src/tcpopt.c              | 119 ++++++++++++++++----------------------
 9 files changed, 139 insertions(+), 105 deletions(-)

diff --git a/include/tcpopt.h b/include/tcpopt.h
index 7f3fbb8b0c7d..667c8a7725d8 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -33,16 +33,42 @@ enum tcpopt_kind {
 	TCPOPT_KIND_SACK3 = 258,
 };
 
-enum tcpopt_hdr_fields {
-	TCPOPTHDR_FIELD_INVALID,
-	TCPOPTHDR_FIELD_KIND,
-	TCPOPTHDR_FIELD_LENGTH,
-	TCPOPTHDR_FIELD_SIZE,
-	TCPOPTHDR_FIELD_COUNT,
-	TCPOPTHDR_FIELD_LEFT,
-	TCPOPTHDR_FIELD_RIGHT,
-	TCPOPTHDR_FIELD_TSVAL,
-	TCPOPTHDR_FIELD_TSECR,
+/* Internal identifiers */
+enum tcpopt_common {
+	TCPOPT_COMMON_KIND,
+	TCPOPT_COMMON_LENGTH,
+};
+
+enum tcpopt_maxseg {
+	TCPOPT_MAXSEG_KIND,
+	TCPOPT_MAXSEG_LENGTH,
+	TCPOPT_MAXSEG_SIZE,
+};
+
+enum tcpopt_timestamp {
+	TCPOPT_TS_KIND,
+	TCPOPT_TS_LENGTH,
+	TCPOPT_TS_TSVAL,
+	TCPOPT_TS_TSECR,
+};
+
+enum tcpopt_windowscale {
+	TCPOPT_WINDOW_KIND,
+	TCPOPT_WINDOW_LENGTH,
+	TCPOPT_WINDOW_COUNT,
+};
+
+enum tcpopt_hdr_field_sack {
+	TCPOPT_SACK_KIND,
+	TCPOPT_SACK_LENGTH,
+	TCPOPT_SACK_LEFT,
+	TCPOPT_SACK_RIGHT,
+	TCPOPT_SACK_LEFT1,
+	TCPOPT_SACK_RIGHT1,
+	TCPOPT_SACK_LEFT2,
+	TCPOPT_SACK_RIGHT2,
+	TCPOPT_SACK_LEFT3,
+	TCPOPT_SACK_RIGHT3,
 };
 
 extern const struct exthdr_desc *tcpopt_protocols[__TCPOPT_KIND_MAX];
diff --git a/src/evaluate.c b/src/evaluate.c
index af52ab181b29..76b25b408d55 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -477,7 +477,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 					  &extra_len);
 		break;
 	case EXPR_EXTHDR:
-		shift = expr_offset_shift(expr, expr->exthdr.tmpl->offset,
+		shift = expr_offset_shift(expr, expr->exthdr.offset,
 					  &extra_len);
 		break;
 	default:
@@ -530,18 +530,16 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
-	if (expr->exthdr.tmpl->offset % BITS_PER_BYTE != 0 ||
+	if (expr->exthdr.offset % BITS_PER_BYTE != 0 ||
 	    expr->len % BITS_PER_BYTE != 0)
 		expr_evaluate_bits(ctx, exprp);
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT: {
 		static const unsigned int max_tcpoptlen = (15 * 4 - 20) * BITS_PER_BYTE;
-		unsigned int totlen = 0;
+		unsigned int totlen;
 
-		totlen += expr->exthdr.tmpl->offset;
-		totlen += expr->exthdr.tmpl->len;
-		totlen += expr->exthdr.offset;
+		totlen = expr->exthdr.tmpl->len + expr->exthdr.offset;
 
 		if (totlen > max_tcpoptlen)
 			return expr_error(ctx->msgs, expr,
@@ -551,11 +549,9 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	}
 	case NFT_EXTHDR_OP_IPV4: {
 		static const unsigned int max_ipoptlen = 40 * BITS_PER_BYTE;
-		unsigned int totlen = 0;
+		unsigned int totlen;
 
-		totlen += expr->exthdr.tmpl->offset;
-		totlen += expr->exthdr.tmpl->len;
-		totlen += expr->exthdr.offset;
+		totlen = expr->exthdr.offset + expr->exthdr.tmpl->len;
 
 		if (totlen > max_ipoptlen)
 			return expr_error(ctx->msgs, expr,
diff --git a/src/exthdr.c b/src/exthdr.c
index 0b23e0d38b91..e1b7f14d4194 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -193,6 +193,7 @@ struct expr *exthdr_expr_alloc(const struct location *loc,
 			  BYTEORDER_BIG_ENDIAN, tmpl->len);
 	expr->exthdr.desc = desc;
 	expr->exthdr.tmpl = tmpl;
+	expr->exthdr.offset = tmpl->offset;
 	return expr;
 }
 
diff --git a/src/ipopt.c b/src/ipopt.c
index b3d0279d673a..7ecb8b9c8e32 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -102,7 +102,7 @@ struct expr *ipopt_expr_alloc(const struct location *loc, uint8_t type,
 	expr->exthdr.desc   = desc;
 	expr->exthdr.tmpl   = tmpl;
 	expr->exthdr.op     = NFT_EXTHDR_OP_IPV4;
-	expr->exthdr.offset = calc_offset(desc, tmpl, ptr);
+	expr->exthdr.offset = tmpl->offset + calc_offset(desc, tmpl, ptr);
 
 	return expr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 32ec07a09121..9faddde63974 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -809,8 +809,8 @@ static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle)
 {
-	enum nft_registers dreg;
 	uint32_t type, until, offset;
+	enum nft_registers dreg;
 	struct expr *expr;
 
 	type  = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_TYPE);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 23cf54639303..a37e4b940973 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -200,7 +200,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
 {
-	unsigned int offset = expr->exthdr.tmpl->offset + expr->exthdr.offset;
+	unsigned int offset = expr->exthdr.offset;
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("exthdr");
@@ -966,7 +966,7 @@ static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
 
 	expr = stmt->exthdr.expr;
 
-	offset = expr->exthdr.tmpl->offset + expr->exthdr.offset;
+	offset = expr->exthdr.offset;
 
 	nle = alloc_nft_expr("exthdr");
 	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_SREG, sreg);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 379a6acd18e6..e8df98b8949a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5195,7 +5195,7 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			}
 			|	TCP	OPTION	tcp_hdr_option_type
 			{
-				$$ = tcpopt_expr_alloc(&@$, $3, TCPOPTHDR_FIELD_KIND);
+				$$ = tcpopt_expr_alloc(&@$, $3, TCPOPT_COMMON_KIND);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 			}
 			;
@@ -5227,14 +5227,14 @@ tcp_hdr_option_type	:	EOL		{ $$ = TCPOPT_KIND_EOL; }
 			|	TIMESTAMP	{ $$ = TCPOPT_KIND_TIMESTAMP; }
 			;
 
-tcp_hdr_option_field	:	KIND		{ $$ = TCPOPTHDR_FIELD_KIND; }
-			|	LENGTH		{ $$ = TCPOPTHDR_FIELD_LENGTH; }
-			|	SIZE		{ $$ = TCPOPTHDR_FIELD_SIZE; }
-			|	COUNT		{ $$ = TCPOPTHDR_FIELD_COUNT; }
-			|	LEFT		{ $$ = TCPOPTHDR_FIELD_LEFT; }
-			|	RIGHT		{ $$ = TCPOPTHDR_FIELD_RIGHT; }
-			|	TSVAL		{ $$ = TCPOPTHDR_FIELD_TSVAL; }
-			|	TSECR		{ $$ = TCPOPTHDR_FIELD_TSECR; }
+tcp_hdr_option_field	:	KIND		{ $$ = TCPOPT_COMMON_KIND; }
+			|	LENGTH		{ $$ = TCPOPT_COMMON_LENGTH; }
+			|	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
+			|	COUNT		{ $$ = TCPOPT_WINDOW_COUNT; }
+			|	LEFT		{ $$ = TCPOPT_SACK_LEFT; }
+			|	RIGHT		{ $$ = TCPOPT_SACK_RIGHT; }
+			|	TSVAL		{ $$ = TCPOPT_TS_TSVAL; }
+			|	TSECR		{ $$ = TCPOPT_TS_TSECR; }
 			;
 
 dccp_hdr_expr		:	DCCP	dccp_hdr_field
diff --git a/src/parser_json.c b/src/parser_json.c
index c68b64d9f636..6e1333659f81 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -468,8 +468,10 @@ static int json_parse_tcp_option_type(const char *name, int *val)
 	}
 	/* special case for sack0 - sack3 */
 	if (sscanf(name, "sack%u", &i) == 1 && i < 4) {
-		if (val)
-			*val = TCPOPT_KIND_SACK + i;
+		if (val && i == 0)
+			*val = TCPOPT_KIND_SACK;
+		else if (val && i > 0)
+			*val = TCPOPT_KIND_SACK1 + i - 1;
 		return 0;
 	}
 	return 1;
@@ -477,12 +479,38 @@ static int json_parse_tcp_option_type(const char *name, int *val)
 
 static int json_parse_tcp_option_field(int type, const char *name, int *val)
 {
+	const struct exthdr_desc *desc;
+	unsigned int block = 0;
 	unsigned int i;
-	const struct exthdr_desc *desc = tcpopt_protocols[type];
+
+	switch (type) {
+	case TCPOPT_KIND_SACK1:
+		type = TCPOPT_KIND_SACK;
+		block = 1;
+		break;
+	case TCPOPT_KIND_SACK2:
+		type = TCPOPT_KIND_SACK;
+		block = 2;
+		break;
+	case TCPOPT_KIND_SACK3:
+		type = TCPOPT_KIND_SACK;
+		block = 3;
+		break;
+	}
+
+	if (type < 0 || type >= (int)array_size(tcpopt_protocols))
+		return 1;
+
+	desc = tcpopt_protocols[type];
 
 	for (i = 0; i < array_size(desc->templates); i++) {
 		if (desc->templates[i].token &&
 		    !strcmp(desc->templates[i].token, name)) {
+			if (block) {
+				block--;
+				continue;
+			}
+
 			if (val)
 				*val = i;
 			return 0;
@@ -587,7 +615,7 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 
 	if (json_unpack(root, "{s:s}", "field", &field)) {
 		expr = tcpopt_expr_alloc(int_loc, descval,
-					 TCPOPTHDR_FIELD_KIND);
+					 TCPOPT_COMMON_KIND);
 		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 
 		return expr;
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 17cb580d0ead..d1dd13b868e8 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -22,7 +22,7 @@ static const struct exthdr_desc tcpopt_eol = {
 	.name		= "eol",
 	.type		= TCPOPT_KIND_EOL,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",  0,    8),
+		[TCPOPT_COMMON_KIND]		= PHT("kind",  0,    8),
 	},
 };
 
@@ -30,7 +30,7 @@ static const struct exthdr_desc tcpopt_nop = {
 	.name		= "nop",
 	.type		= TCPOPT_KIND_NOP,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
+		[TCPOPT_COMMON_KIND]		= PHT("kind",  0,    8),
 	},
 };
 
@@ -38,9 +38,9 @@ static const struct exthdr_desc tcptopt_maxseg = {
 	.name		= "maxseg",
 	.type		= TCPOPT_KIND_MAXSEG,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
-		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPTHDR_FIELD_SIZE]		= PHT("size",  16, 16),
+		[TCPOPT_MAXSEG_KIND]	= PHT("kind",   0,  8),
+		[TCPOPT_MAXSEG_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_MAXSEG_SIZE]	= PHT("size",  16, 16),
 	},
 };
 
@@ -48,9 +48,9 @@ static const struct exthdr_desc tcpopt_window = {
 	.name		= "window",
 	.type		= TCPOPT_KIND_WINDOW,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
-		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPTHDR_FIELD_COUNT]		= PHT("count", 16,  8),
+		[TCPOPT_WINDOW_KIND]	= PHT("kind",   0,  8),
+		[TCPOPT_WINDOW_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_WINDOW_COUNT]	= PHT("count", 16,  8),
 	},
 };
 
@@ -58,8 +58,8 @@ static const struct exthdr_desc tcpopt_sack_permitted = {
 	.name		= "sack-perm",
 	.type		= TCPOPT_KIND_SACK_PERMITTED,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0, 8),
-		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8, 8),
+		[TCPOPT_COMMON_KIND]	= PHT("kind",   0, 8),
+		[TCPOPT_COMMON_LENGTH]	= PHT("length", 8, 8),
 	},
 };
 
@@ -67,10 +67,16 @@ static const struct exthdr_desc tcpopt_sack = {
 	.name		= "sack",
 	.type		= TCPOPT_KIND_SACK,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
-		[TCPOPTHDR_FIELD_LENGTH]		= PHT("length", 8,   8),
-		[TCPOPTHDR_FIELD_LEFT]		= PHT("left",  16,  32),
-		[TCPOPTHDR_FIELD_RIGHT]		= PHT("right", 48,  32),
+		[TCPOPT_SACK_KIND]	= PHT("kind",   0,   8),
+		[TCPOPT_SACK_LENGTH]	= PHT("length", 8,   8),
+		[TCPOPT_SACK_LEFT]	= PHT("left",  16,  32),
+		[TCPOPT_SACK_RIGHT]	= PHT("right", 48,  32),
+		[TCPOPT_SACK_LEFT1]	= PHT("left",  80,  32),
+		[TCPOPT_SACK_RIGHT1]	= PHT("right", 112,  32),
+		[TCPOPT_SACK_LEFT2]	= PHT("left",  144,  32),
+		[TCPOPT_SACK_RIGHT2]	= PHT("right", 176,  32),
+		[TCPOPT_SACK_LEFT3]	= PHT("left",  208,  32),
+		[TCPOPT_SACK_RIGHT3]	= PHT("right", 240,  32),
 	},
 };
 
@@ -78,12 +84,13 @@ static const struct exthdr_desc tcpopt_timestamp = {
 	.name		= "timestamp",
 	.type		= TCPOPT_KIND_TIMESTAMP,
 	.templates	= {
-		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
-		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPTHDR_FIELD_TSVAL]		= PHT("tsval",  16, 32),
-		[TCPOPTHDR_FIELD_TSECR]		= PHT("tsecr",  48, 32),
+		[TCPOPT_TS_KIND]	= PHT("kind",   0,  8),
+		[TCPOPT_TS_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_TS_TSVAL]	= PHT("tsval",  16, 32),
+		[TCPOPT_TS_TSECR]	= PHT("tsecr",  48, 32),
 	},
 };
+
 #undef PHT
 
 const struct exthdr_desc *tcpopt_protocols[] = {
@@ -96,65 +103,43 @@ const struct exthdr_desc *tcpopt_protocols[] = {
 	[TCPOPT_KIND_TIMESTAMP]		= &tcpopt_timestamp,
 };
 
-static unsigned int calc_offset(const struct exthdr_desc *desc,
-				const struct proto_hdr_template *tmpl,
-				unsigned int num)
-{
-	if (!desc || tmpl == &tcpopt_unknown_template)
-		return 0;
-
-	switch (desc->type) {
-	case TCPOPT_SACK:
-		/* Make sure, offset calculations only apply to left and right
-		 * fields
-		 */
-		return (tmpl->offset < 16) ? 0 : num * 64;
-	default:
-		return 0;
-	}
-}
-
-
-static unsigned int calc_offset_reverse(const struct exthdr_desc *desc,
-					const struct proto_hdr_template *tmpl,
-					unsigned int offset)
-{
-	if (!desc || tmpl == &tcpopt_unknown_template)
-		return offset;
-
-	switch (desc->type) {
-	case TCPOPT_SACK:
-		/* We can safely ignore the first left/right field */
-		return offset < 80 ? offset : (offset % 64);
-	default:
-		return offset;
-	}
-}
-
 struct expr *tcpopt_expr_alloc(const struct location *loc,
 			       unsigned int kind,
 			       unsigned int field)
 {
 	const struct proto_hdr_template *tmpl;
-	const struct exthdr_desc *desc;
-	uint8_t optnum = 0;
+	const struct exthdr_desc *desc = NULL;
 	struct expr *expr;
 
 	switch (kind) {
 	case TCPOPT_KIND_SACK1:
 		kind = TCPOPT_KIND_SACK;
-		optnum = 1;
+		if (field == TCPOPT_SACK_LEFT)
+			field = TCPOPT_SACK_LEFT1;
+		else if (field == TCPOPT_SACK_RIGHT)
+			field = TCPOPT_SACK_RIGHT1;
 		break;
 	case TCPOPT_KIND_SACK2:
 		kind = TCPOPT_KIND_SACK;
-		optnum = 2;
+		if (field == TCPOPT_SACK_LEFT)
+			field = TCPOPT_SACK_LEFT2;
+		else if (field == TCPOPT_SACK_RIGHT)
+			field = TCPOPT_SACK_RIGHT2;
 		break;
 	case TCPOPT_KIND_SACK3:
 		kind = TCPOPT_KIND_SACK;
-		optnum = 3;
+		if (field == TCPOPT_SACK_LEFT)
+			field = TCPOPT_SACK_LEFT3;
+		else if (field == TCPOPT_SACK_RIGHT)
+			field = TCPOPT_SACK_RIGHT3;
+		break;
 	}
 
-	desc = tcpopt_protocols[kind];
+	if (kind < array_size(tcpopt_protocols))
+		desc = tcpopt_protocols[kind];
+
+	if (!desc)
+		return NULL;
 	tmpl = &desc->templates[field];
 	if (!tmpl)
 		return NULL;
@@ -164,34 +149,32 @@ struct expr *tcpopt_expr_alloc(const struct location *loc,
 	expr->exthdr.desc   = desc;
 	expr->exthdr.tmpl   = tmpl;
 	expr->exthdr.op     = NFT_EXTHDR_OP_TCPOPT;
-	expr->exthdr.offset = calc_offset(desc, tmpl, optnum);
+	expr->exthdr.offset = tmpl->offset;
 
 	return expr;
 }
 
-void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
+void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int off,
 		     unsigned int len, uint32_t flags)
 {
 	const struct proto_hdr_template *tmpl;
-	unsigned int i, off;
+	unsigned int i;
 
 	assert(expr->etype == EXPR_EXTHDR);
 
 	expr->len = len;
 	expr->exthdr.flags = flags;
-	expr->exthdr.offset = offset;
+	expr->exthdr.offset = off;
+
+	if (type >= array_size(tcpopt_protocols))
+		return;
 
-	assert(type < array_size(tcpopt_protocols));
 	expr->exthdr.desc = tcpopt_protocols[type];
 	expr->exthdr.flags = flags;
 	assert(expr->exthdr.desc != NULL);
 
 	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
 		tmpl = &expr->exthdr.desc->templates[i];
-		/* We have to reverse calculate the offset for the sack options
-		 * at this point
-		 */
-		off = calc_offset_reverse(expr->exthdr.desc, tmpl, offset);
 		if (tmpl->offset != off || tmpl->len != len)
 			continue;
 
-- 
2.26.2

