Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5152FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB2960F70
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhKBUKh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhKBUKh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:10:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7927C061714
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2021 13:08:01 -0700 (PDT)
Received: from localhost ([::1]:49166 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mi04b-0001O6-1K; Tue, 02 Nov 2021 21:07:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: [nft PATCH] tests: shell: Fix bogus testsuite failure with 250Hz
Date:   Tue,  2 Nov 2021 21:07:53 +0100
Message-Id: <20211102200753.25311-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous fix for HZ=100 was not sufficient, a kernel with HZ=250 rounds
the 10ms to 8ms it seems. Do as Lukas suggests and accept the occasional
input/output asymmetry instead of continuing the hide'n'seek game.

Fixes: c9c5b5f621c37 ("tests: shell: Fix bogus testsuite failure with 100Hz")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0031set_timeout_size_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/0031set_timeout_size_0 b/tests/shell/testcases/sets/0031set_timeout_size_0
index 796640d64670a..9a4a27f6c4512 100755
--- a/tests/shell/testcases/sets/0031set_timeout_size_0
+++ b/tests/shell/testcases/sets/0031set_timeout_size_0
@@ -8,5 +8,5 @@ add rule x test set update ip daddr timeout 100ms @y"
 
 set -e
 $NFT -f - <<< "$RULESET"
-$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s10ms }'
+$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s\(10\|8\)ms }'
 $NFT list chain x test | grep -q 'update @y { ip daddr timeout 100ms }'
-- 
2.33.0

