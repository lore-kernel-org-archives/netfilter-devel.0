Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC98C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjKBPDz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbjKBPDx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 11:03:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF513A
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 08:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3qKY0OAvFHF9/lY4dNI7mPJiHy3GCR4EN/WoQPsYiL0=; b=Ouds54CGw3LP1l45SNvtiD3IiH
        ylnPFsSJP+0wQXMTuGtAKYQs0LzeICtpM3W10mQbdhOmB0l0Q+Cu1M/PPxaasfv8bnUod0s4ub0bX
        ZMy4mqTwcdbCn8bGXPK6WrrS3+F5dgPC2/qRUNyE9wa8VblOhT1jfL7X/A3A/F+dAYlc7mBKfO64J
        Sg0lSFc51GQUutWILLvgfj7h2fSn8HMINmdx+iVdM/YZtb00D68udSRA3D2wF7y9MM/462dmWiWHF
        nkVPMraj9wDMPzb4fPBA1tEefuxvoC/Gp7u1JSbuNKS7jluSUCNPXOFUsSVtJolQSfltQysblaP7d
        kN2hmz8A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qyZEX-0004qT-Jl; Thu, 02 Nov 2023 16:03:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current kernels
Date:   Thu,  2 Nov 2023 16:03:42 +0100
Message-ID: <20231102150342.3543-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel behaviour changed regarding element reset in sets with timeouts,
disable the offending pieces.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/reset_command_0 | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index e663dac831f8c..02d88d291bcf0 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -2,6 +2,10 @@
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_reset_set)
 
+# Note: Element expiry is no longer reset since kernel commit 4c90bba60c26
+# ("netfilter: nf_tables: do not refresh timeout when resetting element"),
+# the respective parts of the test have therefore been commented out.
+
 set -e
 
 trap '[[ $? -eq 0 ]] || echo FAIL' EXIT
@@ -44,10 +48,11 @@ elem='element t s { 1.0.0.1 . udp . 53 }'
 	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
 echo OK
 
-echo -n "counters and expiry are reset: "
+#echo -n "counters and expiry are reset: "
+echo -n "counters are reset: "
 NEW=$($NFT "get $elem")
 grep -q 'counter packets 0 bytes 0' <<< "$NEW"
-[[ $(expires_minutes <<< "$NEW") -gt 20 ]]
+#[[ $(expires_minutes <<< "$NEW") -gt 20 ]]
 echo OK
 
 echo -n "get map elem matches reset map elem: "
@@ -80,11 +85,11 @@ OUT=$($NFT reset map t m)
 $DIFF -u <(echo "$EXP") <(echo "$OUT")
 echo OK
 
-echo -n "reset command respects per-element timeout: "
-VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_minutes)
-[[ $VAL -lt 15 ]]	# custom timeout applies
-[[ $VAL -gt 10 ]]	# expires was reset
-echo OK
+#echo -n "reset command respects per-element timeout: "
+#VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_minutes)
+#[[ $VAL -lt 15 ]]	# custom timeout applies
+#[[ $VAL -gt 10 ]]	# expires was reset
+#echo OK
 
 echo -n "remaining elements are reset: "
 OUT=$($NFT list ruleset)
-- 
2.41.0

