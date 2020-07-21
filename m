Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4D1C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 00:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7409E207FC
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 00:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGUAX5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:23:57 -0400
Received: from correo.us.es ([193.147.175.20]:38590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgGUAX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 20:23:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF5C2C4800
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 02:23:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1A49DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 02:23:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D754CDA73D; Tue, 21 Jul 2020 02:23:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6DD0DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 02:23:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Jul 2020 02:23:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9515E4265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 02:23:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] rule: flush set cache before flush command
Date:   Tue, 21 Jul 2020 02:23:50 +0200
Message-Id: <20200721002350.5673-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flush the set cache before adding the flush command to the netlink batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add testcase.

 src/rule.c                                       | 16 ++++++++++++++++
 tests/shell/testcases/sets/0052overlap_0         | 16 ++++++++++++++++
 .../shell/testcases/sets/dumps/0052overlap_0.nft |  8 ++++++++
 3 files changed, 40 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0052overlap_0
 create mode 100644 tests/shell/testcases/sets/dumps/0052overlap_0.nft

diff --git a/src/rule.c b/src/rule.c
index fa1861403ba1..6b71dfee0d09 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2692,6 +2692,21 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	return do_list_obj(ctx, cmd, type);
 }
 
+static void flush_set_cache(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+	struct set *set;
+
+	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	assert(table);
+	set = set_lookup(table, cmd->handle.set.name);
+	assert(set);
+	if (set->init != NULL) {
+		expr_free(set->init);
+		set->init = NULL;
+	}
+}
+
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -2701,6 +2716,7 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 	case CMD_OBJ_METER:
+		flush_set_cache(ctx, cmd);
 		return mnl_nft_setelem_flush(ctx, cmd);
 	case CMD_OBJ_RULESET:
 		return mnl_nft_table_del(ctx, cmd);
diff --git a/tests/shell/testcases/sets/0052overlap_0 b/tests/shell/testcases/sets/0052overlap_0
new file mode 100755
index 000000000000..c2960945c492
--- /dev/null
+++ b/tests/shell/testcases/sets/0052overlap_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="add table ip filter
+add set ip filter w_all {type ipv4_addr; flags interval; auto-merge}
+add element ip filter w_all {10.10.10.10, 10.10.10.11}
+"
+
+$NFT -f - <<< "$EXPECTED"
+
+EXPECTED="flush set ip filter w_all
+add element ip filter w_all {10.10.10.10, 10.10.10.253}
+"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/dumps/0052overlap_0.nft b/tests/shell/testcases/sets/dumps/0052overlap_0.nft
new file mode 100644
index 000000000000..1cc02ada94b8
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0052overlap_0.nft
@@ -0,0 +1,8 @@
+table ip filter {
+	set w_all {
+		type ipv4_addr
+		flags interval
+		auto-merge
+		elements = { 10.10.10.10, 10.10.10.253 }
+	}
+}
-- 
2.20.1

