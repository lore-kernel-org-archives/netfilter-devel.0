Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E32C4724C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDCC120661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgD3POk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727108AbgD3POk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:14:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA004C035495
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 08:14:39 -0700 (PDT)
Received: from localhost ([::1]:43950 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jUAta-0008Bi-J6; Thu, 30 Apr 2020 17:14:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] segtree: Fix get element command with prefixes
Date:   Thu, 30 Apr 2020 17:14:08 +0200
Message-Id: <20200430151408.32283-5-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430151408.32283-1-phil@nwl.cc>
References: <20200430151408.32283-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Code wasn't aware of prefix elements in interval sets. With previous
changes in place, they merely need to be accepted in
get_set_interval_find() - value comparison and expression duplication is
identical to ranges.

Extend sets/0034get_element_0 test to cover prefixes as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c                                |  1 +
 tests/shell/testcases/sets/0034get_element_0 | 51 +++++++++++++-------
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 6aa6f97a4ebfe..2b5831f2d64b2 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -702,6 +702,7 @@ static struct expr *get_set_interval_find(const struct table *table,
 
 	list_for_each_entry(i, &set->init->expressions, list) {
 		switch (i->key->etype) {
+		case EXPR_PREFIX:
 		case EXPR_RANGE:
 			range_expr_value_low(val, i);
 			if (left && mpz_cmp(left->key->value, val))
diff --git a/tests/shell/testcases/sets/0034get_element_0 b/tests/shell/testcases/sets/0034get_element_0
index e23dbda09b45c..f174bc37273ca 100755
--- a/tests/shell/testcases/sets/0034get_element_0
+++ b/tests/shell/testcases/sets/0034get_element_0
@@ -2,43 +2,58 @@
 
 RC=0
 
-check() { # (elems, expected)
-	out=$($NFT get element ip t s "{ $1 }")
+check() { # (set, elems, expected)
+	out=$($NFT get element ip t $1 "{ $2 }")
 	out=$(grep "elements =" <<< "$out")
 	out="${out#* \{ }"
 	out="${out% \}}"
-	[[ "$out" == "$2" ]] && return
-	echo "ERROR: asked for '$1', expecting '$2' but got '$out'"
+	[[ "$out" == "$3" ]] && return
+	echo "ERROR: asked for '$2' in set $1, expecting '$3' but got '$out'"
 	((RC++))
 }
 
 RULESET="add table ip t
 add set ip t s { type inet_service; flags interval; }
 add element ip t s { 10, 20-30, 40, 50-60 }
+add set ip t ips { type ipv4_addr; flags interval; }
+add element ip t ips { 10.0.0.1, 10.0.0.5-10.0.0.8 }
+add element ip t ips { 10.0.0.128/25, 10.0.1.0/24, 10.0.2.3-10.0.2.12 }
 "
 
 $NFT -f - <<< "$RULESET"
 
 # simple cases, (non-)existing values and ranges
-check 10 10
-check 11 ""
-check 20-30 20-30
-check 15-18 ""
+check s 10 10
+check s 11 ""
+check s 20-30 20-30
+check s 15-18 ""
 
 # multiple single elements, ranges smaller than present
-check "10, 40" "10, 40"
-check "22-24, 26-28" "20-30, 20-30"
-check 21-29 20-30
+check s "10, 40" "10, 40"
+check s "22-24, 26-28" "20-30, 20-30"
+check s 21-29 20-30
 
 # mixed single elements and ranges
-check "10, 20" "10, 20-30"
-check "10, 22" "10, 20-30"
-check "10, 22-24" "10, 20-30"
+check s "10, 20" "10, 20-30"
+check s "10, 22" "10, 20-30"
+check s "10, 22-24" "10, 20-30"
 
 # non-existing ranges matching elements
-check 10-40 ""
-check 10-20 ""
-check 10-25 ""
-check 25-55 ""
+check s 10-40 ""
+check s 10-20 ""
+check s 10-25 ""
+check s 25-55 ""
+
+# playing with IPs, ranges and prefixes
+check ips 10.0.0.1 10.0.0.1
+check ips 10.0.0.2 ""
+check ips 10.0.1.0/24 10.0.1.0/24
+check ips 10.0.1.2/31 10.0.1.0/24
+check ips 10.0.1.0 10.0.1.0/24
+check ips 10.0.1.3 10.0.1.0/24
+check ips 10.0.1.255 10.0.1.0/24
+check ips 10.0.2.3-10.0.2.12 10.0.2.3-10.0.2.12
+check ips 10.0.2.10 10.0.2.3-10.0.2.12
+check ips 10.0.2.12 10.0.2.3-10.0.2.12
 
 exit $RC
-- 
2.25.1

