Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA155C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 20:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A43456069E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 20:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhIFUGB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 16:06:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40306 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhIFUGB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 16:06:01 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D2C2F6001D
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 22:03:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: rework range_expr_to_prefix()
Date:   Mon,  6 Sep 2021 22:04:51 +0200
Message-Id: <20210906200451.24469-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Consolidate prefix calculation in range_expr_is_prefix().

Add tests/py for 9208fb30dc49 ("src: Check range bounds before converting to
prefix").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c              | 66 ++++++++++++++++--------------
 tests/py/ip/snat.t         |  2 +
 tests/py/ip/snat.t.json    | 84 ++++++++++++++++++++++++++++++++++++++
 tests/py/ip/snat.t.payload | 26 ++++++++++++
 4 files changed, 148 insertions(+), 30 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 0fd0b6647643..9a0d96f0b546 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1048,48 +1048,54 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	}
 }
 
-static bool mpz_bitmask_is_prefix(mpz_t bitmask, uint32_t len)
+static bool range_expr_is_prefix(const struct expr *range, uint32_t *prefix_len)
 {
+	const struct expr *right = range->right;
+	const struct expr *left = range->left;
+	uint32_t len = left->len;
 	unsigned long n1, n2;
+	uint32_t plen;
+	mpz_t bitmask;
 
-        n1 = mpz_scan0(bitmask, 0);
-        if (n1 == ULONG_MAX)
-                return false;
+	mpz_init2(bitmask, left->len);
+	mpz_xor(bitmask, left->value, right->value);
 
-        n2 = mpz_scan1(bitmask, n1 + 1);
-        if (n2 < len)
-                return false;
+	n1 = mpz_scan0(bitmask, 0);
+	if (n1 == ULONG_MAX)
+		goto not_a_prefix;
 
-        return true;
-}
+	n2 = mpz_scan1(bitmask, n1 + 1);
+	if (n2 < len)
+		goto not_a_prefix;
 
-static uint32_t mpz_bitmask_to_prefix(mpz_t bitmask, uint32_t len)
-{
-	return len - mpz_scan0(bitmask, 0);
+	plen = len - n1;
+
+	if (mpz_scan1(left->value, 0) < len - plen)
+		goto not_a_prefix;
+
+	mpz_clear(bitmask);
+	*prefix_len = plen;
+
+	return true;
+
+not_a_prefix:
+	mpz_clear(bitmask);
+
+	return false;
 }
 
 struct expr *range_expr_to_prefix(struct expr *range)
 {
-	struct expr *left = range->left, *right = range->right, *prefix;
-	uint32_t len = left->len, prefix_len;
-	mpz_t bitmask;
-
-	mpz_init2(bitmask, len);
-	mpz_xor(bitmask, left->value, right->value);
+	struct expr *prefix;
+	uint32_t prefix_len;
 
-	if (mpz_bitmask_is_prefix(bitmask, len)) {
-		prefix_len = mpz_bitmask_to_prefix(bitmask, len);
-		if (mpz_scan1(left->value, 0) >= len - prefix_len) {
-			prefix = prefix_expr_alloc(&range->location,
-						   expr_get(left),
-						   prefix_len);
-			mpz_clear(bitmask);
-			expr_free(range);
-
-			return prefix;
-		}
+	if (range_expr_is_prefix(range, &prefix_len)) {
+		prefix = prefix_expr_alloc(&range->location,
+					   expr_get(range->left),
+					   prefix_len);
+		expr_free(range);
+		return prefix;
 	}
-	mpz_clear(bitmask);
 
 	return range;
 }
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index 38acf52ffe09..a8ff8d1a00c1 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -6,6 +6,8 @@ iifname "eth0" tcp dport 80-90 snat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2;ok
 iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
+iifname "eth0" tcp dport 80-90 snat to 192.168.3.0-192.168.3.255;ok;iifname "eth0" tcp dport 80-90 snat to 192.168.3.0/24
+iifname "eth0" tcp dport 80-90 snat to 192.168.3.15-192.168.3.240;ok
 
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
 
diff --git a/tests/py/ip/snat.t.json b/tests/py/ip/snat.t.json
index 0e1485faedfc..0813086c8405 100644
--- a/tests/py/ip/snat.t.json
+++ b/tests/py/ip/snat.t.json
@@ -166,6 +166,90 @@
     }
 ]
 
+# iifname "eth0" tcp dport 80-90 snat to 192.168.3.0-192.168.3.255
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    80,
+                    90
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "prefix": {
+                    "addr": "192.168.3.0",
+                    "len": 24
+                }
+            }
+        }
+    }
+]
+
+# iifname "eth0" tcp dport 80-90 snat to 192.168.3.15-192.168.3.240
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    80,
+                    90
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "range": [
+                    "192.168.3.15",
+                    "192.168.3.240"
+                ]
+            }
+        }
+    }
+]
+
 # snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 [
     {
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 58b1c1a484eb..64f478964a40 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -60,6 +60,32 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 ]
 
+# iifname "eth0" tcp dport 80-90 snat to 192.168.3.0-192.168.3.255
+ip
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00005000 ]
+  [ cmp lte reg 1 0x00005a00 ]
+  [ immediate reg 1 0x0003a8c0 ]
+  [ immediate reg 2 0xff03a8c0 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 2 ]
+
+# iifname "eth0" tcp dport 80-90 snat to 192.168.3.15-192.168.3.240
+ip
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00005000 ]
+  [ cmp lte reg 1 0x00005a00 ]
+  [ immediate reg 1 0x0f03a8c0 ]
+  [ immediate reg 2 0xf003a8c0 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 2 ]
+
 # snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-- 
2.20.1

