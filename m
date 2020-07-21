Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECCDC433E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 17:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB1F3206E9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 17:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgGURJe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgGURJe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 13:09:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D94C061794
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 10:09:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxvlj-0002pf-Cl; Tue, 21 Jul 2020 19:09:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: permit get element on maps
Date:   Tue, 21 Jul 2020 19:09:22 +0200
Message-Id: <20200721170922.3705-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its possible to add an element to a map, but you can't read it back:

before:
nft add element inet filter test "{ 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x42 }"
nft get element inet filter test "{ 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x42 }"
Error: No such file or directory; did you mean map ‘test’ in table inet ‘filter’?
get element inet filter test { 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x42 }
                        ^^^^
after:
nft get element inet filter test "{ 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x42 }"
table inet filter {
        map test {
                type ipv4_addr . ether_addr . inet_service : mark
                flags interval,timeout
                elements = { 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x00000042 }
        }
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 67eb5d6014fb..d139d77cbcf1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4136,20 +4136,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table;
-	struct set *set;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
-			return table_not_found(ctx);
-
-		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set_is_map(set->flags))
-			return set_not_found(ctx, &ctx->cmd->handle.set.location,
-					     ctx->cmd->handle.set.name);
-
 		return setelem_evaluate(ctx, &cmd->expr);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
2.26.2

