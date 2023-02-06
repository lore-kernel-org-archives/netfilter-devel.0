Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC86C636D6
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Feb 2023 11:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBFLMG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 06:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBFLMF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 06:12:05 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C97021E1D0
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2023 03:12:03 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: expand chain that contains rules
Date:   Mon,  6 Feb 2023 12:11:59 +0100
Message-Id: <20230206111159.257121-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise rules that this chain contains are ignored. This happens if
you include a file that contains this syntax from another ruleset file:

chain inet filter input2 {
       type filter hook input priority filter; policy accept;
       ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
}

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1655
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c                                    | 48 ++++++++++++-------
 .../testcases/include/0020include_chain_0     | 23 +++++++++
 .../include/dumps/0020include_chain_0.nft     |  6 +++
 3 files changed, 61 insertions(+), 16 deletions(-)
 create mode 100755 tests/shell/testcases/include/0020include_chain_0
 create mode 100644 tests/shell/testcases/include/dumps/0020include_chain_0.nft

diff --git a/src/rule.c b/src/rule.c
index a58fd1f2483a..2bd05db1a75a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1310,6 +1310,25 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 	cmd->num_attrs++;
 }
 
+static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
+{
+	struct rule *rule;
+	struct handle h;
+	struct cmd *new;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &rule->handle);
+		if (chain->flags & CHAIN_F_BINDING) {
+			rule->handle.chain_id = chain->handle.chain_id;
+			rule->handle.chain.location = chain->location;
+		}
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+				&rule->location, rule_get(rule));
+		list_add_tail(&new->list, new_cmds);
+	}
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
@@ -1362,22 +1381,19 @@ void nft_cmd_expand(struct cmd *cmd)
 					&ft->location, flowtable_get(ft));
 			list_add_tail(&new->list, &new_cmds);
 		}
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry(rule, &chain->rules, list) {
-				memset(&h, 0, sizeof(h));
-				handle_merge(&h, &rule->handle);
-				if (chain->flags & CHAIN_F_BINDING) {
-					rule->handle.chain_id =
-						chain->handle.chain_id;
-					rule->handle.chain.location =
-						chain->location;
-				}
-				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-						&rule->location,
-						rule_get(rule));
-				list_add_tail(&new->list, &new_cmds);
-			}
-		}
+		list_for_each_entry(chain, &table->chains, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
+		list_splice(&new_cmds, &cmd->list);
+		break;
+	case CMD_OBJ_CHAIN:
+		chain = cmd->chain;
+		if (!chain)
+			break;
+
+		list_for_each_entry(rule, &chain->rules, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
 		list_splice(&new_cmds, &cmd->list);
 		break;
 	case CMD_OBJ_SET:
diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
new file mode 100755
index 000000000000..8f78e8c606ec
--- /dev/null
+++ b/tests/shell/testcases/include/0020include_chain_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+tmpfile1=$(mktemp -p .)
+if [ ! -w $tmpfile1 ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile1" EXIT # cleanup if aborted
+
+RULESET="table inet filter { }
+include \"$tmpfile1\""
+
+RULESET2="chain inet filter input2 {
+	type filter hook input priority filter; policy accept;
+	ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
+}"
+
+echo "$RULESET2" > $tmpfile1
+
+$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/include/dumps/0020include_chain_0.nft b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
new file mode 100644
index 000000000000..3ad6db14d2f5
--- /dev/null
+++ b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
@@ -0,0 +1,6 @@
+table inet filter {
+	chain input2 {
+		type filter hook input priority filter; policy accept;
+		ip saddr 1.2.3.4 tcp dport { 22, 123, 443 } drop
+	}
+}
-- 
2.30.2

