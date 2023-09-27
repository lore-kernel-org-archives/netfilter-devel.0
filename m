Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F4FE82CAE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 16:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjI0Qjo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI0Qjn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 12:39:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A0A391
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 09:39:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v3] tests: shell: fix spurious errors in sets/0036add_set_element_expiration_0
Date:   Wed, 27 Sep 2023 18:39:37 +0200
Message-Id: <20230927163937.757167-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A number of changes to fix spurious errors:

- Add seconds as expiration, otherwise 14m59 reports 14m in minute
  granularity, this ensures suficient time in a very slow environment with
  debugging instrumentation.

- Provide expected output.

- Update sed regular expression to make 'ms' optional and use -E mode.

Fixes: adf38fd84257 ("tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - [ "$test_output" != "$EXPECTED" ], not [ "$test_output" != "$RULESET" ]
    - Make 'ms' optional in sed regular expression
    - Use -E in sed

 .../testcases/sets/0036add_set_element_expiration_0    | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
index 12f10074409f..0fd016e9f857 100755
--- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -3,17 +3,21 @@
 set -e
 
 drop_seconds() {
-       sed 's/m[0-9]*s[0-9]*ms/m/g'
+	sed -E 's/m[0-9]*s([0-9]*ms)?/m/g'
 }
 
 RULESET="add table ip x
+add set ip x y { type ipv4_addr; flags dynamic,timeout; }
+add element ip x y { 1.1.1.1 timeout 30m expires 15m59s }"
+
+EXPECTED="add table ip x
 add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
 add element ip x y { 1.1.1.1 timeout 30m expires 15m }"
 
 test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | grep -v '# new generation' | drop_seconds)
 
-if [ "$test_output" != "$RULESET" ] ; then
-	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
+if [ "$test_output" != "$EXPECTED" ] ; then
+	$DIFF -u <(echo "$test_output") <(echo "$EXPECTED")
 	exit 1
 fi
 
-- 
2.30.2

