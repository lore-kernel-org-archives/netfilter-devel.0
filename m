From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] hash: generate a random seed if seed option is empty
Date: Mon,  3 Apr 2017 16:29:57 +0800
Message-ID: <1491208197-5493-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:39470 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdDCIak (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2017 04:30:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Typing the "nft add rule x y ct mark set jhash ip saddr mod 2" will
not generate a random seed, instead, the seed will always be zero.

So if seed option is empty, we shoulde not set the NFTA_HASH_SEED
attribute, then a random seed will be generted in the kernel.

Also: just to keep it simple, "seed 0" is equal to "seed opt is empty",
since this is not a big problem.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 Note, another kernel patch is necessary to avoid the annoying warning
 from "nft-test.py ip/hash.t":
 ip/hash.t: WARNING: line: 5: 'src/nft add rule --debug=netlink ip test-ip4
 pre ct mark set jhash ip saddr . ip daddr mod 2': 'ct mark set jhash ip saddr
 . ip daddr mod 2' mismatches 'ct mark set jhash ip saddr . ip daddr mod 2
 seed 0xd6ab633c'

 src/netlink_linearize.c    | 3 ++-
 tests/py/ip/hash.t         | 1 +
 tests/py/ip/hash.t.payload | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b2f27b7..0dba658 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -139,7 +139,8 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 	}
 	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
+	if (expr->hash.seed)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_TYPE, expr->hash.type);
 	nftnl_rule_add_expr(ctx->nlr, nle);
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
index 2becef6..a8e975b 100644
--- a/tests/py/ip/hash.t
+++ b/tests/py/ip/hash.t
@@ -3,6 +3,7 @@
 
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef;ok
 ct mark set jhash ip saddr . ip daddr mod 2;ok
+ct mark set jhash ip saddr . ip daddr mod 2 seed 0x0;ok;ct mark set jhash ip saddr . ip daddr mod 2
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100;ok
 ct mark set jhash ip saddr . ip daddr mod 2 offset 100;ok
 dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index 21227e9..71ab065 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -12,6 +12,13 @@ ip test-ip4 pre
   [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set jhash ip saddr . ip daddr mod 2 seed 0x0
+ip test-ip4 pre
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 ]
+  [ ct set mark with reg 1 ]
+
 # ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100
 ip test-ip4 pre
   [ payload load 4b @ network header + 12 => reg 2 ]
-- 
2.5.5


