Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAD1C28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F83A20866
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfFEQrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:47:02 -0400
Received: from mail.us.es ([193.147.175.20]:58388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbfFEQrC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 12:47:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36BBCFB450
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:47:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25815DA711
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:47:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B3ABDA70D; Wed,  5 Jun 2019 18:47:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F4103DA704;
        Wed,  5 Jun 2019 18:46:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 18:46:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C94104265A31;
        Wed,  5 Jun 2019 18:46:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 2/4] src: perform evaluation after parsing
Date:   Wed,  5 Jun 2019 18:46:50 +0200
Message-Id: <20190605164652.20199-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605164652.20199-1-pablo@netfilter.org>
References: <20190605164652.20199-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since 61236968b7a1 ("parser: evaluate commands immediately after
parsing"), evaluation is invoked from the parsing phase in order to
improve error reporting.

However, this approach is problematic from the cache perspective since
we don't know if a full or partial netlink dump from the kernel is
needed. If the number of objects in the kernel is significant, the
netlink dump operation to build the cache may significantly slow down
commands.

This patch moves the evaluation phase after the parsing phase as a
preparation update to allow for a better strategy to build the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/parser.h   |  1 -
 src/libnftables.c  | 30 +++++++++++++++++++++++++-----
 src/parser_bison.y | 27 ++-------------------------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index a5ae802b288a..39a752121a6b 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -27,7 +27,6 @@ struct parser_state {
 	unsigned int			scope;
 
 	struct list_head		*cmds;
-	struct eval_ctx			ectx;
 };
 
 struct mnl_socket;
diff --git a/src/libnftables.c b/src/libnftables.c
index d8de89ca509c..8720fe2bebaf 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -348,7 +348,6 @@ static const struct input_descriptor indesc_cmdline = {
 static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 				  struct list_head *msgs, struct list_head *cmds)
 {
-	struct cmd *cmd;
 	int ret;
 
 	parser_init(nft, nft->state, msgs, cmds);
@@ -359,16 +358,12 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 	if (ret != 0 || nft->state->nerrs > 0)
 		return -1;
 
-	list_for_each_entry(cmd, cmds, list)
-		nft_cmd_expand(cmd);
-
 	return 0;
 }
 
 static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 				    struct list_head *msgs, struct list_head *cmds)
 {
-	struct cmd *cmd;
 	int ret;
 
 	parser_init(nft, nft->state, msgs, cmds);
@@ -380,6 +375,23 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 	if (ret != 0 || nft->state->nerrs > 0)
 		return -1;
 
+	return 0;
+}
+
+static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
+			struct list_head *cmds)
+{
+	struct cmd *cmd;
+
+	list_for_each_entry(cmd, cmds, list) {
+		struct eval_ctx ectx = {
+			.nft	= nft,
+			.msgs	= msgs,
+		};
+		if (cmd_evaluate(&ectx, cmd) < 0)
+			return -1;
+	}
+
 	list_for_each_entry(cmd, cmds, list)
 		nft_cmd_expand(cmd);
 
@@ -404,6 +416,10 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	if (rc)
 		goto err;
 
+	rc = nft_evaluate(nft, &msgs, &cmds);
+	if (rc < 0)
+		goto err;
+
 	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
@@ -448,6 +464,10 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (rc)
 		goto err;
 
+	rc = nft_evaluate(nft, &msgs, &cmds);
+	if (rc < 0)
+		goto err;
+
 	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2a39db3148ef..8026708ed859 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -48,8 +48,6 @@ void parser_init(struct nft_ctx *nft, struct parser_state *state,
 	state->msgs = msgs;
 	state->cmds = cmds;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
-	state->ectx.nft = nft;
-	state->ectx.msgs = msgs;
 	init_list_head(&state->indesc_list);
 }
 
@@ -792,17 +790,8 @@ input			:	/* empty */
 			|	input		line
 			{
 				if ($2 != NULL) {
-					LIST_HEAD(list);
-
 					$2->location = @2;
-
-					list_add_tail(&$2->list, &list);
-					if (cmd_evaluate(&state->ectx, $2) < 0) {
-						cmd_free($2);
-						if (++state->nerrs == nft->parser_max_errors)
-							YYABORT;
-					} else
-						list_splice_tail(&list, state->cmds);
+					list_add_tail(&$2->list, state->cmds);
 				}
 			}
 			;
@@ -878,22 +867,10 @@ line			:	common_block			{ $$ = NULL; }
 				 * work.
 				 */
 				if ($1 != NULL) {
-					LIST_HEAD(list);
-
 					$1->location = @1;
-
-					list_add_tail(&$1->list, &list);
-					if (cmd_evaluate(&state->ectx, $1) < 0) {
-						cmd_free($1);
-						if (++state->nerrs == nft->parser_max_errors)
-							YYABORT;
-					} else
-						list_splice_tail(&list, state->cmds);
+					list_add_tail(&$1->list, state->cmds);
 				}
-				if (state->nerrs)
-					YYABORT;
 				$$ = NULL;
-
 				YYACCEPT;
 			}
 			;
-- 
2.11.0

