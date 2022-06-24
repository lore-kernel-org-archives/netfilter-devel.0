Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26C9C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 09:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiFXJ0X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 05:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiFXJ0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 05:26:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296796F786
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 02:26:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4fZt-0003pI-Kb; Fri, 24 Jun 2022 11:26:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] scanner: don't pop active flex scanner scope
Date:   Fri, 24 Jun 2022 11:25:55 +0200
Message-Id: <20220624092555.1572-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220624092555.1572-1-fw@strlen.de>
References: <20220624092555.1572-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently we can pop a flex scope that is still active, i.e. the
scanner_pop_start_cond() for the scope has not been done.

Example:
  counter ipsec out ip daddr 192.168.1.2 counter name "ipsec_out"

Here, parser fails because 'daddr' is parsed as STRING, not as DADDR token.

Bug is as follows:
COUNTER changes scope to COUNTER. (COUNTER).
Next, IPSEC scope gets pushed, stack is: COUNTER, IPSEC.

Then, the 'COUNTER' scope close happens.  Because active scope has changed,
we cannot pop (we would pop the 'ipsec' scope in flex).
The pop operation gets delayed accordingly.

Next, IP gets pushed, stack is: COUNTER, IPSEC, IP, plus the information
that one scope closure/pop was delayed.

Then, the IP scope is closed.  Because a pop operation was delayed, we pop again,
which brings us back to COUNTER state.

This is bogus: The pop operation CANNOT be done yet, because the ipsec scope
is still open, but the existing code lacks the information to detect this.

After popping the IP scope, we must remain in IPSEC scope until bison
parser calls scanner_pop_start_cond(, IPSEC).

This adds a counter per flex scope so that we can detect this case.
In above case, after the IP scope gets closed, the "new" (previous)
scope (IPSEC) will be treated as active and its close is attempted again
on the next call to scanner_pop_start_cond().

After this patch, transition in above rule is:

push counter (COUNTER)
push IPSEC (COUNTER, IPSEC)
pop COUNTER (delayed: COUNTER, IPSEC, pending-pop for COUNTER),
push IP (COUNTER, IPSEC, IP, pending-pop for COUNTER)
pop IP (COUNTER, IPSEC, pending-pop for COUNTER)
parse DADDR (we're in IPSEC scope, its valid token)
pop IPSEC (pops all remaining scopes).

We could also resurrect the commit:
"scanner: flags: move to own scope", the test case passes with the
new scope closure logic.

Fixes: bff106c5b277 ("scanner: add support for scope nesting")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h |  3 +++
 src/scanner.l    | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/parser.h b/include/parser.h
index d8d2eb115922..2fb037cb8470 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -26,6 +26,7 @@ struct parser_state {
 	unsigned int			flex_state_pop;
 	unsigned int			startcond_type;
 	struct list_head		*cmds;
+	unsigned int			*startcond_active;
 };
 
 enum startcond_type {
@@ -81,6 +82,8 @@ enum startcond_type {
 	PARSER_SC_STMT_REJECT,
 	PARSER_SC_STMT_SYNPROXY,
 	PARSER_SC_STMT_TPROXY,
+
+	__SC_MAX
 };
 
 struct mnl_socket;
diff --git a/src/scanner.l b/src/scanner.l
index 7eb74020ef84..5741261a690a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1144,6 +1144,8 @@ void *scanner_init(struct parser_state *state)
 	yylex_init_extra(state, &scanner);
 	yyset_out(NULL, scanner);
 
+	state->startcond_active = xzalloc_array(__SC_MAX,
+						sizeof(*state->startcond_active));
 	return scanner;
 }
 
@@ -1173,6 +1175,8 @@ void scanner_destroy(struct nft_ctx *nft)
 	struct parser_state *state = yyget_extra(nft->scanner);
 
 	input_descriptor_list_destroy(state);
+	xfree(state->startcond_active);
+
 	yylex_destroy(nft->scanner);
 }
 
@@ -1181,6 +1185,7 @@ static void scanner_push_start_cond(void *scanner, enum startcond_type type)
 	struct parser_state *state = yyget_extra(scanner);
 
 	state->startcond_type = type;
+	state->startcond_active[type]++;
 
 	yy_push_state((int)type, scanner);
 }
@@ -1189,6 +1194,8 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
+	state->startcond_active[t]--;
+
 	if (state->startcond_type != t) {
 		state->flex_state_pop++;
 		return; /* Can't pop just yet! */
@@ -1198,6 +1205,10 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 		state->flex_state_pop--;
 		state->startcond_type = yy_top_state(scanner);
 		yy_pop_state(scanner);
+
+		t = state->startcond_type;
+		if (state->startcond_active[t])
+			return;
 	}
 
 	state->startcond_type = yy_top_state(scanner);
-- 
2.35.1

