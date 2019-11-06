Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EB5C47E49
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 14:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB98B2178F
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 14:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfKFOAM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:00:12 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:33660 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfKFOAM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 09:00:12 -0500
Received: from localhost ([::1]:46750 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iSLr0-0002Ae-AE; Wed, 06 Nov 2019 15:00:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] libnftables: Store top_scope in struct nft_ctx
Date:   Wed,  6 Nov 2019 15:00:01 +0100
Message-Id: <20191106140001.2539-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow for interactive sessions to make use of defines. Since parser is
initialized for each line, top scope defines didn't persist although
they are actually useful for stuff like:

| # nft -i
| define goodports = { 22, 23, 80, 443 }
| add rule inet t c tcp dport $goodports accept
| add rule inet t c tcp sport $goodports accept

While being at it, introduce scope_alloc() and scope_free().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix usage example in commit message.
- Add scope_{alloc,free} functions.
---
 include/nftables.h                       |  2 ++
 include/parser.h                         |  4 ++--
 include/rule.h                           |  2 ++
 src/libnftables.c                        |  6 ++++--
 src/parser_bison.y                       |  6 +++---
 src/rule.c                               | 15 +++++++++++++++
 tests/shell/testcases/nft-i/0001define_0 | 22 ++++++++++++++++++++++
 7 files changed, 50 insertions(+), 7 deletions(-)
 create mode 100755 tests/shell/testcases/nft-i/0001define_0

diff --git a/include/nftables.h b/include/nftables.h
index 21553c6bb3a52..90d331960ef29 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -104,6 +104,7 @@ struct nft_cache {
 
 struct mnl_socket;
 struct parser_state;
+struct scope;
 
 #define MAX_INCLUDE_DEPTH	16
 
@@ -119,6 +120,7 @@ struct nft_ctx {
 	uint32_t		flags;
 	struct parser_state	*state;
 	void			*scanner;
+	struct scope		*top_scope;
 	void			*json_root;
 	FILE			*f[MAX_INCLUDE_DEPTH];
 };
diff --git a/include/parser.h b/include/parser.h
index 39a752121a6b8..949284d9466c6 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -22,7 +22,6 @@ struct parser_state {
 	struct list_head		*msgs;
 	unsigned int			nerrs;
 
-	struct scope			top_scope;
 	struct scope			*scopes[SCOPE_NEST_MAX];
 	unsigned int			scope;
 
@@ -32,7 +31,8 @@ struct parser_state {
 struct mnl_socket;
 
 extern void parser_init(struct nft_ctx *nft, struct parser_state *state,
-			struct list_head *msgs, struct list_head *cmds);
+			struct list_head *msgs, struct list_head *cmds,
+			struct scope *top_scope);
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/include/rule.h b/include/rule.h
index a718923b14a36..44bf1a4546ce0 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -97,8 +97,10 @@ struct scope {
 	struct list_head	symbols;
 };
 
+extern struct scope *scope_alloc(void);
 extern struct scope *scope_init(struct scope *scope, const struct scope *parent);
 extern void scope_release(const struct scope *scope);
+extern void scope_free(struct scope *scope);
 
 /**
  * struct symbol
diff --git a/src/libnftables.c b/src/libnftables.c
index e20372438db62..cd2fcf2fd5221 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -155,6 +155,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
+	ctx->top_scope = scope_alloc();
 	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
@@ -292,6 +293,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	iface_cache_release();
 	cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
+	scope_free(ctx->top_scope);
 	xfree(ctx->state);
 	nft_exit(ctx);
 	xfree(ctx);
@@ -368,7 +370,7 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 {
 	int ret;
 
-	parser_init(nft, nft->state, msgs, cmds);
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
 	scanner_push_buffer(nft->scanner, &indesc_cmdline, buf);
 
@@ -384,7 +386,7 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 {
 	int ret;
 
-	parser_init(nft, nft->state, msgs, cmds);
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
 	if (scanner_read_file(nft, filename, &internal_location) < 0)
 		return -1;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6f525d5b85240..3f2832564036e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -42,13 +42,13 @@
 #include "parser_bison.h"
 
 void parser_init(struct nft_ctx *nft, struct parser_state *state,
-		 struct list_head *msgs, struct list_head *cmds)
+		 struct list_head *msgs, struct list_head *cmds,
+		 struct scope *top_scope)
 {
 	memset(state, 0, sizeof(*state));
-	init_list_head(&state->top_scope.symbols);
 	state->msgs = msgs;
 	state->cmds = cmds;
-	state->scopes[0] = scope_init(&state->top_scope, NULL);
+	state->scopes[0] = scope_init(top_scope, NULL);
 	init_list_head(&state->indesc_list);
 }
 
diff --git a/src/rule.c b/src/rule.c
index ff9e8e6c0e57c..ef6a14751af5c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -646,6 +646,15 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
 	return NULL;
 }
 
+struct scope *scope_alloc(void)
+{
+	struct scope *scope = xzalloc(sizeof(struct scope));
+
+	init_list_head(&scope->symbols);
+
+	return scope;
+}
+
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
 {
 	scope->parent = parent;
@@ -665,6 +674,12 @@ void scope_release(const struct scope *scope)
 	}
 }
 
+void scope_free(struct scope *scope)
+{
+	scope_release(scope);
+	xfree(scope);
+}
+
 void symbol_bind(struct scope *scope, const char *identifier, struct expr *expr)
 {
 	struct symbol *sym;
diff --git a/tests/shell/testcases/nft-i/0001define_0 b/tests/shell/testcases/nft-i/0001define_0
new file mode 100755
index 0000000000000..62e1b6dede21d
--- /dev/null
+++ b/tests/shell/testcases/nft-i/0001define_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+set -e
+
+# test if using defines in interactive nft sessions works
+
+$NFT -i >/dev/null <<EOF
+add table inet t
+add chain inet t c
+define ports = { 22, 443 }
+add rule inet t c tcp dport \$ports accept
+add rule inet t c udp dport \$ports accept
+EOF
+
+$NFT -i >/dev/null <<EOF
+define port = 22
+flush chain inet t c
+redefine port = 443
+delete chain inet t c
+undefine port
+delete table inet t
+EOF
-- 
2.24.0

