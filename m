Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B94C433E5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05BC3207F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbgG1S3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:29:02 -0400
Received: from correo.us.es ([193.147.175.20]:44556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732438AbgG1S3C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 14:29:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B56E15AEB2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C717DA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 820CEDA791; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 683E0DA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jul 2020 20:28:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5135A4265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] evaluate: remove table from cache on delete table
Date:   Tue, 28 Jul 2020 20:28:54 +0200
Message-Id: <20200728182854.4473-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200728182854.4473-1-pablo@netfilter.org>
References: <20200728182854.4473-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following ruleset crashes nft if loaded twice, via nft -ef:

 add table inet filter
 delete table inet filter

 table inet filter {
        chain input {
                type filter hook input priority filter; policy drop;
                iifname { "eth0" } counter accept
        }
 }

If the table contains anonymous sets, such as __set0, then delete + add
table might result in nft reusing the existing stale __set0 in the cache.
The problem is that nft gets confused and it reuses the existing stale
__set0 instead of the new anonymous set __set0 with the same name.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                  | 15 +++++++++++++++
 tests/shell/testcases/sets/0053echo_0           | 16 ++++++++++++++++
 tests/shell/testcases/sets/dumps/0053echo_0.nft |  6 ++++++
 3 files changed, 37 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0053echo_0
 create mode 100644 tests/shell/testcases/sets/dumps/0053echo_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 26d73959db58..a84e9609c1ff 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4172,6 +4172,18 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+
+	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	if (!table)
+		return;
+
+	list_del(&table->list);
+	table_free(table);
+}
+
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -4180,7 +4192,10 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
+		return 0;
 	case CMD_OBJ_TABLE:
+		table_del_cache(ctx, cmd);
+		return 0;
 	case CMD_OBJ_FLOWTABLE:
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
diff --git a/tests/shell/testcases/sets/0053echo_0 b/tests/shell/testcases/sets/0053echo_0
new file mode 100755
index 000000000000..6bb03c28b268
--- /dev/null
+++ b/tests/shell/testcases/sets/0053echo_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="add table inet filter
+delete table inet filter
+
+table inet filter {
+        chain input {
+                type filter hook input priority filter; policy drop;
+                iifname { lo } ip saddr { 10.0.0.0/8 } ip daddr { 192.168.100.62 } tcp dport { 2001 } counter accept
+        }
+}
+"
+
+$NFT -ef - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/dumps/0053echo_0.nft b/tests/shell/testcases/sets/dumps/0053echo_0.nft
new file mode 100644
index 000000000000..6a8166360ceb
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0053echo_0.nft
@@ -0,0 +1,6 @@
+table inet filter {
+	chain input {
+		type filter hook input priority filter; policy drop;
+		iifname { "lo" } ip saddr { 10.0.0.0/8 } ip daddr { 192.168.100.62 } tcp dport { 2001 } counter packets 0 bytes 0 accept
+	}
+}
-- 
2.20.1

