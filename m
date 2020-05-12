Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C34DC54E8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 11:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40B7320753
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 11:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgELLuJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 07:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbgELLuG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 07:50:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7083C061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 04:50:05 -0700 (PDT)
Received: from localhost ([::1]:44942 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jYTQA-0005us-O2; Tue, 12 May 2020 13:50:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-restore: Fix verbose mode table flushing
Date:   Tue, 12 May 2020 13:49:54 +0200
Message-Id: <20200512114954.5955-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When called with --verbose mode, iptables-nft-restore did not print
anything when flushing the table. Fix this by adding a "manual" mode to
nft_cmd_table_flush(), turning it into a wrapper around '-F' and '-X'
commands, which is exactly what iptables-legacy-restore does to flush a
table. This though requires a real cache, so don't set NFT_CL_FAKE then.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c                            |  7 +-
 iptables/nft-cmd.h                            |  2 +-
 iptables/nft-shared.h                         |  3 +-
 .../ipt-restore/0014-verbose-restore_0        | 76 +++++++++++++++++++
 iptables/xtables-eb.c                         |  2 +-
 iptables/xtables-restore.c                    |  4 +-
 6 files changed, 88 insertions(+), 6 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 9c0901e78703a..51cdfed41519c 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -311,10 +311,15 @@ int nft_cmd_chain_set(struct nft_handle *h, const char *table,
 	return 1;
 }
 
-int nft_cmd_table_flush(struct nft_handle *h, const char *table)
+int nft_cmd_table_flush(struct nft_handle *h, const char *table, bool verbose)
 {
 	struct nft_cmd *cmd;
 
+	if (verbose) {
+		return nft_cmd_rule_flush(h, NULL, table, verbose) &&
+		       nft_cmd_chain_user_del(h, NULL, table, verbose);
+	}
+
 	cmd = nft_cmd_new(h, NFT_COMPAT_TABLE_FLUSH, table, NULL, NULL, -1,
 			  false);
 	if (!cmd)
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index 0e1776ce088bf..ecf7655a4a613 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -65,7 +65,7 @@ int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
 int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
 			 const char *table, void *data, int rulenum,
 			 bool verbose);
-int nft_cmd_table_flush(struct nft_handle *h, const char *table);
+int nft_cmd_table_flush(struct nft_handle *h, const char *table, bool verbose);
 int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
 			  const char *table);
 int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 94437ffe7990c..4440fd17bfeac 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -225,7 +225,8 @@ struct nft_xt_restore_cb {
 	int (*chain_restore)(struct nft_handle *h, const char *chain,
 			     const char *table);
 
-	int (*table_flush)(struct nft_handle *h, const char *table);
+	int (*table_flush)(struct nft_handle *h, const char *table,
+			   bool verbose);
 
 	int (*do_command)(struct nft_handle *h, int argc, char *argv[],
 			  char **table, bool restore);
diff --git a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0 b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
new file mode 100755
index 0000000000000..94bed0ec29c6b
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
@@ -0,0 +1,76 @@
+#!/bin/bash
+
+set -e
+
+DUMP="*filter
+:foo - [0:0]
+:bar - [0:0]
+-A foo -j ACCEPT
+COMMIT
+*nat
+:natfoo - [0:0]
+:natbar - [0:0]
+-A natfoo -j ACCEPT
+COMMIT
+*raw
+:rawfoo - [0:0]
+COMMIT
+*mangle
+:manglefoo - [0:0]
+COMMIT
+*security
+:secfoo - [0:0]
+COMMIT
+"
+
+$XT_MULTI iptables-restore <<< "$DUMP"
+$XT_MULTI ip6tables-restore <<< "$DUMP"
+
+EXPECT="Flushing chain \`INPUT'
+Flushing chain \`FORWARD'
+Flushing chain \`OUTPUT'
+Flushing chain \`bar'
+Flushing chain \`foo'
+Deleting chain \`bar'
+Deleting chain \`foo'
+Flushing chain \`PREROUTING'
+Flushing chain \`INPUT'
+Flushing chain \`OUTPUT'
+Flushing chain \`POSTROUTING'
+Flushing chain \`natbar'
+Flushing chain \`natfoo'
+Deleting chain \`natbar'
+Deleting chain \`natfoo'
+Flushing chain \`PREROUTING'
+Flushing chain \`OUTPUT'
+Flushing chain \`rawfoo'
+Deleting chain \`rawfoo'
+Flushing chain \`PREROUTING'
+Flushing chain \`INPUT'
+Flushing chain \`FORWARD'
+Flushing chain \`OUTPUT'
+Flushing chain \`POSTROUTING'
+Flushing chain \`manglefoo'
+Deleting chain \`manglefoo'
+Flushing chain \`INPUT'
+Flushing chain \`FORWARD'
+Flushing chain \`OUTPUT'
+Flushing chain \`secfoo'
+Deleting chain \`secfoo'"
+
+for ipt in iptables-restore ip6tables-restore; do
+	diff -u -Z <(sort <<< "$EXPECT") <($XT_MULTI $ipt -v <<< "$DUMP" | sort)
+done
+
+DUMP="*filter
+:baz - [0:0]
+-F foo
+-X bar
+-A foo -j ACCEPT
+COMMIT
+"
+
+EXPECT=""
+for ipt in iptables-restore ip6tables-restore; do
+	diff -u -Z <(echo -ne "$EXPECT") <($XT_MULTI $ipt -v --noflush <<< "$DUMP")
+done
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 375a95d1d5c75..6641a21a72d32 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -1155,7 +1155,7 @@ print_zero:
 		/*case 7 :*/ /* atomic-init */
 		/*case 10:*/ /* atomic-save */
 		case 11: /* init-table */
-			nft_cmd_table_flush(h, *table);
+			nft_cmd_table_flush(h, *table, false);
 			return 1;
 		/*
 			replace->command = c;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index a3bb4f00e79c6..eb25ec3dc8398 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -135,7 +135,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		if (h->noflush == 0) {
 			DEBUGP("Cleaning all chains of table '%s'\n", table);
 			if (cb->table_flush)
-				cb->table_flush(h, table);
+				cb->table_flush(h, table, verbose);
 		}
 
 		ret = 1;
@@ -260,7 +260,7 @@ void xtables_restore_parse(struct nft_handle *h,
 	struct nft_xt_restore_state state = {};
 	char buffer[10240] = {};
 
-	if (!h->noflush)
+	if (!verbose && !h->noflush)
 		nft_cache_level_set(h, NFT_CL_FAKE, NULL);
 
 	line = 0;
-- 
2.25.1

