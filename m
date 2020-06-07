Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3C5C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 13:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B38B2064C
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 13:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgFGNkP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 09:40:15 -0400
Received: from correo.us.es ([193.147.175.20]:38046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgFGNkO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 09:40:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF3B2F9265
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 15:40:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F383DA789
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 15:40:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94BA8DA72F; Sun,  7 Jun 2020 15:40:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29B94DA722;
        Sun,  7 Jun 2020 15:40:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 07 Jun 2020 15:40:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 085D141E4800;
        Sun,  7 Jun 2020 15:40:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sbrivio@redhat.com, nucleo@fedoraproject.org
Subject: [PATCH nft,v2] evaluate: missing datatype definition in implicit_set_declaration()
Date:   Sun,  7 Jun 2020 15:40:07 +0200
Message-Id: <20200607134007.1798-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

set->data from implicit_set_declaration(), otherwise, set_evaluation()
bails out with:

 # nft -f /etc/nftables/inet-filter.nft
 /etc/nftables/inet-filter.nft:8:32-54: Error: map definition does not specify
 mapping data type
                tcp dport vmap { 22 : jump ssh_input }
                               ^^^^^^^^^^^^^^^^^^^^^^^
 /etc/nftables/inet-filter.nft:13:26-52: Error: map definition does not specify
 mapping data type
                 iif vmap { "eth0" : jump wan_input }
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Add a test to cover this case.

Fixes: 7aa08d45031e ("evaluate: Perform set evaluation on implicitly declared (anonymous) sets")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=208093
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add test.

 src/evaluate.c                              | 22 +++++++++++----------
 tests/shell/testcases/maps/0009vmap_0       | 19 ++++++++++++++++++
 tests/shell/testcases/maps/dumps/0009vmap_0 | 13 ++++++++++++
 3 files changed, 44 insertions(+), 10 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0009vmap_0
 create mode 100644 tests/shell/testcases/maps/dumps/0009vmap_0

diff --git a/src/evaluate.c b/src/evaluate.c
index fbc8f1fbd141..fb58c053d4ae 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -80,6 +80,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set);
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     struct expr *key,
+					     struct expr *data,
 					     struct expr *expr)
 {
 	struct cmd *cmd;
@@ -93,6 +94,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
 	set->handle.set.name = xstrdup(name);
 	set->key	= key;
+	set->data	= data;
 	set->init	= expr;
 	set->automerge	= set->flags & NFT_SET_INTERVAL;
 
@@ -1411,7 +1413,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
 	const struct datatype *dtype;
-	struct expr *key;
+	struct expr *key, *data;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
@@ -1430,15 +1432,14 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					  ctx->ectx.byteorder,
 					  ctx->ectx.len, NULL);
 
+		dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
+		data = constant_expr_alloc(&netlink_location, dtype,
+					   dtype->byteorder, ectx.len, NULL);
+
 		mappings = implicit_set_declaration(ctx, "__map%d",
-						    key,
+						    key, data,
 						    mappings);
 
-		dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
-
-		mappings->set->data = constant_expr_alloc(&netlink_location,
-							  dtype, dtype->byteorder,
-							  ectx.len, NULL);
 		if (ectx.len && mappings->set->data->len != ectx.len)
 			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
 
@@ -1898,7 +1899,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_SET:
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
-							 expr_get(left), right);
+							 expr_get(left), NULL,
+							 right);
 			/* fall through */
 		case EXPR_SET_REF:
 			/* Data for range lookups needs to be in big endian order */
@@ -2389,7 +2391,7 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->meter.name,
-					  expr_get(key), set);
+					  expr_get(key), NULL, set);
 
 	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
@@ -3318,7 +3320,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					  ctx->ectx.len, NULL);
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
-						    key, mappings);
+						    key, NULL, mappings);
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
diff --git a/tests/shell/testcases/maps/0009vmap_0 b/tests/shell/testcases/maps/0009vmap_0
new file mode 100755
index 000000000000..7627c81d99e0
--- /dev/null
+++ b/tests/shell/testcases/maps/0009vmap_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table inet filter {
+        chain ssh_input {
+        }
+
+        chain wan_input {
+                tcp dport vmap { 22 : jump ssh_input }
+        }
+
+        chain prerouting {
+                type filter hook prerouting priority -300; policy accept;
+                iif vmap { "lo" : jump wan_input }
+        }
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/dumps/0009vmap_0 b/tests/shell/testcases/maps/dumps/0009vmap_0
new file mode 100644
index 000000000000..540a8af870e3
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0009vmap_0
@@ -0,0 +1,13 @@
+table inet filter {
+	chain ssh_input {
+	}
+
+	chain wan_input {
+		tcp dport vmap { 22 : jump ssh_input }
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority -300; policy accept;
+		iif vmap { "lo" : jump wan_input }
+	}
+}
-- 
2.20.1

