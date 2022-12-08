Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF600C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLHAkf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHAke (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:40:34 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED9705E3DD
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:40:32 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     eric@garver.life
Subject: [PATCH nft 2/2,v2] netlink: swap byteorder of value component in concatenation of intervals
Date:   Thu,  8 Dec 2022 01:40:28 +0100
Message-Id: <20221208004028.420544-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 1017d323cafa ("src: support for selectors with different byteorder with
interval concatenations") was incomplete.

Switch byteorder of singleton values in a set that contains
concatenation of intervals. This singleton value is actually represented
as a range in the kernel.

After this patch, if the set represents a concatenation of intervals:

- EXPR_F_INTERVAL denotes the lhs of the interval.
- EXPR_F_INTERVAL_END denotes the rhs of the interval (this flag was
  already used in this way before this patch).

If none of these flags are set on, then the set contains concatenation
of singleton values (no interval flag is set on), in such case, no
byteorder swap is required.

Update tests/shell and tests/py to cover the use-case breakage reported
by Eric.

Reported-by: Eric Garver <eric@garver.life>
Fixes: 1017d323cafa ("src: support for selectors with different byteorder with interval concatenations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c                                 | 34 +++++--
 tests/py/inet/meta.t                          |  2 +
 tests/py/inet/meta.t.json                     | 91 +++++++++++++++++++
 tests/py/inet/meta.t.payload                  | 24 +++++
 tests/shell/testcases/sets/concat_interval_0  |  6 ++
 .../sets/dumps/concat_interval_0.nft          |  7 ++
 6 files changed, 155 insertions(+), 9 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index db5e79f235d0..2ede25b9ce9d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -133,16 +133,23 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	case EXPR_SET_ELEM_CATCHALL:
 		break;
 	default:
-		__netlink_gen_data(key, &nld, false);
-		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 		if (set->set_flags & NFT_SET_INTERVAL &&
 		    key->etype == EXPR_CONCAT && key->field_count > 1) {
+			key->flags |= EXPR_F_INTERVAL;
+			__netlink_gen_data(key, &nld, false);
+			key->flags &= ~EXPR_F_INTERVAL;
+
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
+
 			key->flags |= EXPR_F_INTERVAL_END;
 			__netlink_gen_data(key, &nld, false);
 			key->flags &= ~EXPR_F_INTERVAL_END;
 
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
 					   &nld.value, nld.len);
+		} else {
+			__netlink_gen_data(key, &nld, false);
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 		}
 		break;
 	}
@@ -246,14 +253,14 @@ static int netlink_export_pad(unsigned char *data, const mpz_t v,
 	return netlink_padded_len(i->len) / BITS_PER_BYTE;
 }
 
-static int netlink_gen_concat_data_expr(int end, const struct expr *i,
+static int netlink_gen_concat_data_expr(uint32_t flags, const struct expr *i,
 					unsigned char *data)
 {
 	struct expr *expr;
 
 	switch (i->etype) {
 	case EXPR_RANGE:
-		if (end)
+		if (flags & EXPR_F_INTERVAL_END)
 			expr = i->right;
 		else
 			expr = i->left;
@@ -265,7 +272,7 @@ static int netlink_gen_concat_data_expr(int end, const struct expr *i,
 		i = expr;
 		break;
 	case EXPR_PREFIX:
-		if (end) {
+		if (flags & EXPR_F_INTERVAL_END) {
 			int count;
 			mpz_t v;
 
@@ -281,6 +288,16 @@ static int netlink_gen_concat_data_expr(int end, const struct expr *i,
 		}
 		return netlink_export_pad(data, i->prefix->value, i);
 	case EXPR_VALUE:
+		/* Switch byteorder only once for singleton values when the set
+		 * contains concatenation of intervals.
+		 */
+		if (!(flags & EXPR_F_INTERVAL))
+			break;
+
+		expr = (struct expr *)i;
+		if (expr_basetype(expr)->type == TYPE_INTEGER &&
+		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 		break;
 	default:
 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
@@ -293,14 +310,13 @@ static void __netlink_gen_concat(const struct expr *expr,
 				 struct nft_data_linearize *nld)
 {
 	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
-	int end = expr->flags & EXPR_F_INTERVAL_END;
 	unsigned char data[len];
 	const struct expr *i;
 
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(end, i, data + offset);
+		offset += netlink_gen_concat_data_expr(expr->flags, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
@@ -316,10 +332,10 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(false, i, data + offset);
+		offset += netlink_gen_concat_data_expr(0, i, data + offset);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(true, i, data + offset);
+		offset += netlink_gen_concat_data_expr(EXPR_F_INTERVAL_END, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 0d7d5f255c00..374738a701d6 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -23,3 +23,5 @@ meta obrname "br0";fail
 meta mark set ct mark >> 8;ok
 
 meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 };ok
+ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 };ok
+ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 };ok
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index bc268a2ef2ae..0960a93a2402 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -350,3 +350,94 @@
     }
 ]
 
+
+# ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "mark"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            256
+                        ]
+                    },
+                    {
+                        "concat": [
+                            {
+                                "range": [
+                                    "1.2.3.6",
+                                    "1.2.3.8"
+                                ]
+                            },
+                            {
+                                "range": [
+                                    512,
+                                    768
+                                ]
+                            }
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "mark"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            256
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "5.6.7.8",
+                            512
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index 2b4e6c2d180d..ea54090727fa 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -109,3 +109,27 @@ ip test-inet input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __set%d ]
+
+# ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 }
+__set%d test-inet 87 size 2
+__set%d test-inet 0
+        element 04030201 00010000  - 04030201 00010000  : 0 [end]       element 06030201 00020000  - 08030201 00030000  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ meta load mark => reg 9 ]
+  [ byteorder reg 9 = hton(reg 9, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 }
+__set%d test-inet 3 size 2
+__set%d test-inet 0
+        element 04030201 00000100  : 0 [end]    element 08070605 00000200  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ meta load mark => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
diff --git a/tests/shell/testcases/sets/concat_interval_0 b/tests/shell/testcases/sets/concat_interval_0
index 3812a94d18c8..4d90af9a6557 100755
--- a/tests/shell/testcases/sets/concat_interval_0
+++ b/tests/shell/testcases/sets/concat_interval_0
@@ -9,6 +9,12 @@ RULESET="table ip t {
 		counter
 		elements = { 1.0.0.1 . udp . 53 }
 	}
+	set s2 {
+		type ipv4_addr . mark
+		flags interval
+		elements = { 10.10.10.10 . 0x00000100,
+			     20.20.20.20 . 0x00000200 }
+	}
 }"
 
 $NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/dumps/concat_interval_0.nft b/tests/shell/testcases/sets/dumps/concat_interval_0.nft
index 875ec1d5c6a0..61547c5e75f9 100644
--- a/tests/shell/testcases/sets/dumps/concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/concat_interval_0.nft
@@ -4,4 +4,11 @@ table ip t {
 		flags interval
 		counter
 	}
+
+	set s2 {
+		type ipv4_addr . mark
+		flags interval
+		elements = { 10.10.10.10 . 0x00000100,
+			     20.20.20.20 . 0x00000200 }
+	}
 }
-- 
2.30.2

