Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74112C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 09:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 551D3613DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 09:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhI2J0f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:26:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60098 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245010AbhI2J0f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Sep 2021 05:26:35 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id ACA8063595
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 11:23:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: set on cache flags for nested notation
Date:   Wed, 29 Sep 2021 11:24:49 +0200
Message-Id: <20210929092449.503576-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set on the cache flags for the nested notation too, this is fixing nft -f
with two files, one that contains the set declaration and another that
adds a rule that refers to such set.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1474
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c                                  | 10 ++++++++
 tests/shell/testcases/nft-f/0029split_file_0 | 25 ++++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0029split_file_0

diff --git a/src/cache.c b/src/cache.c
index 42e6b65c6d9e..544f64a20396 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -20,6 +20,16 @@
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		if (!cmd->table)
+			break;
+
+		flags |= NFT_CACHE_TABLE |
+			 NFT_CACHE_CHAIN |
+			 NFT_CACHE_SET |
+			 NFT_CACHE_OBJECT |
+			 NFT_CACHE_FLOWTABLE;
+		break;
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_SET:
 	case CMD_OBJ_COUNTER:
diff --git a/tests/shell/testcases/nft-f/0029split_file_0 b/tests/shell/testcases/nft-f/0029split_file_0
new file mode 100755
index 000000000000..0cc547abc37e
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0029split_file_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet filter {
+	set whitelist_v4 {
+		type ipv4_addr;
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority filter;
+	}
+}
+"
+
+$NFT -f - <<< "$RULESET"
+
+RULESET="table inet filter {
+	chain prerouting {
+		ip daddr @whitelist_v4
+	}
+}
+"
+
+$NFT -f - <<< "$RULESET"
-- 
2.30.2

