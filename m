Return-Path: <SRS0=pWrg=ED=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5BAC55179
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Oct 2020 22:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF6220724
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Oct 2020 22:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbgJ1Wby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:31:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35404 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387973AbgJ1Wbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Oct 2020 18:31:53 -0400
Received: from localhost ([::1]:60792 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kXorH-0000iq-2t; Wed, 28 Oct 2020 18:03:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/shell: Restore testcases/sets/0036add_set_element_expiration_0
Date:   Wed, 28 Oct 2020 18:03:38 +0100
Message-Id: <20201028170338.32033-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts both commits 46b54fdcf266d3d631ffb6102067825d7672db46 and
0e258556f7f3da35deeb6d5cfdec51eafc7db80d.

With both applied, the test succeeded *only* if 'nft monitor' was
running in background, which is equivalent to the original problem
(where the test succeeded only if *no* 'nft monitor' was running).

The test merely exposed a kernel bug, so in fact it is correct.

Fixes: 46b54fdcf266d ("Revert "monitor: do not print generation ID with --echo"")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0036add_set_element_expiration_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
index 7b2e39a3f0406..51ed0f2c1b3e8 100755
--- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -6,7 +6,7 @@ RULESET="add table ip x
 add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
 add element ip x y { 1.1.1.1 timeout 30s expires 15s }"
 
-test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | head -n -1)
+test_output=$($NFT -e -f - <<< "$RULESET" 2>&1)
 
 if [ "$test_output" != "$RULESET" ] ; then
 	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
-- 
2.28.0

