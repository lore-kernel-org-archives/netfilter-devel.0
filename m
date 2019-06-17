Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAA8C31E5D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830EE20657
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfFQRSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:18:53 -0400
Received: from mail.us.es ([193.147.175.20]:55842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbfFQRSw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:18:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 881263066A6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:18:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76DDDDA70D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:18:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C488DA710; Mon, 17 Jun 2019 19:18:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CF2BDA702;
        Mon, 17 Jun 2019 19:18:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 19:18:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3AB514265A31;
        Mon, 17 Jun 2019 19:18:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft,v2 3/5] rule: skip cache population from do_command_monitor()
Date:   Mon, 17 Jun 2019 19:18:40 +0200
Message-Id: <20190617171842.1227-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190617171842.1227-1-pablo@netfilter.org>
References: <20190617171842.1227-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_evaluate() already populates the cache before running the monitor
command. Remove this code.

Fixes: 7df42800cf89 ("src: single cache_update() call to build cache before evaluation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: move patch from 4/5 to 3/5.

 src/rule.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 4407b0b0ceaa..bcd1c0bf73e8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2427,8 +2427,6 @@ static bool need_cache(const struct cmd *cmd)
 
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *t;
-	struct set *s;
 	struct netlink_mon_handler monhandler = {
 		.monitor_flags	= cmd->monitor->flags,
 		.format		= cmd->monitor->format,
@@ -2442,36 +2440,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		monhandler.format = NFTNL_OUTPUT_JSON;
 
 	monhandler.cache_needed = need_cache(cmd);
-	if (monhandler.cache_needed) {
-		struct rule *rule, *nrule;
-		struct chain *chain;
-		int ret;
-
-		list_for_each_entry(t, &ctx->nft->cache.list, list) {
-			list_for_each_entry(s, &t->sets, list)
-				s->init = set_expr_alloc(&cmd->location, s);
-
-			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
-				continue;
-
-			/* When tracing we'd like to translate the rule handle
-			 * we receive in the trace messages to the actual rule
-			 * struct to print that out.  Populate rule cache now.
-			 */
-			ret = netlink_list_table(ctx, &t->handle);
-
-			if (ret != 0)
-				/* Shouldn't happen and doesn't break things
-				 * too badly
-				 */
-				continue;
-
-			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-				chain = chain_lookup(t, &rule->handle);
-				list_move_tail(&rule->list, &chain->rules);
-			}
-		}
-	}
 
 	return netlink_monitor(&monhandler, ctx->nft->nf_sock);
 }
-- 
2.11.0

