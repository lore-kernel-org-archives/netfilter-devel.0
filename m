Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C972C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0EF20B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfFROoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:44:09 -0400
Received: from mail.us.es ([193.147.175.20]:53716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFROoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:44:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A68B9B6323
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96CE2DA704
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9632CDA703; Tue, 18 Jun 2019 16:44:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FE20DA704
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 16:44:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 52B924265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/2] evaluate: allow get/list/flush dynamic sets and maps via list command
Date:   Tue, 18 Jun 2019 16:43:59 +0200
Message-Id: <20190618144400.31411-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before:

 # nft list set ip filter untracked_unknown
 Error: No such file or directory; did you mean set ‘untracked_unknown’ in table ip ‘filter’?
 list set ip filter untracked_unknown
                    ^^^^^^^^^^^^^^^^^

After:

 # nft list set ip filter untracked_unknown
 table ip filter {
        set untracked_unknown {
                type ipv4_addr . inet_service . ipv4_addr . inet_service . inet_proto
                size 100000
                flags dynamic,timeout
        }
 }

Add a testcase for this too.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add testcase.

 src/evaluate.c                              |  6 +++---
 tests/shell/testcases/listing/0015dynamic_0 | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/listing/0015dynamic_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 511f9f14bedd..07617a7c94cb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3520,7 +3520,7 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & (NFT_SET_MAP | NFT_SET_EVAL))
+		if (set == NULL || set->flags & NFT_SET_MAP)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3587,7 +3587,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & (NFT_SET_MAP | NFT_SET_EVAL))
+		if (set == NULL || set->flags & NFT_SET_MAP)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3698,7 +3698,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & (NFT_SET_MAP | NFT_SET_EVAL))
+		if (set == NULL || set->flags & NFT_SET_MAP)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
diff --git a/tests/shell/testcases/listing/0015dynamic_0 b/tests/shell/testcases/listing/0015dynamic_0
new file mode 100755
index 000000000000..5ddc4ad83a50
--- /dev/null
+++ b/tests/shell/testcases/listing/0015dynamic_0
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+# list only the object asked for with table
+
+EXPECTED="table ip filter {
+	set test_set {
+		type ipv4_addr . inet_service . ipv4_addr . inet_service . inet_proto
+		size 100000
+		flags dynamic,timeout
+	}
+}"
+
+set -e
+
+$NFT -f - <<< $EXPECTED
+
+GET="$($NFT list set ip filter test_set)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+$NFT flush set ip filter test_set
-- 
2.11.0

