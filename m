Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7661FC07E95
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3AA61369
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhGMSix (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:38:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38658 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMSix (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jul 2021 14:38:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 120F361835
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jul 2021 20:35:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v3 1/3] src: remove STMT_NAT_F_INTERVAL flags and interval keyword
Date:   Tue, 13 Jul 2021 20:35:55 +0200
Message-Id: <20210713183557.32398-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

STMT_NAT_F_INTERVAL is not useful, the keyword interval can be removed
to simplify the syntax, e.g.

 snat to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }

This patch reworks 9599d9d25a6b ("src: NAT support for intervals in
maps").

Do not remove STMT_NAT_F_INTERVAL yet since this flag is needed for
interval concatenations coming in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Formerly "src: infer interval from set", rewrite patch description.

 src/evaluate.c                                | 20 -------------------
 src/json.c                                    |  2 --
 src/netlink_delinearize.c                     |  1 -
 src/parser_bison.y                            |  8 ++------
 src/statement.c                               |  2 --
 tests/py/ip/snat.t                            |  2 +-
 tests/py/ip/snat.t.payload                    |  2 +-
 tests/shell/testcases/sets/0047nat_0          |  2 +-
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  2 +-
 9 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index dbc773d164ed..13888e5b476d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3200,26 +3200,6 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 			return err;
 	}
 
-	if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL) {
-		switch (stmt->nat.addr->etype) {
-		case EXPR_MAP:
-			if (!(stmt->nat.addr->mappings->set->data->flags & EXPR_F_INTERVAL))
-				return expr_error(ctx->msgs, stmt->nat.addr,
-						  "map is not defined as interval");
-			break;
-		case EXPR_RANGE:
-		case EXPR_PREFIX:
-			break;
-		default:
-			return expr_error(ctx->msgs, stmt->nat.addr,
-					  "neither prefix, range nor map expression");
-		}
-
-		stmt->flags |= STMT_F_TERMINAL;
-
-		return 0;
-	}
-
 	if (stmt->nat.proto != NULL) {
 		err = nat_evaluate_transport(ctx, stmt, &stmt->nat.proto);
 		if (err < 0)
diff --git a/src/json.c b/src/json.c
index f111ad678f8a..edc9d640bbbc 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1329,8 +1329,6 @@ static json_t *nat_type_flags_json(uint32_t type_flags)
 {
 	json_t *array = json_array();
 
-	if (type_flags & STMT_NAT_F_INTERVAL)
-		json_array_append_new(array, json_string("interval"));
 	if (type_flags & STMT_NAT_F_PREFIX)
 		json_array_append_new(array, json_string("prefix"));
 	if (type_flags & STMT_NAT_F_CONCAT)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fd994b8bdde6..a4ae938a5749 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1119,7 +1119,6 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 
 	if (is_nat_addr_map(addr, family)) {
 		stmt->nat.family = family;
-		stmt->nat.type_flags |= STMT_NAT_F_INTERVAL;
 		ctx->stmt = stmt;
 		return;
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 872d7cdb92ad..790cd832b742 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3623,28 +3623,24 @@ nat_stmt_args		:	stmt_expr
 			{
 				$<stmt>0->nat.family = $1;
 				$<stmt>0->nat.addr = $4;
-				$<stmt>0->nat.type_flags = STMT_NAT_F_INTERVAL;
 			}
 			|	INTERVAL TO	stmt_expr
 			{
 				$<stmt>0->nat.addr = $3;
-				$<stmt>0->nat.type_flags = STMT_NAT_F_INTERVAL;
 			}
 			|	nf_key_proto PREFIX TO	stmt_expr
 			{
 				$<stmt>0->nat.family = $1;
 				$<stmt>0->nat.addr = $4;
 				$<stmt>0->nat.type_flags =
-						STMT_NAT_F_PREFIX |
-						STMT_NAT_F_INTERVAL;
+						STMT_NAT_F_PREFIX;
 				$<stmt>0->nat.flags |= NF_NAT_RANGE_NETMAP;
 			}
 			|	PREFIX TO	stmt_expr
 			{
 				$<stmt>0->nat.addr = $3;
 				$<stmt>0->nat.type_flags =
-						STMT_NAT_F_PREFIX |
-						STMT_NAT_F_INTERVAL;
+						STMT_NAT_F_PREFIX;
 				$<stmt>0->nat.flags |= NF_NAT_RANGE_NETMAP;
 			}
 			;
diff --git a/src/statement.c b/src/statement.c
index dfd275104c59..6db7e3975860 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -677,8 +677,6 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			nft_print(octx, " addr . port");
 		else if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
 			nft_print(octx, " prefix");
-		else if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
-			nft_print(octx, " interval");
 
 		nft_print(octx, " to");
 	}
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index c6e8a8e68f9d..56ab943e8b97 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -10,5 +10,5 @@ iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
 
 snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
-snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
+snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
 snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 };ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index ef4c1ce9f150..2a03ff1f95a0 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -69,7 +69,7 @@ ip
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 proto_min reg 9 ]
 
-# snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
+# snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
 	element 040b8d0a  : 0202a8c0 0402a8c0 0 [end]
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index 746a6b6d3450..cb1d4d68d2d2 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -10,7 +10,7 @@ EXPECTED="table ip x {
 
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
-                    snat ip interval to ip saddr map @y
+                    snat to ip saddr map @y
             }
      }
 "
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 70730ef3c56f..e796805471a3 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -8,6 +8,6 @@ table ip x {
 
 	chain y {
 		type nat hook postrouting priority srcnat; policy accept;
-		snat ip interval to ip saddr map @y
+		snat ip to ip saddr map @y
 	}
 }
-- 
2.20.1

