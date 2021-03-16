Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24096C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 038D164F0F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCPXlP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhCPXkv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:40:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ED1C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:40:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJIu-00057r-NE; Wed, 17 Mar 2021 00:40:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/6] scanner: add support for scope nesting
Date:   Wed, 17 Mar 2021 00:40:34 +0100
Message-Id: <20210316234039.15677-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adding a COUNTER scope introduces parsing errors.  Example:

add rule  ... counter ip saddr 1.2.3.4

This is supposed to be

    COUNTER	IP SADDR SYMBOL

but it will be parsed as

    COUNTER	IP STRING SYMBOL

... and rule fails with unknown saddr.
This is because IP state change gets popped right after it was pushed.

bison parser invokes scanner_pop_start_cond() helper via
'close_scope_counter' rule after it has processed the entire 'counter' rule.
But that happens *after* flex has executed the 'IP' rule.

IOW, the sequence of events is not the exepcted
"COUNTER close_scope_counter IP SADDR SYMBOL close_scope_ip", it is
"COUNTER IP close_scope_counter".

close_scope_counter pops the just-pushed SCANSTATE_IP and returns the
scanner to SCANSTATE_COUNTER, so next input token (saddr) gets parsed
as a string, which gets then rejected from bison.

To resolve this, defer the pop operation until the current state is done.
scanner_pop_start_cond() already gets the scope that it has been
completed as an argument, so we can compare it to the active state.

If those are not the same, just defer the pop operation until the
bison reports its done with the active flex scope.

This leads to following sequence of events:
  1. flex switches to SCANSTATE_COUNTER
  2. flex switches to SCANSTATE_IP
  3. bison calls scanner_pop_start_cond(SCANSTATE_COUNTER)
  4. flex remains in SCANSTATE_IP, bison continues
  5. bison calls scanner_pop_start_cond(SCANSTATE_IP) once the entire
     ip rule has completed: this pops both IP and COUNTER.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h |  2 ++
 src/scanner.l    | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/parser.h b/include/parser.h
index 9fdebcd11dd2..0c229963d3be 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -23,6 +23,8 @@ struct parser_state {
 	struct scope			*scopes[SCOPE_NEST_MAX];
 	unsigned int			scope;
 
+	unsigned int			flex_state_pop;
+	unsigned int			startcond_type;
 	struct list_head		*cmds;
 };
 
diff --git a/src/scanner.l b/src/scanner.l
index a73ce1b819d8..01e1dca52fdd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1017,11 +1017,28 @@ void scanner_destroy(struct nft_ctx *nft)
 
 static void scanner_push_start_cond(void *scanner, enum startcond_type type)
 {
+	struct parser_state *state = yyget_extra(scanner);
+
+	state->startcond_type = type;
 	yy_push_state((int)type, scanner);
 }
 
 void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 {
+	struct parser_state *state = yyget_extra(scanner);
+
+	if (state->startcond_type != t) {
+		state->flex_state_pop++;
+		return; /* Can't pop just yet! */
+	}
+
+	while (state->flex_state_pop) {
+		state->flex_state_pop--;
+		state->startcond_type = yy_top_state(scanner);
+		yy_pop_state(scanner);
+	}
+
+	state->startcond_type = yy_top_state(scanner);
 	yy_pop_state(scanner);
 	(void)yy_top_state(scanner); /* suppress gcc warning wrt. unused function */
 }
-- 
2.26.2

