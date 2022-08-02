Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2959C00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 09:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiHBJlC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 05:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiHBJlB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 05:41:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDA6313E81
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Aug 2022 02:41:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3] parser_json: fix device parsing in netdev family
Date:   Tue,  2 Aug 2022 11:40:51 +0200
Message-Id: <20220802094051.246678-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

json_unpack() function is not designed to take a pre-allocated buffer.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1612
Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing 'set -e' in test.

 src/parser_json.c                 |  3 +--
 tests/shell/testcases/json/netdev | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/json/netdev

diff --git a/src/parser_json.c b/src/parser_json.c
index fb401009a499..9e93927a9a2b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2780,8 +2780,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	struct handle h = {
 		.table.location = *int_loc,
 	};
-	const char *family = "", *policy = "", *type, *hookstr;
-	const char name[IFNAMSIZ];
+	const char *family = "", *policy = "", *type, *hookstr, *name;
 	struct chain *chain;
 	int prio;
 
diff --git a/tests/shell/testcases/json/netdev b/tests/shell/testcases/json/netdev
new file mode 100755
index 000000000000..a16a4f5e030e
--- /dev/null
+++ b/tests/shell/testcases/json/netdev
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+ip link add d0 type dummy || {
+        echo "Skipping, no dummy interface available"
+        exit 0
+}
+trap "ip link del d0" EXIT
+
+set -e
+
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+
+$NFT flush ruleset
+
+RULESET='{"nftables":[{"flush":{"ruleset":null}},{"add":{"table":{"family":"netdev","name":"test_table"}}},{"add":{"chain":{"family":"netdev","table":"test_table","name":"test_chain","type":"filter","hook":"ingress","prio":0,"dev":"d0","policy":"accept"}}}]}'
+
+$NFT -j -f - <<< $RULESET
-- 
2.30.2

