Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D042CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 20:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46A342067D
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 20:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfJ3U7Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 16:59:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45536 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfJ3U7P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 16:59:15 -0400
Received: from localhost ([::1]:58626 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPv3i-0001n5-Am; Wed, 30 Oct 2019 21:59:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] libnftables: Store top_scope in struct nft_ctx
Date:   Wed, 30 Oct 2019 21:59:05 +0100
Message-Id: <20191030205905.12779-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
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
| goodports = { 22, 23, 80, 443 }
| add rule inet t c tcp dport $goodports accept
| add rule inet t c tcp sport $goodports accept

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h                       |  2 ++
 include/parser.h                         |  4 ++--
 src/libnftables.c                        |  8 ++++++--
 tests/shell/testcases/nft-i/0001define_0 | 22 ++++++++++++++++++++++
 4 files changed, 32 insertions(+), 4 deletions(-)
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
diff --git a/src/libnftables.c b/src/libnftables.c
index e20372438db62..7c35e898d87ab 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -155,6 +155,8 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
+	ctx->top_scope = xzalloc(sizeof(struct scope));
+	init_list_head(&ctx->top_scope->symbols);
 	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
@@ -292,6 +294,8 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	iface_cache_release();
 	cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
+	scope_release(ctx->top_scope);
+	xfree(ctx->top_scope);
 	xfree(ctx->state);
 	nft_exit(ctx);
 	xfree(ctx);
@@ -368,7 +372,7 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 {
 	int ret;
 
-	parser_init(nft, nft->state, msgs, cmds);
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
 	scanner_push_buffer(nft->scanner, &indesc_cmdline, buf);
 
@@ -384,7 +388,7 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 {
 	int ret;
 
-	parser_init(nft, nft->state, msgs, cmds);
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
 	if (scanner_read_file(nft, filename, &internal_location) < 0)
 		return -1;
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
2.23.0

