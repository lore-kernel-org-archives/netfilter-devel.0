Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D8CC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD55208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfE1VDc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 17:03:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38446 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbfE1VDb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 17:03:31 -0400
Received: from localhost ([::1]:51534 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVjFq-0002J9-B8; Tue, 28 May 2019 23:03:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v4 4/7] src: Restore local entries after cache update
Date:   Tue, 28 May 2019 23:03:20 +0200
Message-Id: <20190528210323.14605-5-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528210323.14605-1-phil@nwl.cc>
References: <20190528210323.14605-1-phil@nwl.cc>
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
Changes since v2:
- Move cache_add_commands() and called helper functions to a better
  place, it calls cache_is_complete().
- Add error handling to cache_add_commands() and helper functions. This
  should cover the case where required ruleset parts have disappeared
  from kernel. Error reporting makes use of {table,chain}_not_found(),
  so prepare a struct eval_ctx which also serves fine for passing
  pointers around.
- Drop cache bug workaround in tests/json_echo.

Changes since v1:
- Don't add anonymous sets to cache when restoring, as suggested by Eric
  Garver.
---
 src/rule.c                  | 83 ++++++++++++++++++++++++++++++++++++-
 tests/json_echo/run-test.py |  6 +--
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 966948cd7ae90..78e0388e41e93 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -242,6 +242,87 @@ static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 	return genid && genid == cache->genid;
 }
 
+static int cache_add_table_cmd(struct eval_ctx *ectx)
+{
+	struct table *table;
+
+	if (table_lookup(&ectx->cmd->handle, &ectx->nft->cache))
+		return 0;
+
+	if (!ectx->cmd->table) {
+		table = table_alloc();
+		handle_merge(&table->handle, &ectx->cmd->handle);
+		table_add_hash(table, &ectx->nft->cache);
+	} else {
+		table_add_hash(table_get(ectx->cmd->table), &ectx->nft->cache);
+	}
+	return 0;
+}
+
+static int cache_add_chain_cmd(struct eval_ctx *ectx)
+{
+	struct table *table;
+	struct chain *chain;
+
+	table = table_lookup(&ectx->cmd->handle, &ectx->nft->cache);
+	if (!table)
+		return table_not_found(ectx);
+
+	if (!ectx->cmd->chain) {
+		if (!chain_lookup(table, &ectx->cmd->handle)) {
+			chain = chain_alloc(NULL);
+			handle_merge(&chain->handle, &ectx->cmd->handle);
+			chain_add_hash(chain, table);
+		}
+	} else if (!chain_lookup(table, &ectx->cmd->chain->handle)) {
+		chain_add_hash(chain_get(ectx->cmd->chain), table);
+	}
+	return 0;
+}
+
+static int cache_add_set_cmd(struct eval_ctx *ectx)
+{
+	struct table *table;
+
+	table = table_lookup(&ectx->cmd->handle, &ectx->nft->cache);
+	if (!table)
+		return table_not_found(ectx);
+
+	if (!set_lookup(table, ectx->cmd->set->handle.set.name))
+		set_add_hash(set_get(ectx->cmd->set), table);
+	return 0;
+}
+
+static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
+{
+	struct eval_ctx ectx = {
+		.nft = nft,
+		.msgs = msgs,
+	};
+	int ret = 0;
+
+	list_for_each_entry(ectx.cmd, &nft->cmds, list) {
+		switch (ectx.cmd->obj) {
+		case CMD_OBJ_TABLE:
+			ret = cache_add_table_cmd(&ectx);
+			break;
+		case CMD_OBJ_CHAIN:
+			ret = cache_add_chain_cmd(&ectx);
+			break;
+		case CMD_OBJ_SET:
+			if (ectx.cmd->set->flags & NFT_SET_ANONYMOUS)
+				continue;
+			ret = cache_add_set_cmd(&ectx);
+			break;
+		default:
+			break;
+		}
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
 int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 {
 	uint16_t genid;
@@ -275,7 +356,7 @@ replay:
 	}
 	cache->genid = genid;
 	cache->cmd = cmd;
-	return 0;
+	return cache_add_commands(nft, msgs);
 }
 
 static void __cache_flush(struct list_head *table_list)
diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 0132b1393860a..7d191292b4dd5 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -270,12 +270,10 @@ add_quota["add"]["quota"]["name"] = "q"
 do_flush()
 
 print "doing multi add"
-# XXX: Add table separately, otherwise this triggers cache bug
-out = do_command(add_table)
-thandle = get_handle(out, add_table["add"])
-add_multi = [ add_chain, add_set, add_rule ]
+add_multi = [ add_table, add_chain, add_set, add_rule ]
 out = do_command(add_multi)
 
+thandle = get_handle(out, add_table["add"])
 chandle = get_handle(out, add_chain["add"])
 shandle = get_handle(out, add_set["add"])
 rhandle = get_handle(out, add_rule["add"])
-- 
2.21.0

