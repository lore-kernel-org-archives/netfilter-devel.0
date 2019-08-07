Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95203C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 22:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB3321743
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 22:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389470AbfHGWjn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 18:39:43 -0400
Received: from correo.us.es ([193.147.175.20]:47386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388425AbfHGWjm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 18:39:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ECE4C1031EF
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2019 00:39:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC0E5DA704
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2019 00:39:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1A16DA730; Thu,  8 Aug 2019 00:39:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96A61DA704;
        Thu,  8 Aug 2019 00:39:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 08 Aug 2019 00:39:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE72F4265A2F;
        Thu,  8 Aug 2019 00:39:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 1/2] src: add parse_ctx object
Date:   Thu,  8 Aug 2019 00:39:23 +0200
Message-Id: <20190807223924.14067-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This object stores the dynamic symbol tables that are loaded from files.
Pass this object to datatype parse functions, although this is not used
yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 14 +++++++++++---
 include/nftables.h |  8 ++++++++
 src/ct.c           |  3 ++-
 src/datatype.c     | 46 +++++++++++++++++++++++++++++-----------------
 src/evaluate.c     |  6 ++++--
 src/meta.c         | 17 +++++++++++------
 src/rt.c           |  5 +++--
 7 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 63617ebd2753..018f013aea04 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -123,6 +123,7 @@ enum datatype_flags {
 	DTYPE_F_PREFIX		= (1 << 1),
 };
 
+struct parse_ctx;
 /**
  * struct datatype
  *
@@ -154,7 +155,8 @@ struct datatype {
 						 struct output_ctx *octx);
 	json_t				*(*json)(const struct expr *expr,
 						 struct output_ctx *octx);
-	struct error_record		*(*parse)(const struct expr *sym,
+	struct error_record		*(*parse)(struct parse_ctx *ctx,
+						  const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
 	unsigned int			refcnt;
@@ -166,7 +168,12 @@ extern struct datatype *datatype_get(const struct datatype *dtype);
 extern void datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
 
-extern struct error_record *symbol_parse(const struct expr *sym,
+struct parse_ctx {
+	struct symbol_tables	*tbl;
+};
+
+extern struct error_record *symbol_parse(struct parse_ctx *ctx,
+					 const struct expr *sym,
 					 struct expr **res);
 extern void datatype_print(const struct expr *expr, struct output_ctx *octx);
 
@@ -218,7 +225,8 @@ struct symbol_table {
 	struct symbolic_constant	symbols[];
 };
 
-extern struct error_record *symbolic_constant_parse(const struct expr *sym,
+extern struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
+						    const struct expr *sym,
 						    const struct symbol_table *tbl,
 						    struct expr **res);
 extern void symbolic_constant_print(const struct symbol_table *tbl,
diff --git a/include/nftables.h b/include/nftables.h
index ed446e2d16cf..407d76130e9f 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -15,6 +15,13 @@ struct cookie {
 	size_t pos;
 };
 
+struct symbol_tables {
+	const struct symbol_table	*mark;
+	const struct symbol_table	*devgroup;
+	const struct symbol_table	*ct_label;
+	const struct symbol_table	*realm;
+};
+
 struct output_ctx {
 	unsigned int flags;
 	union {
@@ -25,6 +32,7 @@ struct output_ctx {
 		FILE *error_fp;
 		struct cookie error_cookie;
 	};
+	struct symbol_tables tbl;
 };
 
 static inline bool nft_output_reversedns(const struct output_ctx *octx)
diff --git a/src/ct.c b/src/ct.c
index 14cc0e5e8a4e..c66b327a2237 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -171,7 +171,8 @@ static void ct_label_type_print(const struct expr *expr,
 	nft_print(octx, "%lu", bit);
 }
 
-static struct error_record *ct_label_type_parse(const struct expr *sym,
+static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
+						const struct expr *sym,
 						struct expr **res)
 {
 	const struct symbolic_constant *s;
diff --git a/src/datatype.c b/src/datatype.c
index 6d6826e9d745..039b4e529af0 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -113,7 +113,7 @@ void datatype_print(const struct expr *expr, struct output_ctx *octx)
 	    expr->dtype->name);
 }
 
-struct error_record *symbol_parse(const struct expr *sym,
+struct error_record *symbol_parse(struct parse_ctx *ctx, const struct expr *sym,
 				  struct expr **res)
 {
 	const struct datatype *dtype = sym->dtype;
@@ -124,9 +124,9 @@ struct error_record *symbol_parse(const struct expr *sym,
 		return error(&sym->location, "No symbol type information");
 	do {
 		if (dtype->parse != NULL)
-			return dtype->parse(sym, res);
+			return dtype->parse(ctx, sym, res);
 		if (dtype->sym_tbl != NULL)
-			return symbolic_constant_parse(sym, dtype->sym_tbl,
+			return symbolic_constant_parse(ctx, sym, dtype->sym_tbl,
 						       res);
 	} while ((dtype = dtype->basetype));
 
@@ -135,7 +135,8 @@ struct error_record *symbol_parse(const struct expr *sym,
 		     sym->dtype->desc);
 }
 
-struct error_record *symbolic_constant_parse(const struct expr *sym,
+struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
+					     const struct expr *sym,
 					     const struct symbol_table *tbl,
 					     struct expr **res)
 {
@@ -155,7 +156,7 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 	*res = NULL;
 	do {
 		if (dtype->basetype->parse) {
-			erec = dtype->basetype->parse(sym, res);
+			erec = dtype->basetype->parse(ctx, sym, res);
 			if (erec != NULL)
 				return erec;
 			if (*res)
@@ -300,7 +301,8 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
-static struct error_record *verdict_type_parse(const struct expr *sym,
+static struct error_record *verdict_type_parse(struct parse_ctx *ctx,
+					       const struct expr *sym,
 					       struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
@@ -359,7 +361,8 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 	nft_gmp_print(octx, fmt, expr->value);
 }
 
-static struct error_record *integer_type_parse(const struct expr *sym,
+static struct error_record *integer_type_parse(struct parse_ctx *ctx,
+					       const struct expr *sym,
 					       struct expr **res)
 {
 	mpz_t v;
@@ -397,7 +400,8 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, "\"%s\"", data);
 }
 
-static struct error_record *string_type_parse(const struct expr *sym,
+static struct error_record *string_type_parse(struct parse_ctx *ctx,
+					      const struct expr *sym,
 	      				      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
@@ -432,7 +436,8 @@ static void lladdr_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
-static struct error_record *lladdr_type_parse(const struct expr *sym,
+static struct error_record *lladdr_type_parse(struct parse_ctx *ctx,
+					      const struct expr *sym,
 					      struct expr **res)
 {
 	char buf[strlen(sym->identifier) + 1], *p;
@@ -483,7 +488,8 @@ static void ipaddr_type_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, "%s", buf);
 }
 
-static struct error_record *ipaddr_type_parse(const struct expr *sym,
+static struct error_record *ipaddr_type_parse(struct parse_ctx *ctx,
+					      const struct expr *sym,
 					      struct expr **res)
 {
 	struct addrinfo *ai, hints = { .ai_family = AF_INET,
@@ -541,7 +547,8 @@ static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, "%s", buf);
 }
 
-static struct error_record *ip6addr_type_parse(const struct expr *sym,
+static struct error_record *ip6addr_type_parse(struct parse_ctx *ctx,
+					       const struct expr *sym,
 					       struct expr **res)
 {
 	struct addrinfo *ai, hints = { .ai_family = AF_INET6,
@@ -595,7 +602,8 @@ static void inet_protocol_type_print(const struct expr *expr,
 	integer_type_print(expr, octx);
 }
 
-static struct error_record *inet_protocol_type_parse(const struct expr *sym,
+static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
+						     const struct expr *sym,
 						     struct expr **res)
 {
 	struct protoent *p;
@@ -676,7 +684,8 @@ void inet_service_type_print(const struct expr *expr, struct output_ctx *octx)
 	integer_type_print(expr, octx);
 }
 
-static struct error_record *inet_service_type_parse(const struct expr *sym,
+static struct error_record *inet_service_type_parse(struct parse_ctx *ctx,
+						    const struct expr *sym,
 						    struct expr **res)
 {
 	struct addrinfo *ai;
@@ -796,10 +805,11 @@ static void mark_type_print(const struct expr *expr, struct output_ctx *octx)
 	return symbolic_constant_print(mark_tbl, expr, true, octx);
 }
 
-static struct error_record *mark_type_parse(const struct expr *sym,
+static struct error_record *mark_type_parse(struct parse_ctx *ctx,
+					    const struct expr *sym,
 					    struct expr **res)
 {
-	return symbolic_constant_parse(sym, mark_tbl, res);
+	return symbolic_constant_parse(ctx, sym, mark_tbl, res);
 }
 
 const struct datatype mark_type = {
@@ -1019,7 +1029,8 @@ static void time_type_print(const struct expr *expr, struct output_ctx *octx)
 	time_print(mpz_get_uint64(expr->value), octx);
 }
 
-static struct error_record *time_type_parse(const struct expr *sym,
+static struct error_record *time_type_parse(struct parse_ctx *ctx,
+					    const struct expr *sym,
 					    struct expr **res)
 {
 	struct error_record *erec;
@@ -1050,7 +1061,8 @@ const struct datatype time_type = {
 	.parse		= time_type_parse,
 };
 
-static struct error_record *concat_type_parse(const struct expr *sym,
+static struct error_record *concat_type_parse(struct parse_ctx *ctx,
+					      const struct expr *sym,
 					      struct expr **res)
 {
 	return error(&sym->location, "invalid data type, expected %s",
diff --git a/src/evaluate.c b/src/evaluate.c
index 48c65cd2f35a..df8e808f92a9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -223,6 +223,7 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
  */
 static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
+	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
 	struct error_record *erec;
 	struct table *table;
 	struct set *set;
@@ -231,7 +232,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
 		datatype_set(*expr, ctx->ectx.dtype);
-		erec = symbol_parse(*expr, &new);
+		erec = symbol_parse(&parse_ctx, *expr, &new);
 		if (erec != NULL) {
 			erec_queue(erec, ctx->msgs);
 			return -1;
@@ -2541,10 +2542,11 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 
 static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
 	struct error_record *erec;
 	struct expr *code;
 
-	erec = symbol_parse(stmt->reject.expr, &code);
+	erec = symbol_parse(&parse_ctx, stmt->reject.expr, &code);
 	if (erec != NULL) {
 		erec_queue(erec, ctx->msgs);
 		return -1;
diff --git a/src/meta.c b/src/meta.c
index 1e8964eb48c4..5c0c4e29c062 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -68,7 +68,8 @@ static void tchandle_type_print(const struct expr *expr,
 	}
 }
 
-static struct error_record *tchandle_type_parse(const struct expr *sym,
+static struct error_record *tchandle_type_parse(struct parse_ctx *ctx,
+						const struct expr *sym,
 						struct expr **res)
 {
 	uint32_t handle;
@@ -142,7 +143,8 @@ static void ifindex_type_print(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, "%d", ifindex);
 }
 
-static struct error_record *ifindex_type_parse(const struct expr *sym,
+static struct error_record *ifindex_type_parse(struct parse_ctx *ctx,
+					       const struct expr *sym,
 					       struct expr **res)
 {
 	int ifindex;
@@ -220,7 +222,8 @@ static void uid_type_print(const struct expr *expr, struct output_ctx *octx)
 	expr_basetype(expr)->print(expr, octx);
 }
 
-static struct error_record *uid_type_parse(const struct expr *sym,
+static struct error_record *uid_type_parse(struct parse_ctx *ctx,
+					   const struct expr *sym,
 					   struct expr **res)
 {
 	struct passwd *pw;
@@ -273,7 +276,8 @@ static void gid_type_print(const struct expr *expr, struct output_ctx *octx)
 	expr_basetype(expr)->print(expr, octx);
 }
 
-static struct error_record *gid_type_parse(const struct expr *sym,
+static struct error_record *gid_type_parse(struct parse_ctx *ctx,
+					   const struct expr *sym,
 					   struct expr **res)
 {
 	struct group *gr;
@@ -355,10 +359,11 @@ static void devgroup_type_print(const struct expr *expr,
 	return symbolic_constant_print(devgroup_tbl, expr, true, octx);
 }
 
-static struct error_record *devgroup_type_parse(const struct expr *sym,
+static struct error_record *devgroup_type_parse(struct parse_ctx *ctx,
+						const struct expr *sym,
 						struct expr **res)
 {
-	return symbolic_constant_parse(sym, devgroup_tbl, res);
+	return symbolic_constant_parse(ctx, sym, devgroup_tbl, res);
 }
 
 const struct datatype devgroup_type = {
diff --git a/src/rt.c b/src/rt.c
index 3ad77bcdda4d..cdd5e9d82b44 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -40,10 +40,11 @@ static void realm_type_print(const struct expr *expr, struct output_ctx *octx)
 	return symbolic_constant_print(realm_tbl, expr, true, octx);
 }
 
-static struct error_record *realm_type_parse(const struct expr *sym,
+static struct error_record *realm_type_parse(struct parse_ctx *ctx,
+					     const struct expr *sym,
 					     struct expr **res)
 {
-	return symbolic_constant_parse(sym, realm_tbl, res);
+	return symbolic_constant_parse(ctx, sym, realm_tbl, res);
 }
 
 const struct datatype realm_type = {
-- 
2.11.0

