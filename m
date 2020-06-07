Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CD7C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 16:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D522067B
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 16:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgFGQVW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 12:21:22 -0400
Received: from correo.us.es ([193.147.175.20]:40284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgFGQVU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 12:21:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2131B6327
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 18:21:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3416DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 18:21:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9064DA722; Sun,  7 Jun 2020 18:21:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9681DA73F
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 18:21:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 07 Jun 2020 18:21:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 96C7341E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 18:21:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: release dummy rule object from netlink_parse_set_expr()
Date:   Sun,  7 Jun 2020 18:21:12 +0200
Message-Id: <20200607162112.13486-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607162112.13486-1-pablo@netfilter.org>
References: <20200607162112.13486-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_parse_set_expr() creates a dummy rule object to reuse the
existing netlink parser. Release the rule object to fix a memleak.
Zap the statement list to avoid a use-after-free since the statement
needs to remain in place after releasing the rule.

==21601==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 2016 byte(s) in 4 object(s) allocated from:
    #0 0x7f7824b26330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f78245fcebd in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f78245fd016 in xzalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:65
    #3 0x7f782456f0b5 in rule_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/rule.c:623

Add a test to check for set counters.

SUMMARY: AddressSanitizer: 2016 byte(s) leaked in 4 allocation(s).
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c                      |  8 +++++++-
 tests/shell/testcases/sets/0048set_counters_0  | 18 ++++++++++++++++++
 .../sets/dumps/0048set_counters_0.nft          | 13 +++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/sets/0048set_counters_0
 create mode 100644 tests/shell/testcases/sets/dumps/0048set_counters_0.nft

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7f7ad2626e14..8de4830c4f80 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1682,13 +1682,19 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 				    const struct nftnl_expr *nle)
 {
 	struct netlink_parse_ctx ctx, *pctx = &ctx;
+	struct handle h = {};
 
-	pctx->rule = rule_alloc(&netlink_location, &set->handle);
+	handle_merge(&h, &set->handle);
+	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_lookup(&set->handle, cache);
 	assert(pctx->table != NULL);
 
 	if (netlink_parse_expr(nle, pctx) < 0)
 		return NULL;
+
+	init_list_head(&pctx->rule->stmts);
+	rule_free(pctx->rule);
+
 	return pctx->stmt;
 }
 
diff --git a/tests/shell/testcases/sets/0048set_counters_0 b/tests/shell/testcases/sets/0048set_counters_0
new file mode 100755
index 000000000000..e62d25df799c
--- /dev/null
+++ b/tests/shell/testcases/sets/0048set_counters_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip x {
+          set y {
+                  typeof ip saddr
+                  counter
+                  elements = { 192.168.10.35, 192.168.10.101, 192.168.10.135 }
+          }
+
+          chain z {
+                  type filter hook output priority filter; policy accept;
+                  ip daddr @y
+          }
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/dumps/0048set_counters_0.nft b/tests/shell/testcases/sets/dumps/0048set_counters_0.nft
new file mode 100644
index 000000000000..2145f6b11b88
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0048set_counters_0.nft
@@ -0,0 +1,13 @@
+table ip x {
+	set y {
+		typeof ip saddr
+		counter
+		elements = { 192.168.10.35 counter packets 0 bytes 0, 192.168.10.101 counter packets 0 bytes 0,
+			     192.168.10.135 counter packets 0 bytes 0 }
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip daddr @y
+	}
+}
-- 
2.20.1

