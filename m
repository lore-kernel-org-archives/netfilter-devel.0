Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EC6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jul 2022 15:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiGRPFc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbiGRPFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jul 2022 11:05:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9439252A2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 08:05:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2,v3] cache: validate handle string length
Date:   Mon, 18 Jul 2022 17:05:27 +0200
Message-Id: <20220718150527.507265-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Maximum supported string length for handle is NFT_NAME_MAXLEN, report an
error if user is exceeding this limit.

By validating from the cache evaluation phase, both the native and json
parsers handle input are validated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: do not remove filter reset code.

 src/cache.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 9e2fe950a884..2e1bcfcece57 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -16,6 +16,7 @@
 #include <mnl.h>
 #include <libnftnl/chain.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
 
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
@@ -262,6 +263,107 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	return flags;
 }
 
+static int nft_cmd_validate(const struct cmd *cmd, struct list_head *msgs)
+{
+	const struct handle *h = &cmd->handle;
+	const struct location *loc;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		if (h->table.name &&
+		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
+			loc = &h->table.location;
+			goto err_name_too_long;
+		}
+		break;
+	case CMD_OBJ_RULE:
+	case CMD_OBJ_CHAIN:
+	case CMD_OBJ_CHAINS:
+		if (strlen(h->table.name) > NFT_NAME_MAXLEN) {
+			loc = &h->table.location;
+			goto err_name_too_long;
+		}
+		if (h->chain.name &&
+		    strlen(h->chain.name) > NFT_NAME_MAXLEN) {
+			loc = &h->chain.location;
+			goto err_name_too_long;
+		}
+		break;
+	case CMD_OBJ_ELEMENTS:
+	case CMD_OBJ_SET:
+	case CMD_OBJ_SETS:
+	case CMD_OBJ_MAP:
+	case CMD_OBJ_MAPS:
+	case CMD_OBJ_METER:
+	case CMD_OBJ_METERS:
+		if (h->table.name &&
+		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
+			loc = &h->table.location;
+			goto err_name_too_long;
+		}
+		if (h->set.name &&
+		    strlen(h->set.name) > NFT_NAME_MAXLEN) {
+			loc = &h->set.location;
+			goto err_name_too_long;
+		}
+		break;
+	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_FLOWTABLES:
+		if (h->table.name &&
+		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
+			loc = &h->table.location;
+			goto err_name_too_long;
+		}
+		if (cmd->handle.flowtable.name &&
+		    strlen(cmd->handle.flowtable.name) > NFT_NAME_MAXLEN) {
+			loc = &h->flowtable.location;
+			goto err_name_too_long;
+		}
+		break;
+	case CMD_OBJ_INVALID:
+	case CMD_OBJ_EXPR:
+	case CMD_OBJ_RULESET:
+	case CMD_OBJ_MARKUP:
+	case CMD_OBJ_MONITOR:
+	case CMD_OBJ_SETELEMS:
+	case CMD_OBJ_HOOKS:
+		break;
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_COUNTERS:
+	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_QUOTAS:
+	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_LIMITS:
+	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_SECMARKS:
+	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_SYNPROXYS:
+	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_CT_HELPERS:
+	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_EXPECT:
+		if (h->table.name &&
+		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
+			loc = &h->table.location;
+			goto err_name_too_long;
+		}
+		if (h->obj.name &&
+		    strlen(h->obj.name) > NFT_NAME_MAXLEN) {
+			loc = &h->obj.location;
+			goto err_name_too_long;
+		}
+		break;
+	}
+
+	return 0;
+
+err_name_too_long:
+	erec_queue(error(loc, "name too long, %d characters maximum allowed",
+			 NFT_NAME_MAXLEN),
+		   msgs);
+	return -1;
+}
+
 int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		       struct list_head *msgs, struct nft_cache_filter *filter,
 		       unsigned int *pflags)
@@ -270,6 +372,9 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 	struct cmd *cmd;
 
 	list_for_each_entry(cmd, cmds, list) {
+		if (nft_cmd_validate(cmd, msgs) < 0)
+			return -1;
+
 		if (filter->list.table && cmd->op != CMD_LIST)
 			memset(&filter->list, 0, sizeof(filter->list));
 
-- 
2.30.2

