Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB88C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A1B320856
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732588AbfEVToD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 15:44:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44728 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbfEVToD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 15:44:03 -0400
Received: from localhost ([::1]:57818 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hTX9c-0003S0-5K; Wed, 22 May 2019 21:44:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: [nft PATCH v2 2/3] libnftables: Keep list of commands in nft context
Date:   Wed, 22 May 2019 21:44:05 +0200
Message-Id: <20190522194406.16827-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522194406.16827-1-phil@nwl.cc>
References: <20190522194406.16827-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To fix the pending issues with cache updates, the list of commands needs
to be accessible from within cache_update(). In theory, there is a path
via nft->state->cmds but that struct parser_state is used (and
initialized) by bison parser only so that does not work with JSON
parser.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h |  1 +
 src/libnftables.c  | 21 ++++++++++-----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index bb9bb2091716d..faacf26509104 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -102,6 +102,7 @@ struct nft_ctx {
 	struct parser_state	*state;
 	void			*scanner;
 	void			*json_root;
+	struct list_head	cmds;
 	FILE			*f[MAX_INCLUDE_DEPTH];
 };
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 199dbc97b801c..f6ea668f6770a 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -143,6 +143,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
+	init_list_head(&ctx->cmds);
 	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
@@ -342,7 +343,7 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 	struct cmd *cmd;
 	int ret;
 
-	parser_init(nft, nft->state, msgs, cmds);
+	parser_init(nft, nft->state, msgs, &nft->cmds);
 	nft->scanner = scanner_init(nft->state);
 	scanner_push_buffer(nft->scanner, &indesc_cmdline, buf);
 
@@ -381,7 +382,6 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
 	struct cmd *cmd, *next;
 	LIST_HEAD(msgs);
-	LIST_HEAD(cmds);
 	char *nlbuf;
 	int rc = -EINVAL;
 
@@ -389,17 +389,17 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	sprintf(nlbuf, "%s\n", buf);
 
 	if (nft_output_json(&nft->output))
-		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
+		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &nft->cmds);
 	if (rc == -EINVAL)
-		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds);
+		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &nft->cmds);
 	if (rc)
 		goto err;
 
-	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
+	if (nft_netlink(nft, &nft->cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	list_for_each_entry_safe(cmd, next, &cmds, list) {
+	list_for_each_entry_safe(cmd, next, &nft->cmds, list) {
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
@@ -421,7 +421,6 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct cmd *cmd, *next;
 	LIST_HEAD(msgs);
-	LIST_HEAD(cmds);
 	int rc;
 
 	rc = cache_update(nft, CMD_INVALID, &msgs);
@@ -433,17 +432,17 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 
 	rc = -EINVAL;
 	if (nft_output_json(&nft->output))
-		rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
+		rc = nft_parse_json_filename(nft, filename, &msgs, &nft->cmds);
 	if (rc == -EINVAL)
-		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
+		rc = nft_parse_bison_filename(nft, filename, &msgs, &nft->cmds);
 	if (rc)
 		goto err;
 
-	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
+	if (nft_netlink(nft, &nft->cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	list_for_each_entry_safe(cmd, next, &cmds, list) {
+	list_for_each_entry_safe(cmd, next, &nft->cmds, list) {
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
-- 
2.21.0

