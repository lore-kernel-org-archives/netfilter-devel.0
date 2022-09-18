Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E12EECAAD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 17:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiIRRXO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 13:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRRXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 13:23:13 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599511758A
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 10:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e4W97OQ7B8kveL2OyPDQejHsnXpeMJkh7Fx+zvsY3Bc=; b=M9dU1nqt/REqq11toxdn+qtO3z
        zBN05pF54Hx2ap08+EhvlYKUAYxKiGjpbsntof7yp+CtOeIPmquiPOqeNOShHZvBQB6IztgQAeBnI
        LCCG4ZdBGMp+8UkcHy8Pb0vvYq1CWV4vtmpqlyaYQnX9jM5vvysNB8SE2aLv8y5a8Z7bIELXCEazN
        G6JXNmx8cnYvydhmCK5c6jJRSTdn15pswjFinh8vBp8Hv/l/hSbAYE5DHkpauLsNwjyuT5lE93oYq
        fMYUphkqx/k7P6FFbZRoymiAMHibHwubE/xouvijQ4qLO5nX1Cp4/wENlgDRKmjGO9wOyB06L0ZiY
        mme3e11Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oZy0c-004VxI-Gh
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 18:23:10 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/2] segtree: fix decomposition of unclosed intervals containing address prefixes
Date:   Sun, 18 Sep 2022 18:22:12 +0100
Message-Id: <20220918172212.3681553-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220918172212.3681553-1-jeremy@azazel.net>
References: <20220918172212.3681553-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code which decomposes unclosed intervals doesn't check for prefixes.  This
leads to incorrect output for sets which contain these.  For example,

  # nft -f - <<END
  table ip t {
    chain c {
      ip saddr 192.0.0.0/2 drop
      ip saddr 10.0.0.0/8 drop
      ip saddr { 192.0.0.0/2, 10.0.0.0/8 } drop
    }
  }
  table ip6 t {
    chain c {
      ip6 saddr ff00::/8 drop
      ip6 saddr fe80::/10 drop
      ip6 saddr { ff00::/8, fe80::/10 } drop
    }
  }
  END
  # nft list table ip6 t
  table ip6 t {
    chain c {
      ip6 saddr ff00::/8 drop
      ip6 saddr fe80::/10 drop
      ip6 saddr { fe80::/10, ff00::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff } drop
    }
  }
  # nft list table ip t
  table ip t {
    chain c {
      ip saddr 192.0.0.0/2 drop
      ip saddr 10.0.0.0/8 drop
      ip saddr { 10.0.0.0/8, 192.0.0.0-255.255.255.255 } drop
    }
  }

Instead of treating the final unclosed interval as a special case, reuse the
code which correctly handles closed intervals.

Add a shell test-case.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1018156
Fixes: 86b965bdab8d ("segtree: fix decomposition of unclosed intervals")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

tests: shell: add case to test unclosed prefix intervals

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/segtree.c                                 | 21 +++++------------
 .../sets/0071unclosed_prefix_interval_0       | 23 +++++++++++++++++++
 .../dumps/0071unclosed_prefix_interval_0.nft  | 19 +++++++++++++++
 3 files changed, 48 insertions(+), 15 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0071unclosed_prefix_interval_0
 create mode 100644 tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.nft

diff --git a/src/segtree.c b/src/segtree.c
index d15c39f31f3a..ad3821376dae 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -158,6 +158,8 @@ static struct expr *expr_value(struct expr *expr)
 		return expr->left->key;
 	case EXPR_SET_ELEM:
 		return expr->key;
+	case EXPR_VALUE:
+		return expr;
 	default:
 		BUG("invalid expression type %s\n", expr_name(expr));
 	}
@@ -503,7 +505,8 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 	mpz_init(p);
 
 	mpz_sub(range, expr_value(i)->value, expr_value(low)->value);
-	mpz_sub_ui(range, range, 1);
+	if (i->etype != EXPR_VALUE)
+		mpz_sub_ui(range, range, 1);
 
 	mpz_and(p, expr_value(low)->value, range);
 
@@ -619,24 +622,12 @@ void interval_map_decompose(struct expr *set)
 
 	if (!mpz_cmp(i->value, expr_value(low)->value)) {
 		expr_free(i);
-		i = low;
+		compound_expr_add(set, low);
 	} else {
-		i = range_expr_alloc(&low->location,
-				     expr_clone(expr_value(low)), i);
-		i = set_elem_expr_alloc(&low->location, i);
-		if (low->etype == EXPR_MAPPING) {
-			i = mapping_expr_alloc(&i->location, i,
-					       expr_clone(low->right));
-			interval_expr_copy(i->left, low->left);
-		} else {
-			interval_expr_copy(i, low);
-		}
-		i->flags |= EXPR_F_KERNEL;
-
+		add_interval(set, low, i);
 		expr_free(low);
 	}
 
-	compound_expr_add(set, i);
 out:
 	if (catchall)
 		compound_expr_add(set, catchall);
diff --git a/tests/shell/testcases/sets/0071unclosed_prefix_interval_0 b/tests/shell/testcases/sets/0071unclosed_prefix_interval_0
new file mode 100755
index 000000000000..79e3ca7da743
--- /dev/null
+++ b/tests/shell/testcases/sets/0071unclosed_prefix_interval_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+table inet t {
+	set s1 {
+		type ipv4_addr
+		flags interval
+		elements = { 192.0.0.0/2, 10.0.0.0/8 }
+	}
+	set s2 {
+		type ipv6_addr
+		flags interval
+		elements = { ff00::/8, fe80::/10 }
+	}
+	chain c {
+		ip saddr @s1 accept
+		ip6 daddr @s2 accept
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.nft b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.nft
new file mode 100644
index 000000000000..4eed94c2c884
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.nft
@@ -0,0 +1,19 @@
+table inet t {
+	set s1 {
+		type ipv4_addr
+		flags interval
+		elements = { 10.0.0.0/8, 192.0.0.0/2 }
+	}
+
+	set s2 {
+		type ipv6_addr
+		flags interval
+		elements = { fe80::/10,
+			     ff00::/8 }
+	}
+
+	chain c {
+		ip saddr @s1 accept
+		ip6 daddr @s2 accept
+	}
+}
-- 
2.35.1

