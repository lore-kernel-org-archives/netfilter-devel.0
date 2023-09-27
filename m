Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FB1E82CA5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 15:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjI0PS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjI0PS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 11:18:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96451121
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 08:18:57 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: fix spurious errors in sets/0036add_set_element_expiration_0
Date:   Wed, 27 Sep 2023 17:18:53 +0200
Message-Id: <20230927151853.383416-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add seconds as expiration, otherwise 14m59 reports 14m in minute
granularity, this ensures suficient time in a very slow environment with
debugging instrumentation.

Moreover, drop seconds from original input ruleset when comparing input
and output rulesets.

Fixes: adf38fd84257 ("tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
My second attempt to fix this test.

 tests/shell/testcases/sets/0036add_set_element_expiration_0 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
index 12f10074409f..54e259a93f23 100755
--- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -8,12 +8,14 @@ drop_seconds() {
 
 RULESET="add table ip x
 add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
-add element ip x y { 1.1.1.1 timeout 30m expires 15m }"
+add element ip x y { 1.1.1.1 timeout 30m expires 15m59s }"
+
+test_input=$(echo $RULESET | drop_seconds)
 
 test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | grep -v '# new generation' | drop_seconds)
 
 if [ "$test_output" != "$RULESET" ] ; then
-	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
+	$DIFF -u <(echo "$test_output") <(echo "$test_input")
 	exit 1
 fi
 
-- 
2.30.2

