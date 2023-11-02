Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D2CC4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 17:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbjKBR6P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbjKBR6L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 13:58:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE72198
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=77YqVCa18KejuMF+BRFmM36jNRKWNw8q3ifS5QmlMZ8=; b=QvKIuUKEtyVTPWFrYyLNQ9DzGY
        jlyNpQUGNv1QNHkhzi2lo9xSZmjqPDyHElXuHNINDcb1oSCOWpW7LQlUjH6dwwIlu+5FNqX3Wgb2h
        KRcAVdlG1HlW49VEP7seGLK3dVTm3Pq86oNS9khMLP5cLFxtSz4PuXKW/+u64P/KiV1LJ9LJ/JpIu
        KHtFmJteRnoQdwgnvpBAXzqQE6IwM/PqXbfLggKhKyXNP7/BcG6P00Y+3f8xsDmpbWJtT+ZRNx331
        K/5hood3hSLdQwiYenWklJe8CU4xo2C2BazfBp2BSCfiTNzJxcozYsk3I2qbf3H2SdWDSIpZIVSdz
        YYNYBQ4w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qybx8-0008CS-3y; Thu, 02 Nov 2023 18:57:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v2] tests: shell: Fix sets/reset_command_0 for current kernels
Date:   Thu,  2 Nov 2023 18:57:54 +0100
Message-ID: <20231102175754.15020-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since kernel commit 4c90bba60c26 ("netfilter: nf_tables: do not refresh
timeout when resetting element"), element reset won't touch expiry
anymore. Invert the one check to make sure it remains unaltered, drop
the other testing behaviour for per-element timeouts.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Assume behaviour is permanent, explicitly test for it
- Move comment content into commit message
---
 tests/shell/testcases/sets/reset_command_0 | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index e663dac831f8c..d38ddb3ffeebb 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -44,10 +44,10 @@ elem='element t s { 1.0.0.1 . udp . 53 }'
 	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
 echo OK
 
-echo -n "counters and expiry are reset: "
+echo -n "counters are reset, expiry left alone: "
 NEW=$($NFT "get $elem")
 grep -q 'counter packets 0 bytes 0' <<< "$NEW"
-[[ $(expires_minutes <<< "$NEW") -gt 20 ]]
+[[ $(expires_minutes <<< "$NEW") -lt 20 ]]
 echo OK
 
 echo -n "get map elem matches reset map elem: "
@@ -80,12 +80,6 @@ OUT=$($NFT reset map t m)
 $DIFF -u <(echo "$EXP") <(echo "$OUT")
 echo OK
 
-echo -n "reset command respects per-element timeout: "
-VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_minutes)
-[[ $VAL -lt 15 ]]	# custom timeout applies
-[[ $VAL -gt 10 ]]	# expires was reset
-echo OK
-
 echo -n "remaining elements are reset: "
 OUT=$($NFT list ruleset)
 grep -q '2.0.0.2 . tcp . 22 counter packets 0 bytes 0' <<< "$OUT"
-- 
2.41.0

