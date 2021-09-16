Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1260AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 11:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF8660F5B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 11:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhIPMAG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:00:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59188 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbhIPMAF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 08:00:05 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7164F63069
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 13:57:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: reset temporary set element stmt list after list splice
Date:   Thu, 16 Sep 2021 13:58:38 +0200
Message-Id: <20210916115838.21724-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reset temporary stmt list to deal with the key_end case which might
result in a jump backward to handle the rhs of the interval.

Reported-by: Martin Zatloukal <slezi2@pvfree.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c                                  |  2 +-
 tests/shell/testcases/maps/0013map_0           | 14 ++++++++++++++
 tests/shell/testcases/maps/dumps/0013map_0.nft | 13 +++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/maps/0013map_0
 create mode 100644 tests/shell/testcases/maps/dumps/0013map_0.nft

diff --git a/src/netlink.c b/src/netlink.c
index 9a0d96f0b546..28a5514ad873 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1324,7 +1324,7 @@ key_end:
 		nftnl_set_elem_expr_foreach(nlse, set_elem_parse_expressions,
 					    &setelem_parse_ctx);
 	}
-	list_splice_tail(&setelem_parse_ctx.stmt_list, &expr->stmt_list);
+	list_splice_tail_init(&setelem_parse_ctx.stmt_list, &expr->stmt_list);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/tests/shell/testcases/maps/0013map_0 b/tests/shell/testcases/maps/0013map_0
new file mode 100755
index 000000000000..70d7fd3b002f
--- /dev/null
+++ b/tests/shell/testcases/maps/0013map_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+flush ruleset
+
+add table ip filter
+add chain ip filter FORWARD { type filter hook forward priority 0; policy drop; }
+add map ip filter forwport { type ipv4_addr . inet_proto . inet_service: verdict; flags interval; counter; }
+add rule ip filter FORWARD iifname enp0s8 ip daddr . ip protocol  . th dport vmap @forwport counter
+add element ip filter forwport { 10.133.89.138 . tcp . 8081: accept }"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.nft b/tests/shell/testcases/maps/dumps/0013map_0.nft
new file mode 100644
index 000000000000..1455877df1bf
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0013map_0.nft
@@ -0,0 +1,13 @@
+table ip filter {
+	map forwport {
+		type ipv4_addr . inet_proto . inet_service : verdict
+		flags interval
+		counter
+		elements = { 10.133.89.138 . tcp . 8081 counter packets 0 bytes 0 : accept }
+	}
+
+	chain FORWARD {
+		type filter hook forward priority filter; policy drop;
+		iifname "enp0s8" ip daddr . ip protocol . th dport vmap @forwport counter packets 0 bytes 0
+	}
+}
-- 
2.20.1

