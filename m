Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E8FC07E96
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF49761369
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhGMSiy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:38:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38660 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMSiy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jul 2021 14:38:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2D2EB62437
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jul 2021 20:35:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v3 2/3] src: infer NAT mapping with concatenation from set
Date:   Tue, 13 Jul 2021 20:35:56 +0200
Message-Id: <20210713183557.32398-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210713183557.32398-1-pablo@netfilter.org>
References: <20210713183557.32398-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the map is anonymous, infer it from the set elements. Otherwise, the
set definition already have an explicit concatenation definition in the
data side of the mapping.

This update simplifies the NAT mapping syntax with concatenations, e.g.

 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series.

 src/evaluate.c                                | 41 ++++++++++++++++++-
 src/json.c                                    |  2 -
 src/statement.c                               |  4 +-
 tests/py/ip/snat.t                            |  2 +-
 tests/py/ip/snat.t.payload                    |  2 +-
 .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
 .../testcases/maps/dumps/nat_addr_port.nft    | 24 +++++------
 7 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 13888e5b476d..7d59e2600224 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1579,6 +1579,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
 		break;
+	case EXPR_SET_REF:
+		/* symbol has been already evaluated to set reference */
+		break;
 	default:
 		BUG("invalid mapping expression %s\n",
 		    expr_name(map->mappings));
@@ -3172,6 +3175,40 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	return err;
 }
 
+static bool nat_concat_map(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *i;
+
+	if (stmt->nat.addr->etype != EXPR_MAP)
+		return false;
+
+	switch (stmt->nat.addr->mappings->etype) {
+	case EXPR_SET:
+		list_for_each_entry(i, &stmt->nat.addr->mappings->expressions, list) {
+			if (i->etype == EXPR_MAPPING &&
+			    i->right->etype == EXPR_CONCAT) {
+				stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
+				return true;
+			}
+		}
+		break;
+	case EXPR_SYMBOL:
+		/* expr_evaluate_map() see EXPR_SET_REF after this evaluation. */
+		if (expr_evaluate(ctx, &stmt->nat.addr->mappings))
+			return false;
+
+		if (stmt->nat.addr->mappings->set->data->etype == EXPR_CONCAT) {
+			stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
+			return true;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -3185,7 +3222,9 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		if (err < 0)
 			return err;
 
-		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
+		if (nat_concat_map(ctx, stmt) ||
+		    stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
+
 			err = stmt_evaluate_nat_map(ctx, stmt);
 			if (err < 0)
 				return err;
diff --git a/src/json.c b/src/json.c
index edc9d640bbbc..63b325afc8d1 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1331,8 +1331,6 @@ static json_t *nat_type_flags_json(uint32_t type_flags)
 
 	if (type_flags & STMT_NAT_F_PREFIX)
 		json_array_append_new(array, json_string("prefix"));
-	if (type_flags & STMT_NAT_F_CONCAT)
-		json_array_append_new(array, json_string("concat"));
 
 	return array;
 }
diff --git a/src/statement.c b/src/statement.c
index 6db7e3975860..06742c04f027 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -673,9 +673,7 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			break;
 		}
 
-		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT)
-			nft_print(octx, " addr . port");
-		else if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
+		if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
 			nft_print(octx, " prefix");
 
 		nft_print(octx, " to");
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index 56ab943e8b97..8aa831111516 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -9,6 +9,6 @@ iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
 
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
 
-snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
+snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
 snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 };ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 2a03ff1f95a0..15f737cdcd95 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -60,7 +60,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 ]
 
-# snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+# snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
 	element 040b8d0a  : 0302a8c0 00005000 0 [end]
diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
index 328c653c9913..b6bc338c55b7 100644
--- a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
@@ -6,6 +6,6 @@ table inet x {
 
 	chain y {
 		type nat hook prerouting priority dstnat; policy accept;
-		meta nfproto ipv4 dnat ip addr . port to ip saddr . ip protocol . tcp dport map @z
+		meta nfproto ipv4 dnat ip to ip saddr . ip protocol . tcp dport map @z
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index 89c3bd145b4d..cf6b957f0a9b 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -27,10 +27,10 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat ip addr . port to ip saddr map @y
-		dnat ip addr . port to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip to ip saddr map @y
+		dnat ip to ip saddr . tcp dport map @z
 		dnat to numgen inc mod 2 map @t1
-		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2
+		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2
 	}
 }
 table ip6 ip6foo {
@@ -60,10 +60,10 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
-		dnat ip6 addr . port to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 to ip6 saddr map @y
+		dnat ip6 to ip6 saddr . tcp dport map @z
 		dnat to numgen inc mod 2 map @t1
-		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2
+		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2
 	}
 }
 table inet inetfoo {
@@ -114,16 +114,16 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
-		meta l4proto tcp meta nfproto ipv4 dnat ip addr . port to ip saddr map @y4
-		meta nfproto ipv4 dnat ip addr . port to ip saddr . tcp dport map @z4
+		meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4
+		meta nfproto ipv4 dnat ip to ip saddr . tcp dport map @z4
 		dnat ip to numgen inc mod 2 map @t1v4
-		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2v4
+		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2v4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
-		meta l4proto tcp meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr map @y6
-		meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp meta nfproto ipv6 dnat ip6 to ip6 saddr map @y6
+		meta nfproto ipv6 dnat ip6 to ip6 saddr . tcp dport map @z6
 		dnat ip6 to numgen inc mod 2 map @t1v6
-		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2v6
+		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2v6
 	}
 }
-- 
2.20.1

