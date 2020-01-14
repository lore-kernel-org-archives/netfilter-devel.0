Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E497C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 16:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BDE92075B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 16:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgANQqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:46:33 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:45646 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbgANQqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 11:46:32 -0500
Received: from localhost ([::1]:58736 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1irPKo-0001eX-Qh; Tue, 14 Jan 2020 17:46:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] cache: Fix for doubled output after reset command
Date:   Tue, 14 Jan 2020 17:46:30 +0100
Message-Id: <20200114164630.2492-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114164630.2492-1-phil@nwl.cc>
References: <20200114164630.2492-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reset command causes a dump of the objects to reset and adds those to
cache. Yet it ignored if the object in question was already there and up
to now CMD_RESET was flagged as NFT_CACHE_FULL.

Tackle this from two angles: First, reduce cache requirements of reset
command to the necessary bits which is table cache. This alone would
suffice if there wasn't interactive mode (and other libnftables users):
A cache containing the objects to reset might be in place already, so
add dumped objects to cache only if they don't exist already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c                                    |  4 +++-
 src/rule.c                                     |  3 ++-
 tests/shell/testcases/sets/0024named_objects_0 | 12 +++++++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 0c28a28d3b554..05f0d68edf03a 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -138,8 +138,10 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 		case CMD_GET:
 			flags = evaluate_cache_get(cmd, flags);
 			break;
-		case CMD_LIST:
 		case CMD_RESET:
+			flags |= NFT_CACHE_TABLE;
+			break;
+		case CMD_LIST:
 		case CMD_EXPORT:
 		case CMD_MONITOR:
 			flags |= NFT_CACHE_FULL;
diff --git a/src/rule.c b/src/rule.c
index 57f1fc838399d..883b070720259 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2582,7 +2582,8 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	ret = netlink_reset_objs(ctx, cmd, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
 		table = table_lookup(&obj->handle, &ctx->nft->cache);
-		list_move(&obj->list, &table->objs);
+		if (!obj_lookup(table, obj->handle.obj.name, obj->type))
+			list_move(&obj->list, &table->objs);
 	}
 	if (ret < 0)
 		return ret;
diff --git a/tests/shell/testcases/sets/0024named_objects_0 b/tests/shell/testcases/sets/0024named_objects_0
index 3bd16f2fd028b..21200c3cca3cd 100755
--- a/tests/shell/testcases/sets/0024named_objects_0
+++ b/tests/shell/testcases/sets/0024named_objects_0
@@ -35,4 +35,14 @@ table inet x {
 set -e
 $NFT -f - <<< "$RULESET"
 
-$NFT reset counter inet x user321
+EXPECTED="table inet x {
+	counter user321 {
+		packets 12 bytes 1433
+	}
+}"
+
+GET="$($NFT reset counter inet x user321)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.24.1

