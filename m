Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C444FC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 08:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJGIYl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 04:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGIYi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 04:24:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4B38288
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 01:24:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] parser_bison: display too many levels of nesting error
Date:   Fri,  7 Oct 2022 10:24:29 +0200
Message-Id: <20221007082430.333046-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of hitting this assertion:

 nft: parser_bison.y:70: open_scope: Assertion `state->scope < array_size(state->scopes) - 1' failed.
 Aborted

this is easier to trigger with implicit chains where one level of
nesting from the existing chain scope is supported.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1615
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 27 +++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 2fb037cb8470..f55da0fd47bf 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -22,6 +22,7 @@ struct parser_state {
 
 	struct scope			*scopes[SCOPE_NEST_MAX];
 	unsigned int			scope;
+	bool				scope_err;
 
 	unsigned int			flex_state_pop;
 	unsigned int			startcond_type;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0266819a779b..760c23cf3322 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -65,15 +65,26 @@ static struct scope *current_scope(const struct parser_state *state)
 	return state->scopes[state->scope];
 }
 
-static void open_scope(struct parser_state *state, struct scope *scope)
+static int open_scope(struct parser_state *state, struct scope *scope)
 {
-	assert(state->scope < array_size(state->scopes) - 1);
+	if (state->scope >= array_size(state->scopes) - 1) {
+		state->scope_err = true;
+		return -1;
+	}
+
 	scope_init(scope, current_scope(state));
 	state->scopes[++state->scope] = scope;
+
+	return 0;
 }
 
 static void close_scope(struct parser_state *state)
 {
+	if (state->scope_err) {
+		state->scope_err = false;
+		return;
+	}
+
 	assert(state->scope > 0);
 	state->scope--;
 }
@@ -1674,7 +1685,11 @@ describe_cmd		:	primary_expr
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
-				open_scope(state, &$$->scope);
+				if (open_scope(state, &$$->scope) < 0) {
+					erec_queue(error(&@$, "too many levels of nesting"),
+						   state->msgs);
+					state->nerrs++;
+				}
 			}
 			;
 
@@ -1836,7 +1851,11 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 chain_block_alloc	:	/* empty */
 			{
 				$$ = chain_alloc(NULL);
-				open_scope(state, &$$->scope);
+				if (open_scope(state, &$$->scope) < 0) {
+					erec_queue(error(&@$, "too many levels of nesting"),
+						   state->msgs);
+					state->nerrs++;
+				}
 			}
 			;
 
-- 
2.30.2

