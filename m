Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D342C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754812081C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 19:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbfEVToS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 15:44:18 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44754 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731773AbfEVToR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 15:44:17 -0400
Received: from localhost ([::1]:57842 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hTX9s-0003To-3S; Wed, 22 May 2019 21:44:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: [nft PATCH v2 3/3] src: Restore local entries after cache update
Date:   Wed, 22 May 2019 21:44:06 +0200
Message-Id: <20190522194406.16827-4-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522194406.16827-1-phil@nwl.cc>
References: <20190522194406.16827-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When batching up multiple commands, one may run into a situation where
the current command requires a cache update while the previous ones
didn't and that causes objects added by previous commands to be removed
from cache. If the current or any following command references any of
these objects, the command is rejected.

Resolve this by copying Florian's solution from iptables-nft: After
droping the whole cache and populating it again with entries fetched
from kernel, use the current list of commands to restore local entries
again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Don't add anonymous sets to cache when restoring, as suggested by Eric
  Garver.
---
 src/rule.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 17bf5bbbe680c..d1a86ea9fadd6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -220,6 +220,78 @@ static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
+static void cache_add_set_cmd(struct nft_ctx *nft, struct cmd *cmd)
+{
+	struct table *table;
+
+	table = table_lookup(&cmd->handle, &nft->cache);
+	if (table == NULL)
+		return;
+
+	if (set_lookup(table, cmd->set->handle.set.name) == NULL)
+		set_add_hash(set_get(cmd->set), table);
+}
+
+static void cache_add_chain_cmd(struct nft_ctx *nft, struct cmd *cmd)
+{
+	struct table *table;
+	struct chain *chain;
+
+	table = table_lookup(&cmd->handle, &nft->cache);
+	if (table == NULL)
+		return;
+
+	if (cmd->chain == NULL) {
+		if (chain_lookup(table, &cmd->handle) == NULL) {
+			chain = chain_alloc(NULL);
+			handle_merge(&chain->handle, &cmd->handle);
+			chain_add_hash(chain, table);
+		}
+		return;
+	}
+	if (chain_lookup(table, &cmd->chain->handle) == NULL)
+		chain_add_hash(chain_get(cmd->chain), table);
+}
+
+static void cache_add_table_cmd(struct nft_ctx *nft, struct cmd *cmd)
+{
+	struct table *table;
+
+	if (table_lookup(&cmd->handle, &nft->cache))
+		return;
+
+	if (cmd->table == NULL) {
+		table = table_alloc();
+		handle_merge(&table->handle, &cmd->handle);
+		table_add_hash(table, &nft->cache);
+	} else {
+		table_add_hash(table_get(cmd->table), &nft->cache);
+	}
+}
+
+static void cache_add_commands(struct nft_ctx *nft)
+{
+	struct cmd *cmd;
+
+	list_for_each_entry(cmd, &nft->cmds, list) {
+		switch (cmd->obj) {
+		case CMD_OBJ_SET:
+			if (cmd->set->flags & NFT_SET_ANONYMOUS)
+				continue;
+			cache_add_set_cmd(nft, cmd);
+			break;
+		case CMD_OBJ_CHAIN:
+			cache_add_chain_cmd(nft, cmd);
+			break;
+		case CMD_OBJ_TABLE:
+			cache_add_table_cmd(nft, cmd);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 /* Return a "score" of how complete local cache will be if
  * cache_init_objects() ran for given cmd. Higher value
  * means more complete. */
@@ -270,6 +342,7 @@ replay:
 	}
 	cache->genid = genid;
 	cache->cmd = cmd;
+	cache_add_commands(nft);
 	return 0;
 }
 
-- 
2.21.0

