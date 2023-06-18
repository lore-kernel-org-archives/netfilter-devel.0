Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A08AEB64D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jun 2023 16:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjFRQkA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jun 2023 12:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjFRQj7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2023 12:39:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E6EE4C
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2023 09:39:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qAvRT-00040n-Ji; Sun, 18 Jun 2023 18:39:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] cache: include set elements in "nft set list"
Date:   Sun, 18 Jun 2023 18:39:45 +0200
Message-ID: <20230618163951.408565-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make "nft list sets" include set elements in listing by default.
In nftables 1.0.0, "nft list sets" did not include the set elements,
but with "--json" they were included.

1.0.1 and newer never include them.
This causes a problem for people updating from 1.0.0 and relying
on the presence of the set elements.

Change nftables to always include the set elements.
The "--terse" option is honored to get the "no elements" behaviour.

Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")
Link: https://marc.info/?l=netfilter&m=168704941828372&w=2
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/cache.c | 2 ++
 src/rule.c  | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 95adee7f8ac1..becfa57fc335 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -235,6 +235,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_MAPS:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
+		if (!nft_output_terse(&nft->output))
+			flags |= NFT_CACHE_SETELEM;
 		break;
 	case CMD_OBJ_FLOWTABLE:
 		if (filter &&
diff --git a/src/rule.c b/src/rule.c
index 633a5a12486d..305322ea7cc3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1601,8 +1601,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !map_is_literal(set->flags))
 				continue;
-			set_print_declaration(set, &opts, &ctx->nft->output);
-			nft_print(&ctx->nft->output, "%s}%s", opts.tab, opts.nl);
+			set_print(set, &ctx->nft->output);
 		}
 
 		nft_print(&ctx->nft->output, "}\n");
-- 
2.41.0

