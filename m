Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1A5EE4993
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 09:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjHWJ7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbjHWJzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 05:55:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3AE4E
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 02:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6FwGl4Ijeg3rJRLm5x+ZBY0G7mhhVbg2UbNN6CuDxgg=; b=Z2YxNCiaWooelgoAgAF/xE+nfG
        k334pa7fiuwm5E72rc1KAB1JrKZzSh718KHFE1C/jkZ0XOTkxm8x9DkUGGwe6aLEyPmsB54hsBx1V
        nEUc3w97zjiRYhC+vwfrrOHlLVXZrrPrihfCbDlBBD3QrgAqc1Ll1jotOPxzu+4zSMki4A4sH6dsN
        1JtAulOCugIkKq593Dv/zGhB59El35MPYsgfy3ffMzckGCFwIQGu3KqFrIL+Dl3Jp26Ei/j14/Af5
        WOq+M2DvEjiF8O9XPqG+lkj/xynMhJyE64GEB4YLn861n/jtqYp9KXZyi/asnS49UOzUJmlgYsq5O
        LMyW0EIQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qYkXf-0002pn-6o; Wed, 23 Aug 2023 11:52:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] tests: shell: Stabilize sets/reset_command_0 test
Date:   Wed, 23 Aug 2023 11:54:04 +0200
Message-ID: <20230823095404.10494-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Timeout/expiry value testing based on seconds is way too fragile,
especially with slow debug kernels. Rewrite the unit to test
minute-based values. This means it is no longer feasible to wait for
values to sufficiently change, so instead specify an 'expires' value
when creating the ruleset and drop the 'sleep' call.

While being at it:

- Combine 'get element' and 'reset element' calls into one, assert the
  relevant (sanitized) line appears twice in output instead of comparing
  with 'diff'.
- Turn comments into 'echo' calls to help debugging if the test fails.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/reset_command_0 | 87 ++++++++++++----------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index 7a088aea2c2f4..ad2e16a7d274a 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -1,17 +1,18 @@
 #!/bin/bash
 
 set -e
-set -x
+
+trap '[[ $? -eq 0 ]] || echo FAIL' EXIT
 
 RULESET="table t {
 	set s {
 		type ipv4_addr . inet_proto . inet_service
 		flags interval, timeout
 		counter
-		timeout 30s
+		timeout 30m
 		elements = {
-			1.0.0.1 . udp . 53 counter packets 5 bytes 30,
-			2.0.0.2 . tcp . 22 counter packets 10 bytes 100 timeout 15s
+			1.0.0.1 . udp . 53 counter packets 5 bytes 30 expires 20m,
+			2.0.0.2 . tcp . 22 counter packets 10 bytes 100 timeout 15m expires 10m
 		}
 	}
 	map m {
@@ -24,59 +25,67 @@ RULESET="table t {
 	}
 }"
 
+echo -n "applying test ruleset: "
 $NFT -f - <<< "$RULESET"
+echo OK
 
-sleep 2
-
-drop_ms() {
-	sed 's/s[0-9]*ms/s/g'
+drop_seconds() {
+	sed 's/m[0-9]*s[0-9]*ms/m/g'
 }
-expires_seconds() {
-	sed -n 's/.*expires \([0-9]*\)s.*/\1/p'
+expires_minutes() {
+	sed -n 's/.*expires \([0-9]*\)m.*/\1/p'
 }
 
-# 'reset element' output is supposed to match 'get element' one
-# apart from changing expires ms value
-EXP=$($NFT get element t s '{ 1.0.0.1 . udp . 53 }' | drop_ms)
-OUT=$($NFT reset element t s '{ 1.0.0.1 . udp . 53 }' | drop_ms)
-$DIFF -u <(echo "$EXP") <(echo "$OUT")
-
-EXP=$($NFT get element t m '{ 1.2.3.4 }')
-OUT=$($NFT reset element t m '{ 1.2.3.4 }')
-$DIFF -u <(echo "$EXP") <(echo "$OUT")
+echo -n "get set elem matches reset set elem: "
+elem='element t s { 1.0.0.1 . udp . 53 }'
+[[ $($NFT "get $elem ; reset $elem" | \
+	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
+echo OK
 
-# assert counter value is zeroed
-$NFT get element t s '{ 1.0.0.1 . udp . 53 }' | grep -q 'counter packets 0 bytes 0'
+echo -n "counters and expiry are reset: "
+NEW=$($NFT "get $elem")
+grep -q 'counter packets 0 bytes 0' <<< "$NEW"
+[[ $(expires_minutes <<< "$NEW") -gt 20 ]]
+echo OK
 
-# assert expiry is reset
-VAL=$($NFT get element t s '{ 1.0.0.1 . udp . 53 }' | expires_seconds)
-[[ $VAL -gt 28 ]]
+echo -n "get map elem matches reset map elem: "
+elem='element t m { 1.2.3.4 }'
+[[ $($NFT "get $elem ; reset $elem" | \
+	grep 'elements = ' | uniq | wc -l) == 1 ]]
+echo OK
 
-# assert quota value is reset
+echo -n "quota value is reset: "
 $NFT get element t m '{ 1.2.3.4 }' | grep -q 'quota 50 bytes : 10.2.3.4'
+echo OK
 
-# assert other elements remain unchanged
-$NFT get element t s '{ 2.0.0.2 . tcp . 22 }'
+echo -n "other elements remain the same: "
 OUT=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }')
-grep -q 'counter packets 10 bytes 100 timeout 15s' <<< "$OUT"
-VAL=$(expires_seconds <<< "$OUT")
-[[ $val -lt 14 ]]
+grep -q 'counter packets 10 bytes 100 timeout 15m' <<< "$OUT"
+VAL=$(expires_minutes <<< "$OUT")
+[[ $val -lt 10 ]]
 $NFT get element t m '{ 5.6.7.8 }' | grep -q 'quota 100 bytes used 50 bytes'
+echo OK
 
-# 'reset set' output is supposed to match 'list set' one, again strip the ms values
-EXP=$($NFT list set t s | drop_ms)
-OUT=$($NFT reset set t s | drop_ms)
+echo -n "list set matches reset set: "
+EXP=$($NFT list set t s | drop_seconds)
+OUT=$($NFT reset set t s | drop_seconds)
 $DIFF -u <(echo "$EXP") <(echo "$OUT")
+echo OK
 
-EXP=$($NFT list map t m | drop_ms)
-OUT=$($NFT reset map t m | drop_ms)
+echo -n "list map matches reset map: "
+EXP=$($NFT list map t m)
+OUT=$($NFT reset map t m)
 $DIFF -u <(echo "$EXP") <(echo "$OUT")
+echo OK
 
-# assert expiry of element with custom timeout is correct
-VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_seconds)
-[[ $VAL -lt 15 ]]
+echo -n "reset command respects per-element timeout: "
+VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_minutes)
+[[ $VAL -lt 15 ]]	# custom timeout applies
+[[ $VAL -gt 10 ]]	# expires was reset
+echo OK
 
-# assert remaining elements are now all reset
+echo -n "remaining elements are reset: "
 OUT=$($NFT list ruleset)
 grep -q '2.0.0.2 . tcp . 22 counter packets 0 bytes 0' <<< "$OUT"
 grep -q '5.6.7.8 quota 100 bytes : 50.6.7.8' <<< "$OUT"
+echo OK
-- 
2.41.0

