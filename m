Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F177C4649B
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 12:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E2752082E
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 12:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfGEMPM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 08:15:12 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51010 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGEMPM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 08:15:12 -0400
Received: from localhost ([::1]:35866 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hjN7O-00033f-FG; Fri, 05 Jul 2019 14:15:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, anon.amish@gmail.com
Subject: [nft PATCH v2] evaluate: Accept ranges of N-N
Date:   Fri,  5 Jul 2019 14:15:05 +0200
Message-Id: <20190705121505.26466-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Trying to add a range of size 1 was previously not allowed:

| # nft add element ip t s '{ 40-40 }'
| Error: Range has zero or negative size
| add element ip t s { 40-40 }
|                      ^^^^^

The error message is not correct: If a range 40-41 is of size 2 (it
contains elements 40 and 41), a range 40-40 must be of size 1.

Handling this is even supported already: If a single element is added to
an interval set, it is converted into just this range. The implication
is that on output, previous input of '40-40' is indistinguishable from
single element input '40'.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1312
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Simplify fix (actual merging neither necessary nor beneficial), adjust
  commit message accordingly.
- Add test case.
---
 src/evaluate.c                                |  4 +--
 .../sets/0036single_item_intervals_0          | 35 +++++++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0036single_item_intervals_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 8086f750417a7..d2a4914f2ec39 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -951,9 +951,9 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = range->right;
 
-	if (mpz_cmp(left->value, right->value) >= 0)
+	if (mpz_cmp(left->value, right->value) > 0)
 		return expr_error(ctx->msgs, range,
-				  "Range has zero or negative size");
+				  "Range has negative size");
 
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
diff --git a/tests/shell/testcases/sets/0036single_item_intervals_0 b/tests/shell/testcases/sets/0036single_item_intervals_0
new file mode 100755
index 0000000000000..237ad6dd98e5a
--- /dev/null
+++ b/tests/shell/testcases/sets/0036single_item_intervals_0
@@ -0,0 +1,35 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet t {
+	set s {
+		type ipv4_addr
+		flags interval
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
+$NFT add element inet t s '{ 1.1.1.1-1.1.1.1 }'
+$NFT add element inet t s '{ 2.2.2.2-2.2.2.2 }'
+
+$NFT create element inet t s '{ 1.1.1.1 }' && exit 1
+$NFT create element inet t s '{ 1.1.1.1-1.1.1.1 }' && exit 1
+
+EXPECT="table inet t {
+	set s {
+		type ipv4_addr
+		flags interval
+		elements = { 1.1.1.1, 2.2.2.2 }
+	}
+}"
+GET=$($NFT list set inet t s)
+
+if [ "$EXPECT" != "$GET" ]; then
+	DIFF="$(which diff)"
+	[ -x "$DIFF" ] && $DIFF -u <(echo "$EXPECT") <(echo "$GET")
+	exit 1
+fi
+
+$NFT delete element inet t s '{ 2.2.2.2 }'
+$NFT delete element inet t s '{ 1.1.1.1-1.1.1.1 }'
-- 
2.21.0

