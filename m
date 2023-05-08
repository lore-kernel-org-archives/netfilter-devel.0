Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995F8C77B75
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 06:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjEHGHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 02:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjEHGHa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 02:07:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AEDFA262
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 23:07:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] evaluate: allow stateful statements with anonymous verdict maps
Date:   Mon,  8 May 2023 08:07:18 +0200
Message-Id: <20230508060720.2296-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Evaluation fails to accept stateful statements in verdict maps, relax
the following check for anonymous sets:

test.nft:4:29-35: Error: missing statement in map declaration
                ip saddr vmap { 127.0.0.1 counter : drop, * : accep
                                          ^^^^^^^

The existing code generates correctly the counter in the anonymous
verdict map.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                  | 3 ++-
 tests/shell/testcases/maps/0009vmap_0           | 2 +-
 tests/shell/testcases/maps/dumps/0009vmap_0.nft | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a1c3895cfb02..bc8f437ee7ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1604,7 +1604,8 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 					  "but element has %d", num_set_exprs,
 					  num_elem_exprs);
 		} else if (num_set_exprs == 0) {
-			if (!(set->flags & NFT_SET_EVAL)) {
+			if (!(set->flags & NFT_SET_ANONYMOUS) &&
+			    !(set->flags & NFT_SET_EVAL)) {
 				elem_stmt = list_first_entry(&elem->stmt_list, struct stmt, list);
 				return stmt_error(ctx, elem_stmt,
 						  "missing statement in %s declaration",
diff --git a/tests/shell/testcases/maps/0009vmap_0 b/tests/shell/testcases/maps/0009vmap_0
index 7627c81d99e0..d31e1608f792 100755
--- a/tests/shell/testcases/maps/0009vmap_0
+++ b/tests/shell/testcases/maps/0009vmap_0
@@ -12,7 +12,7 @@ EXPECTED="table inet filter {
 
         chain prerouting {
                 type filter hook prerouting priority -300; policy accept;
-                iif vmap { "lo" : jump wan_input }
+                iif vmap { "lo" counter : jump wan_input }
         }
 }"
 
diff --git a/tests/shell/testcases/maps/dumps/0009vmap_0.nft b/tests/shell/testcases/maps/dumps/0009vmap_0.nft
index c556feceb1aa..c37574ad5fad 100644
--- a/tests/shell/testcases/maps/dumps/0009vmap_0.nft
+++ b/tests/shell/testcases/maps/dumps/0009vmap_0.nft
@@ -8,6 +8,6 @@ table inet filter {
 
 	chain prerouting {
 		type filter hook prerouting priority raw; policy accept;
-		iif vmap { "lo" : jump wan_input }
+		iif vmap { "lo" counter packets 0 bytes 0 : jump wan_input }
 	}
 }
-- 
2.30.2

