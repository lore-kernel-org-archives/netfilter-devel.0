Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C53FC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 11:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiF0LD1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiF0LDZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 07:03:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA6A663B1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 04:03:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: fix map listing with interface wildcard
Date:   Mon, 27 Jun 2022 13:03:21 +0200
Message-Id: <20220627110321.227867-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft -f - <<'EOF'
 table inet filter {
    chain INPUT {
        iifname vmap {
            "eth0" : jump input_lan,
            "wg*" : jump input_vpn
        }
    }
    chain input_lan {}
    chain input_vpn {}
 }
 EOF
 # nft list ruleset
 nft: segtree.c:578: interval_map_decompose: Assertion `low->len / 8 > 0' failed.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1617
Fixes: 5e393ea1fc0a ("segtree: add string "range" reversal support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                         |  2 +-
 .../shell/testcases/sets/dumps/sets_with_ifnames.nft  | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index f9cac373a5f0..c36497ce6253 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -575,7 +575,7 @@ void interval_map_decompose(struct expr *set)
 
 		if (!mpz_cmp_ui(range, 0)) {
 			if (expr_basetype(low)->type == TYPE_STRING)
-				mpz_switch_byteorder(expr_value(low)->value, low->len / BITS_PER_BYTE);
+				mpz_switch_byteorder(expr_value(low)->value, expr_value(low)->len / BITS_PER_BYTE);
 			low->flags |= EXPR_F_KERNEL;
 			compound_expr_add(set, expr_get(low));
 		} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
index 6b073ae2d090..77a8baf58cef 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -29,11 +29,19 @@ table inet testifsets {
 			     12.2.2.0/24 . "abcdef*" }
 	}
 
+	map map_wild {
+		type ifname : verdict
+		flags interval
+		elements = { "abcdef*" : jump do_nothing,
+			     "eth0" : jump do_nothing }
+	}
+
 	chain v4icmp {
 		iifname @simple counter packets 0 bytes 0
 		iifname @simple_wild counter packets 0 bytes 0
 		iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
 		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
+		iifname vmap @map_wild
 	}
 
 	chain v4icmpc {
@@ -48,4 +56,7 @@ table inet testifsets {
 		ip protocol icmp jump v4icmp
 		ip protocol icmp goto v4icmpc
 	}
+
+	chain do_nothing {
+	}
 }
-- 
2.30.2

