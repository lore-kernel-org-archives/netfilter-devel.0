Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C822C64ED6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 14:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjB1O4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 09:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjB1O4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 09:56:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1BDD23DB0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 06:55:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3] evaluate: expand value to range when nat mapping contains intervals
Date:   Tue, 28 Feb 2023 15:55:48 +0100
Message-Id: <20230228145548.200579-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the data in the mapping contains a range, then upgrade value to range.
Otherwise, the following error is displayed:

/dev/stdin:11:57-75: Error: Could not process rule: Invalid argument
dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
                                    ^^^^^^^^^^^^^^^^^^^

The kernel rejects this command because userspace sends a single value
while the kernel expects the range that represents the min and the max
IP address to be used for NAT. The upgrade is also done when concatenation
with intervals is used in the rhs of the mapping.

For anonymous sets, expansion cannot be done from expr_evaluate_mapping()
because the EXPR_F_INTERVAL flag is inferred from the elements. For
explicit sets, this can be done from expr_evaluate_mapping() because the
user already specifies the interval flag in the rhs of the map definition.

Update tests/shell and tests/py to improve testing coverage in this case.

Fixes: 9599d9d25a6b ("src: NAT support for intervals in maps")
Fixes: 66746e7dedeb ("src: support for nat with interval concatenation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: extend tests/py.

 src/evaluate.c                                |  47 +++++-
 tests/py/ip/dnat.t                            |   2 +
 tests/py/ip/dnat.t.json                       | 146 ++++++++++++++++++
 tests/py/ip/dnat.t.payload.ip                 |  22 +++
 tests/shell/testcases/sets/0047nat_0          |   6 +
 .../testcases/sets/0067nat_concat_interval_0  |  27 ++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  |   6 +
 .../sets/dumps/0067nat_concat_interval_0.nft  |  16 ++
 8 files changed, 270 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 506c2414b9e8..19faf621bf65 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1805,10 +1805,45 @@ static void map_set_concat_info(struct expr *map)
 	}
 }
 
+static void __mapping_expr_expand(struct expr *i)
+{
+	struct expr *j, *range, *next;
+
+	assert(i->etype == EXPR_MAPPING);
+	switch (i->right->etype) {
+	case EXPR_VALUE:
+		range = range_expr_alloc(&i->location, expr_get(i->right), expr_get(i->right));
+		expr_free(i->right);
+		i->right = range;
+		break;
+	case EXPR_CONCAT:
+		list_for_each_entry_safe(j, next, &i->right->expressions, list) {
+			if (j->etype != EXPR_VALUE)
+				continue;
+
+			range = range_expr_alloc(&j->location, expr_get(j), expr_get(j));
+			list_replace(&j->list, &range->list);
+			expr_free(j);
+		}
+		i->right->flags &= ~EXPR_F_SINGLETON;
+		break;
+	default:
+		break;
+	}
+}
+
+static void mapping_expr_expand(struct expr *init)
+{
+	struct expr *i;
+
+	list_for_each_entry(i, &init->expressions, list)
+		__mapping_expr_expand(i);
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
+	struct expr_ctx ectx = ctx->ectx;
 	const struct datatype *dtype;
 	struct expr *key, *data;
 
@@ -1879,9 +1914,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (binop_transfer(ctx, expr) < 0)
 			return -1;
 
-		if (ctx->set->data->flags & EXPR_F_INTERVAL)
+		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
 			ctx->set->data->len *= 2;
 
+			if (set_is_anonymous(ctx->set->flags))
+				mapping_expr_expand(ctx->set->init);
+		}
+
 		ctx->set->key->len = ctx->ectx.len;
 		ctx->set = NULL;
 		map = *expr;
@@ -1984,6 +2023,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	    data_mapping_has_interval(mapping->right))
 		set->data->flags |= EXPR_F_INTERVAL;
 
+	if (!set_is_anonymous(set->flags) &&
+	    set->data->flags & EXPR_F_INTERVAL)
+		__mapping_expr_expand(mapping);
+
 	if (!(set->data->flags & EXPR_F_INTERVAL) &&
 	    !expr_is_singleton(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index 889f0fd7bf6c..881571db2f83 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -19,3 +19,5 @@ dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 };ok
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 };ok
 ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 };ok
+meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 };ok
+dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 };ok
diff --git a/tests/py/ip/dnat.t.json b/tests/py/ip/dnat.t.json
index ede4d04bdb10..fe15d0726302 100644
--- a/tests/py/ip/dnat.t.json
+++ b/tests/py/ip/dnat.t.json
@@ -595,3 +595,149 @@
     }
 ]
 
+# meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        "10.1.1.136"
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        "1.1.2.69",
+                                        22
+                                    ]
+                                }
+                            ],
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        {
+                                            "range": [
+                                                "10.1.1.1",
+                                                "10.1.1.135"
+                                            ]
+                                        }
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        {
+                                            "range": [
+                                                "1.1.2.66",
+                                                "1.84.236.78"
+                                            ]
+                                        },
+                                        22
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "meta": {
+                                    "key": "iifname"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+[
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        "10.1.1.136"
+                                    ]
+                                },
+                                {
+                                    "prefix": {
+                                        "addr": "1.1.2.69",
+                                        "len": 32
+                                    }
+                                }
+                            ],
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        {
+                                            "range": [
+                                                "10.1.1.1",
+                                                "10.1.1.135"
+                                            ]
+                                        }
+                                    ]
+                                },
+                                {
+                                    "range": [
+                                        "1.1.2.66",
+                                        "1.84.236.78"
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "meta": {
+                                    "key": "iifname"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index e53838a32262..439c6abef03f 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -180,3 +180,25 @@ ip
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
 
+# meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+__map%d test-ip4 8f size 2
+__map%d test-ip4 0
+        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 00001600 45020101 00001600 0 [end]     element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 00001600 4eec5401 00001600 0 [end]
+ip test-ip4 prerouting
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ meta load iifname => reg 1 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
+
+# dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+__map%d test-ip4 8f size 2
+__map%d test-ip4 0
+        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 45020101 0 [end]       element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 4eec5401 0 [end]
+ip test-ip4 prerouting
+  [ meta load iifname => reg 1 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 9 ]
+
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index d19f5b69fd33..4e53b7b8e8c8 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -8,6 +8,12 @@ EXPECTED="table ip x {
 				 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
             }
 
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    meta l4proto tcp dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+                    dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+            }
+
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
                     snat to ip saddr map @y
diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
index 530771b0016c..55cc0d4b43df 100755
--- a/tests/shell/testcases/sets/0067nat_concat_interval_0
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -42,3 +42,30 @@ EXPECTED="table ip nat {
 
 $NFT -f - <<< $EXPECTED
 $NFT add rule ip nat prerouting meta l4proto { tcp, udp } dnat to ip daddr . th dport map @fwdtoip_th
+
+EXPECTED="table ip nat {
+        map ipportmap4 {
+		typeof iifname . ip saddr : interval ip daddr
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat to iifname . ip saddr map @ipportmap4
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+EXPECTED="table ip nat {
+        map ipportmap5 {
+		typeof iifname . ip saddr : interval ip daddr . tcp dport
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 97c04a1637a2..9fa9fc7456c5 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -6,6 +6,12 @@ table ip x {
 			     10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
 	}
 
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+		dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
 	chain y {
 		type nat hook postrouting priority srcnat; policy accept;
 		snat ip to ip saddr map @y
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 3226da157272..6af47c6682ce 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -17,10 +17,26 @@ table ip nat {
 		elements = { 1.2.3.4 . 10000-20000 : 192.168.3.4 . 30000-40000 }
 	}
 
+	map ipportmap4 {
+		type ifname . ipv4_addr : interval ipv4_addr
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
+	map ipportmap5 {
+		type ifname . ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
 		ip protocol tcp dnat ip to ip saddr map @ipportmap
 		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
 		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
+		dnat ip to iifname . ip saddr map @ipportmap4
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
 	}
 }
-- 
2.30.2

