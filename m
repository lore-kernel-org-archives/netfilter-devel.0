Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20093ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 13:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA9FD2089C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 13:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389251AbfJQNfC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 09:35:02 -0400
Received: from correo.us.es ([193.147.175.20]:46902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbfJQNfC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 09:35:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6727711EB27
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 15:34:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59004DA7B6
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 15:34:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4EA9A66DF; Thu, 17 Oct 2019 15:34:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6209E59B;
        Thu, 17 Oct 2019 15:34:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 15:34:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F14642EF4E2;
        Thu, 17 Oct 2019 15:34:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] src: restore --echo with anonymous sets
Date:   Thu, 17 Oct 2019 15:34:55 +0200
Message-Id: <20191017133455.17560-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If --echo is passed, then the cache already contains the commands that
have been sent to the kernel. However, anonymous sets are an exception
since the cache needs to be updated in this case.

Remove the old cache logic from the monitor code that has been replaced
by 01e5c6f0ed03 ("src: add cache level flags").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h |  1 -
 src/monitor.c     | 13 ++++++++++++-
 src/rule.c        | 19 -------------------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 279723f33d31..e6941714d5b9 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -171,7 +171,6 @@ struct netlink_mon_handler {
 	struct netlink_ctx	*ctx;
 	const struct location	*loc;
 	unsigned int		debug_mask;
-	bool			cache_needed;
 	struct nft_cache	*cache;
 };
 
diff --git a/src/monitor.c b/src/monitor.c
index 40c381149cda..b7b00d7b1343 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -609,6 +609,12 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 		goto out;
 	}
 
+	if (nft_output_echo(&monh->ctx->nft->output) &&
+	    !(s->flags & NFT_SET_ANONYMOUS)) {
+		set_free(s);
+		goto out;
+	}
+
 	set_add_hash(s, t);
 out:
 	nftnl_set_free(nls);
@@ -636,6 +642,10 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 		goto out;
 	}
 
+	if (nft_output_echo(&monh->ctx->nft->output) &&
+	    !(set->flags & NFT_SET_ANONYMOUS))
+		goto out;
+
 	nlsei = nftnl_set_elems_iter_create(nls);
 	if (nlsei == NULL)
 		memory_allocation_error();
@@ -744,7 +754,8 @@ out:
 static void netlink_events_cache_update(struct netlink_mon_handler *monh,
 					const struct nlmsghdr *nlh, int type)
 {
-	if (!monh->cache_needed)
+	if (nft_output_echo(&monh->ctx->nft->output) &&
+	    type != NFT_MSG_NEWSET && type != NFT_MSG_NEWSETELEM)
 		return;
 
 	switch (type) {
diff --git a/src/rule.c b/src/rule.c
index d4d4add1afab..54290ec1e4a7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2502,23 +2502,6 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static bool need_cache(const struct cmd *cmd)
-{
-	/*
-	 *  - new rules in default format
-	 *  - new elements
-	 */
-	if (((cmd->monitor->flags & (1 << NFT_MSG_NEWRULE)) &&
-	    (cmd->monitor->format == NFTNL_OUTPUT_DEFAULT)) ||
-	    (cmd->monitor->flags & (1 << NFT_MSG_NEWSETELEM)))
-		return true;
-
-	if (cmd->monitor->flags & (1 << NFT_MSG_TRACE))
-		return true;
-
-	return false;
-}
-
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct netlink_mon_handler monhandler = {
@@ -2533,8 +2516,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (nft_output_json(&ctx->nft->output))
 		monhandler.format = NFTNL_OUTPUT_JSON;
 
-	monhandler.cache_needed = need_cache(cmd);
-
 	return netlink_monitor(&monhandler, ctx->nft->nf_sock);
 }
 
-- 
2.11.0

