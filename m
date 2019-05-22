Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E15EC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEAB32081C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbfEVToR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 15:44:17 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44746 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbfEVToM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 15:44:12 -0400
Received: from localhost ([::1]:57834 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hTX9m-0003Sj-Oi; Wed, 22 May 2019 21:44:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: [nft PATCH v2 1/3] src: update cache if cmd is more specific
Date:   Wed, 22 May 2019 21:44:04 +0200
Message-Id: <20190522194406.16827-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522194406.16827-1-phil@nwl.cc>
References: <20190522194406.16827-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eric Garver <eric@garver.life>

If we've done a partial fetch of the cache and the genid is the same the
cache update will be skipped without fetching the needed items. This
change flushes the cache if the new request is more specific than the
current cache - forcing a cache update which includes the needed items.

Introduces a simple scoring system which reflects how
cache_init_objects() looks at the current command to decide if it is
finished already or not. Then use that in cache_needs_more(): If current
command's score is higher than old command's, cache needs an update.

Fixes: 816d8c7659c1 ("Support 'add/insert rule index <IDX>'")
Signed-off-by: Eric Garver <eric@garver.life>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Folded former "src: Improve cache_needs_more() algorithm" patch into
  this one.
---
 include/nftables.h                            |  1 +
 src/rule.c                                    | 20 +++++++++++++++++++
 .../shell/testcases/cache/0003_cache_update_0 | 14 +++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/include/nftables.h b/include/nftables.h
index b17a16a4adef7..bb9bb2091716d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -81,6 +81,7 @@ struct nft_cache {
 	uint16_t		genid;
 	struct list_head	list;
 	uint32_t		seqnum;
+	uint32_t		cmd;
 };
 
 struct mnl_socket;
diff --git a/src/rule.c b/src/rule.c
index dc75c7cd5fb08..17bf5bbbe680c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -220,6 +220,23 @@ static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
+/* Return a "score" of how complete local cache will be if
+ * cache_init_objects() ran for given cmd. Higher value
+ * means more complete. */
+static int cache_completeness(enum cmd_ops cmd)
+{
+	if (cmd == CMD_LIST)
+		return 3;
+	if (cmd != CMD_RESET)
+		return 2;
+	return 1;
+}
+
+static bool cache_needs_more(enum cmd_ops old_cmd, enum cmd_ops cmd)
+{
+	return cache_completeness(old_cmd) < cache_completeness(cmd);
+}
+
 int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 {
 	uint16_t genid;
@@ -235,6 +252,8 @@ int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
+	if (cache->genid && cache_needs_more(cache->cmd, cmd))
+		cache_release(cache);
 	if (genid && genid == cache->genid)
 		return 0;
 	if (cache->genid)
@@ -250,6 +269,7 @@ replay:
 		return -1;
 	}
 	cache->genid = genid;
+	cache->cmd = cmd;
 	return 0;
 }
 
diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
index deb45db2c43be..fa9b5df380a41 100755
--- a/tests/shell/testcases/cache/0003_cache_update_0
+++ b/tests/shell/testcases/cache/0003_cache_update_0
@@ -27,3 +27,17 @@ EOF
 $NFT -i >/dev/null <<EOF
 add table ip t3; add chain ip t c
 EOF
+
+# The following test exposes a problem with incremental cache update when
+# reading commands from a file that add a rule using the "index" keyword.
+#
+# add rule ip t4 c meta l4proto icmp accept -> rule to reference in next step
+# add rule ip t4 c index 0 drop -> index 0 is not found due to rule cache not
+#                                  being updated
+$NFT -i >/dev/null <<EOF
+add table ip t4; add chain ip t4 c
+add rule ip t4 c meta l4proto icmp accept
+EOF
+$NFT -f - >/dev/null <<EOF
+add rule ip t4 c index 0 drop
+EOF
-- 
2.21.0

