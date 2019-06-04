Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59465C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D46A2070B
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFDRcz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56512 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfFDRcy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:54 -0400
Received: from localhost ([::1]:41368 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDIq-0000sy-Vv; Tue, 04 Jun 2019 19:32:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 02/10] src: Utilize CMD_FLUSH for cache->cmd
Date:   Tue,  4 Jun 2019 19:31:50 +0200
Message-Id: <20190604173158.1184-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
References: <20190604173158.1184-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make cache_flush() set cache->cmd to CMD_FLUSH and treat that as a new
highest cache completeness level. Prevent cache_update() from doing its
thing if it's set even if kernel's ruleset is newer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 966948cd7ae90..f6ef1f6b0addd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -225,6 +225,8 @@ static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
  * means more complete. */
 static int cache_completeness(enum cmd_ops cmd)
 {
+	if (cmd == CMD_FLUSH)
+		return 4;
 	if (cmd == CMD_LIST)
 		return 3;
 	if (cmd != CMD_RESET)
@@ -258,7 +260,8 @@ replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
 	if (cache_is_complete(cache, cmd) &&
-	    cache_is_updated(cache, genid))
+	    (cache_is_updated(cache, genid) ||
+	     cache_is_complete(cache, CMD_FLUSH)))
 		return 0;
 
 	if (cache->genid)
@@ -299,7 +302,7 @@ void cache_flush(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 
 	__cache_flush(&cache->list);
 	cache->genid = mnl_genid_get(&ctx);
-	cache->cmd = CMD_LIST;
+	cache->cmd = CMD_FLUSH;
 }
 
 void cache_release(struct nft_cache *cache)
-- 
2.21.0

