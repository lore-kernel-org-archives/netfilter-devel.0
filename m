Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E017BC32751
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 22:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB8B21743
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 22:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbfHGWjn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 18:39:43 -0400
Received: from correo.us.es ([193.147.175.20]:47388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389469AbfHGWjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 18:39:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E794A1031F1
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2019 00:39:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6F24DA72F
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2019 00:39:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CC6CEDA704; Thu,  8 Aug 2019 00:39:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94B84DA72F;
        Thu,  8 Aug 2019 00:39:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 08 Aug 2019 00:39:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE8504265A2F;
        Thu,  8 Aug 2019 00:39:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 2/2] src: remove global symbol_table
Date:   Thu,  8 Aug 2019 00:39:24 +0200
Message-Id: <20190807223924.14067-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190807223924.14067-1-pablo@netfilter.org>
References: <20190807223924.14067-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store symbol tables in context object instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h       |  3 ++-
 include/datatype.h |  4 +---
 include/meta.h     |  2 --
 include/nftables.h | 18 ++++++++----------
 src/ct.c           | 17 ++++++++---------
 src/datatype.c     | 16 +++++++---------
 src/json.c         |  6 +++---
 src/libnftables.c  | 29 ++++++++++++++---------------
 src/meta.c         | 27 +++++++--------------------
 src/rt.c           | 13 ++++++-------
 10 files changed, 56 insertions(+), 79 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 063f8cdf4aa4..efb2d4185543 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -33,7 +33,8 @@ extern struct stmt *notrack_stmt_alloc(const struct location *loc);
 extern struct stmt *flow_offload_stmt_alloc(const struct location *loc,
 					    const char *table_name);
 extern const char *ct_dir2str(int dir);
-extern const char *ct_label2str(unsigned long value);
+extern const char *ct_label2str(const struct symbol_table *tbl,
+				unsigned long value);
 
 extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
diff --git a/include/datatype.h b/include/datatype.h
index 018f013aea04..cf1151582245 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -238,9 +238,7 @@ extern void symbol_table_print(const struct symbol_table *tbl,
 			       struct output_ctx *octx);
 
 extern struct symbol_table *rt_symbol_table_init(const char *filename);
-extern void rt_symbol_table_free(struct symbol_table *tbl);
-
-extern struct symbol_table *mark_tbl;
+extern void rt_symbol_table_free(const struct symbol_table *tbl);
 
 extern const struct datatype invalid_type;
 extern const struct datatype verdict_type;
diff --git a/include/meta.h b/include/meta.h
index a49b4ff54970..0fe95fd66824 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -42,6 +42,4 @@ extern const struct datatype devgroup_type;
 extern const struct datatype pkttype_type;
 extern const struct datatype ifname_type;
 
-extern struct symbol_table *devgroup_tbl;
-
 #endif /* NFTABLES_META_H */
diff --git a/include/nftables.h b/include/nftables.h
index 407d76130e9f..ef737c839b2e 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -184,19 +184,17 @@ struct input_descriptor {
 	off_t				line_offset;
 };
 
-void ct_label_table_init(void);
-void mark_table_init(void);
+void ct_label_table_init(struct nft_ctx *ctx);
+void mark_table_init(struct nft_ctx *ctx);
 void gmp_init(void);
-void realm_table_rt_init(void);
-void devgroup_table_init(void);
-void realm_table_meta_init(void);
+void realm_table_rt_init(struct nft_ctx *ctx);
+void devgroup_table_init(struct nft_ctx *ctx);
 void xt_init(void);
 
-void ct_label_table_exit(void);
-void mark_table_exit(void);
-void realm_table_meta_exit(void);
-void devgroup_table_exit(void);
-void realm_table_rt_exit(void);
+void ct_label_table_exit(struct nft_ctx *ctx);
+void mark_table_exit(struct nft_ctx *ctx);
+void devgroup_table_exit(struct nft_ctx *ctx);
+void realm_table_rt_exit(struct nft_ctx *ctx);
 
 int nft_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 3)));
diff --git a/src/ct.c b/src/ct.c
index c66b327a2237..ed458e6b679b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -141,11 +141,10 @@ static const struct datatype ct_event_type = {
 	.sym_tbl	= &ct_events_tbl,
 };
 
-static struct symbol_table *ct_label_tbl;
-
 #define CT_LABEL_BIT_SIZE 128
 
-const char *ct_label2str(unsigned long value)
+const char *ct_label2str(const struct symbol_table *ct_label_tbl,
+			 unsigned long value)
 {
 	const struct symbolic_constant *s;
 
@@ -161,7 +160,7 @@ static void ct_label_type_print(const struct expr *expr,
 				 struct output_ctx *octx)
 {
 	unsigned long bit = mpz_scan1(expr->value, 0);
-	const char *labelstr = ct_label2str(bit);
+	const char *labelstr = ct_label2str(octx->tbl.ct_label, bit);
 
 	if (labelstr) {
 		nft_print(octx, "\"%s\"", labelstr);
@@ -181,7 +180,7 @@ static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
 	uint64_t bit;
 	mpz_t value;
 
-	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
+	for (s = ctx->tbl->ct_label->symbols; s->identifier != NULL; s++) {
 		if (!strcmp(sym->identifier, s->identifier))
 			break;
 	}
@@ -230,14 +229,14 @@ static const struct datatype ct_label_type = {
 	.parse		= ct_label_type_parse,
 };
 
-void ct_label_table_init(void)
+void ct_label_table_init(struct nft_ctx *ctx)
 {
-	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
+	ctx->output.tbl.ct_label = rt_symbol_table_init(CONNLABEL_CONF);
 }
 
-void ct_label_table_exit(void)
+void ct_label_table_exit(struct nft_ctx *ctx)
 {
-	rt_symbol_table_free(ct_label_tbl);
+	rt_symbol_table_free(ctx->output.tbl.ct_label);
 }
 
 #ifndef NF_CT_HELPER_NAME_LEN
diff --git a/src/datatype.c b/src/datatype.c
index 039b4e529af0..396a300cba4b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -779,7 +779,7 @@ out:
 	return tbl;
 }
 
-void rt_symbol_table_free(struct symbol_table *tbl)
+void rt_symbol_table_free(const struct symbol_table *tbl)
 {
 	const struct symbolic_constant *s;
 
@@ -788,28 +788,26 @@ void rt_symbol_table_free(struct symbol_table *tbl)
 	xfree(tbl);
 }
 
-struct symbol_table *mark_tbl = NULL;
-
-void mark_table_init(void)
+void mark_table_init(struct nft_ctx *ctx)
 {
-	mark_tbl = rt_symbol_table_init("/etc/iproute2/rt_marks");
+	ctx->output.tbl.mark = rt_symbol_table_init("/etc/iproute2/rt_marks");
 }
 
-void mark_table_exit(void)
+void mark_table_exit(struct nft_ctx *ctx)
 {
-	rt_symbol_table_free(mark_tbl);
+	rt_symbol_table_free(ctx->output.tbl.mark);
 }
 
 static void mark_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(mark_tbl, expr, true, octx);
+	return symbolic_constant_print(octx->tbl.mark, expr, true, octx);
 }
 
 static struct error_record *mark_type_parse(struct parse_ctx *ctx,
 					    const struct expr *sym,
 					    struct expr **res)
 {
-	return symbolic_constant_parse(ctx, sym, mark_tbl, res);
+	return symbolic_constant_parse(ctx, sym, ctx->tbl->mark, res);
 }
 
 const struct datatype mark_type = {
diff --git a/src/json.c b/src/json.c
index 33e0ec15f2ee..9dfa3076429d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1006,18 +1006,18 @@ json_t *inet_service_type_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *mark_type_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_json(mark_tbl, expr, octx);
+	return symbolic_constant_json(octx->tbl.mark, expr, octx);
 }
 
 json_t *devgroup_type_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_json(devgroup_tbl, expr, octx);
+	return symbolic_constant_json(octx->tbl.devgroup, expr, octx);
 }
 
 json_t *ct_label_type_json(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned long bit = mpz_scan1(expr->value, 0);
-	const char *labelstr = ct_label2str(bit);
+	const char *labelstr = ct_label2str(octx->tbl.ct_label, bit);
 
 	if (labelstr)
 		return json_string(labelstr);
diff --git a/src/libnftables.c b/src/libnftables.c
index 4a139c58b2b3..a693c0c69075 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -84,26 +84,25 @@ out:
 	return ret;
 }
 
-static void nft_init(void)
+static void nft_init(struct nft_ctx *ctx)
 {
-	mark_table_init();
-	realm_table_rt_init();
-	devgroup_table_init();
-	realm_table_meta_init();
-	ct_label_table_init();
+	mark_table_init(ctx);
+	realm_table_rt_init(ctx);
+	devgroup_table_init(ctx);
+	ct_label_table_init(ctx);
+
 	gmp_init();
 #ifdef HAVE_LIBXTABLES
 	xt_init();
 #endif
 }
 
-static void nft_exit(void)
+static void nft_exit(struct nft_ctx *ctx)
 {
-	ct_label_table_exit();
-	realm_table_rt_exit();
-	devgroup_table_exit();
-	realm_table_meta_exit();
-	mark_table_exit();
+	ct_label_table_exit(ctx);
+	realm_table_rt_exit(ctx);
+	devgroup_table_exit(ctx);
+	mark_table_exit(ctx);
 }
 
 EXPORT_SYMBOL(nft_ctx_add_include_path);
@@ -145,10 +144,10 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 {
 	struct nft_ctx *ctx;
 
-	nft_init();
 	ctx = xzalloc(sizeof(struct nft_ctx));
-	ctx->state = xzalloc(sizeof(struct parser_state));
+	nft_init(ctx);
 
+	ctx->state = xzalloc(sizeof(struct parser_state));
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
@@ -291,7 +290,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	nft_ctx_clear_include_paths(ctx);
 	xfree(ctx->state);
 	xfree(ctx);
-	nft_exit();
+	nft_exit(ctx);
 }
 
 EXPORT_SYMBOL(nft_ctx_set_output);
diff --git a/src/meta.c b/src/meta.c
index 5c0c4e29c062..5901c9919ed8 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -37,17 +37,6 @@
 #include <iface.h>
 #include <json.h>
 
-static struct symbol_table *realm_tbl;
-void realm_table_meta_init(void)
-{
-	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
-}
-
-void realm_table_meta_exit(void)
-{
-	rt_symbol_table_free(realm_tbl);
-}
-
 static void tchandle_type_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
@@ -341,29 +330,27 @@ const struct datatype pkttype_type = {
 	.sym_tbl	= &pkttype_type_tbl,
 };
 
-struct symbol_table *devgroup_tbl = NULL;
-
-void devgroup_table_init(void)
+void devgroup_table_init(struct nft_ctx *ctx)
 {
-	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
+	ctx->output.tbl.devgroup = rt_symbol_table_init("/etc/iproute2/group");
 }
 
-void devgroup_table_exit(void)
+void devgroup_table_exit(struct nft_ctx *ctx)
 {
-	rt_symbol_table_free(devgroup_tbl);
+	rt_symbol_table_free(ctx->output.tbl.devgroup);
 }
 
 static void devgroup_type_print(const struct expr *expr,
-				 struct output_ctx *octx)
+				struct output_ctx *octx)
 {
-	return symbolic_constant_print(devgroup_tbl, expr, true, octx);
+	return symbolic_constant_print(octx->tbl.devgroup, expr, true, octx);
 }
 
 static struct error_record *devgroup_type_parse(struct parse_ctx *ctx,
 						const struct expr *sym,
 						struct expr **res)
 {
-	return symbolic_constant_parse(ctx, sym, devgroup_tbl, res);
+	return symbolic_constant_parse(ctx, sym, ctx->tbl->devgroup, res);
 }
 
 const struct datatype devgroup_type = {
diff --git a/src/rt.c b/src/rt.c
index cdd5e9d82b44..b19c44d6eefe 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -24,27 +24,26 @@
 #include <rule.h>
 #include <json.h>
 
-static struct symbol_table *realm_tbl;
-void realm_table_rt_init(void)
+void realm_table_rt_init(struct nft_ctx *ctx)
 {
-	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
+	ctx->output.tbl.realm = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
 
-void realm_table_rt_exit(void)
+void realm_table_rt_exit(struct nft_ctx *ctx)
 {
-	rt_symbol_table_free(realm_tbl);
+	rt_symbol_table_free(ctx->output.tbl.realm);
 }
 
 static void realm_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(realm_tbl, expr, true, octx);
+	return symbolic_constant_print(octx->tbl.realm, expr, true, octx);
 }
 
 static struct error_record *realm_type_parse(struct parse_ctx *ctx,
 					     const struct expr *sym,
 					     struct expr **res)
 {
-	return symbolic_constant_parse(ctx, sym, realm_tbl, res);
+	return symbolic_constant_parse(ctx, sym, ctx->tbl->realm, res);
 }
 
 const struct datatype realm_type = {
-- 
2.11.0

