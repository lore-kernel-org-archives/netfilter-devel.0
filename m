Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BB5C76197
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DFC20880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733171AbfGPK0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 06:26:55 -0400
Received: from mail.us.es ([193.147.175.20]:60872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732984AbfGPK0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 299FEB6C9A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3926115110
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F33731158E5; Tue, 16 Jul 2019 12:26:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D58A61158E2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B27E84265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/5] cache: incorrect cache flags for create commands
Date:   Tue, 16 Jul 2019 12:26:24 +0200
Message-Id: <20190716102624.4628-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190716102624.4628-1-pablo@netfilter.org>
References: <20190716102624.4628-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft create table testD
 # nft create chain testD test6
 Error: No such file or directory
 create chain testD test6
              ^^^^^

Handle 'create' command just like 'add' and 'insert'. Check for object
types to dump the tables for more fine grain listing, instead of dumping
the whole ruleset.

Fixes: 7df42800cf89 ("src: single cache_update() call to build cache before evaluation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c                                        | 30 +++++++++++++++-------
 tests/shell/testcases/chains/0030create_0          |  6 +++++
 .../shell/testcases/chains/dumps/0030create_0.nft  |  4 +++
 3 files changed, 31 insertions(+), 9 deletions(-)
 create mode 100644 tests/shell/testcases/chains/0030create_0
 create mode 100644 tests/shell/testcases/chains/dumps/0030create_0.nft

diff --git a/src/cache.c b/src/cache.c
index d371c5488d1b..e04ead85c830 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -16,10 +16,29 @@
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
+	case CMD_OBJ_CHAIN:
+	case CMD_OBJ_SET:
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_FLOWTABLE:
+		flags |= NFT_CACHE_TABLE;
+		break;
 	case CMD_OBJ_SETELEM:
-		flags |= NFT_CACHE_SETELEM;
+		flags |= NFT_CACHE_TABLE |
+			 NFT_CACHE_CHAIN |
+			 NFT_CACHE_SET |
+			 NFT_CACHE_OBJECT |
+			 NFT_CACHE_SETELEM;
 		break;
 	case CMD_OBJ_RULE:
+		flags |= NFT_CACHE_TABLE |
+			 NFT_CACHE_CHAIN |
+			 NFT_CACHE_SET |
+			 NFT_CACHE_OBJECT |
+			 NFT_CACHE_FLOWTABLE;
+
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
 			flags |= NFT_CACHE_RULE;
@@ -83,18 +102,11 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 		switch (cmd->op) {
 		case CMD_ADD:
 		case CMD_INSERT:
+		case CMD_CREATE:
 			if (nft_output_echo(&nft->output)) {
 				flags = NFT_CACHE_FULL;
 				break;
 			}
-
-			flags |= NFT_CACHE_TABLE |
-				 NFT_CACHE_CHAIN |
-				 NFT_CACHE_SET |
-				 NFT_CACHE_FLOWTABLE |
-				 NFT_CACHE_OBJECT;
-			/* Fall through */
-		case CMD_CREATE:
 			flags = evaluate_cache_add(cmd, flags);
 			break;
 		case CMD_REPLACE:
diff --git a/tests/shell/testcases/chains/0030create_0 b/tests/shell/testcases/chains/0030create_0
new file mode 100644
index 000000000000..0b457f91f11f
--- /dev/null
+++ b/tests/shell/testcases/chains/0030create_0
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table ip x
+$NFT create chain ip x y
diff --git a/tests/shell/testcases/chains/dumps/0030create_0.nft b/tests/shell/testcases/chains/dumps/0030create_0.nft
new file mode 100644
index 000000000000..8e818d2d05e6
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0030create_0.nft
@@ -0,0 +1,4 @@
+table ip x {
+	chain y {
+	}
+}
-- 
2.11.0

