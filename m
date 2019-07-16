Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3B2C76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C07C520880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbfGPK0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 06:26:55 -0400
Received: from mail.us.es ([193.147.175.20]:60876 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732257AbfGPK0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 171A2B6C8B
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7440DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 516051158E8; Tue, 16 Jul 2019 12:26:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 255711153FE
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 12:26:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 02F754265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/5] evaluate: missing object maps handling in list and flush commands
Date:   Tue, 16 Jul 2019 12:26:21 +0200
Message-Id: <20190716102624.4628-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190716102624.4628-1-pablo@netfilter.org>
References: <20190716102624.4628-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFT_SET_OBJECT tells there is an object map.

 # nft list ruleset
 table inet filter {
        map countermap {
                type ipv4_addr : counter
        }
 }

The following command fails:

 # nft flush set inet filter countermap

This patch checks for NFT_SET_OBJECT from new set_is_literal() and
map_is_literal() functions. This patch also adds tests for this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h                              | 15 +++++++++++++++
 src/evaluate.c                              | 13 +++++--------
 tests/shell/testcases/listing/0017objects_0 | 19 +++++++++++++++++++
 tests/shell/testcases/listing/0018data_0    | 19 +++++++++++++++++++
 tests/shell/testcases/listing/0019set_0     | 19 +++++++++++++++++++
 5 files changed, 77 insertions(+), 8 deletions(-)
 create mode 100755 tests/shell/testcases/listing/0017objects_0
 create mode 100755 tests/shell/testcases/listing/0018data_0
 create mode 100755 tests/shell/testcases/listing/0019set_0

diff --git a/include/rule.h b/include/rule.h
index bee1d4474216..42d29b7c910e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -337,6 +337,21 @@ static inline bool set_is_map(uint32_t set_flags)
 	return set_is_datamap(set_flags) || set_is_objmap(set_flags);
 }
 
+static inline bool set_is_anonymous(uint32_t set_flags)
+{
+	return set_flags & NFT_SET_ANONYMOUS;
+}
+
+static inline bool set_is_literal(uint32_t set_flags)
+{
+	return !(set_is_anonymous(set_flags) || set_is_map(set_flags));
+}
+
+static inline bool map_is_literal(uint32_t set_flags)
+{
+	return !(set_is_anonymous(set_flags) || !set_is_map(set_flags));
+}
+
 #include <statement.h>
 
 struct counter {
diff --git a/src/evaluate.c b/src/evaluate.c
index e1a827e723ae..f915187165cc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3630,8 +3630,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS))
-			return cmd_error(ctx,  &ctx->cmd->handle.set.location,
+		else if (!set_is_literal(set->flags))
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
 		return 0;
@@ -3659,8 +3659,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!(set->flags & NFT_SET_MAP) ||
-			 set->flags & NFT_SET_ANONYMOUS)
+		else if (!map_is_literal(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
@@ -3752,10 +3751,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS))
+		else if (!set_is_literal(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
-
 		return 0;
 	case CMD_OBJ_MAP:
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
@@ -3766,8 +3764,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!(set->flags & NFT_SET_MAP) ||
-			 set->flags & NFT_SET_ANONYMOUS)
+		else if (!map_is_literal(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
diff --git a/tests/shell/testcases/listing/0017objects_0 b/tests/shell/testcases/listing/0017objects_0
new file mode 100755
index 000000000000..14d614382e1b
--- /dev/null
+++ b/tests/shell/testcases/listing/0017objects_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+EXPECTED="table inet filter {
+	map countermap {
+		type ipv4_addr : counter
+	}
+}"
+
+set -e
+
+$NFT -f - <<< $EXPECTED
+$NFT flush map inet filter countermap
+
+GET="$($NFT list map inet filter countermap)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0018data_0 b/tests/shell/testcases/listing/0018data_0
new file mode 100755
index 000000000000..767fe13ae65a
--- /dev/null
+++ b/tests/shell/testcases/listing/0018data_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+EXPECTED="table inet filter {
+	map ipmap {
+		type ipv4_addr : ipv4_addr
+	}
+}"
+
+set -e
+
+$NFT -f - <<< $EXPECTED
+$NFT flush map inet filter ipmap
+
+GET="$($NFT list map inet filter ipmap)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0019set_0 b/tests/shell/testcases/listing/0019set_0
new file mode 100755
index 000000000000..04eb0faf74af
--- /dev/null
+++ b/tests/shell/testcases/listing/0019set_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+EXPECTED="table inet filter {
+	set ipset {
+		type ipv4_addr
+	}
+}"
+
+set -e
+
+$NFT -f - <<< $EXPECTED
+$NFT flush set inet filter ipset
+
+GET="$($NFT list set inet filter ipset)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

