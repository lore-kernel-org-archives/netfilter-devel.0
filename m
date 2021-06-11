Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E5BC48BE0
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80E3613CF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFKRRl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 13:17:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37694 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhFKRRk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 13:17:40 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A240764240
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 19:14:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: restore interval + concatenation in anonymous set
Date:   Fri, 11 Jun 2021 19:15:38 +0200
Message-Id: <20210611171538.14049-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Perform the table and set lookup only for non-anonymous sets, where the
incremental cache update is required.

The problem fixed by 7aa08d45031e ("evaluate: Perform set evaluation on
implicitly declared (anonymous) sets") resurrected after the cache
rework.

 # nft add rule x y tcp sport . tcp dport vmap { ssh . 0-65535 : accept, 0-65535 . ssh : accept }
 BUG: invalid range expression type concat
 nft: expression.c:1422: range_expr_value_low: Assertion `0' failed.
 Abort

Add a test case to make sure this does not happen again.

Fixes: 5ec5c706d993 ("cache: add hashtable cache for table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                  | 17 +++++++++--------
 tests/py/ip/ip.t                |  2 ++
 tests/py/ip/ip.t.payload        |  9 +++++++++
 tests/py/ip/ip.t.payload.bridge | 11 +++++++++++
 tests/py/ip/ip.t.payload.inet   | 11 +++++++++++
 tests/py/ip/ip.t.payload.netdev | 11 +++++++++++
 6 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2ed68aad0392..e638046b33c7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3781,15 +3781,16 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct stmt *stmt;
 	const char *type;
 
-	table = table_cache_find(&ctx->nft->cache.table_cache,
-				 ctx->cmd->handle.table.name,
-				 ctx->cmd->handle.family);
-	if (table == NULL)
-		return table_not_found(ctx);
+	if (!(set->flags & NFT_SET_ANONYMOUS)) {
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 set->handle.table.name,
+					 set->handle.family);
+		if (table == NULL)
+			return table_not_found(ctx);
 
-	if (!(set->flags & NFT_SET_ANONYMOUS) &&
-	    !set_cache_find(table, set->handle.set.name))
-		set_cache_add(set_get(set), table);
+		if (!set_cache_find(table, set->handle.set.name))
+			set_cache_add(set_get(set), table);
+	}
 
 	if (!(set->flags & NFT_SET_INTERVAL) && set->automerge)
 		return set_error(ctx, set, "auto-merge only works with interval sets");
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 43c345cfa385..b74d465fcbe6 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -123,3 +123,5 @@ iif "lo" ip protocol set 1;ok
 
 iif "lo" ip dscp set af23;ok
 iif "lo" ip dscp set cs0;ok
+
+ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 };ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 5ba7d6e963ac..4bb177526971 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -506,3 +506,12 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
+__set%d test-ip4 87 size 1
+__set%d test-ip4 0
+        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index ead3156bc509..c8c1dbadee14 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -662,3 +662,14 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
+__set%d test-bridge 87 size 1
+__set%d test-bridge 0
+        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+bridge
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 0b08e0bf5756..55304fc9d871 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -662,3 +662,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
+__set%d test-inet 87 size 1
+__set%d test-inet 0
+        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+inet
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index a4f56103d09a..712cb3756149 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -662,3 +662,14 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
+__set%d test-netdev 87 size 1
+__set%d test-netdev 0
+        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.20.1

