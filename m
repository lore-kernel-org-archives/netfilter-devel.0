Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDC0E728CF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 18:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjI2SFG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjI2SEz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 14:04:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AE830DF
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2XTl3xGbDOwxza2yFvr8kfWCKdhqbxvcV/iBIU/tPrY=; b=Xy0sbvfp1bSzTYMvurr41Jd5NP
        4q2ZDXuzyMBX7WeUhnfzqLD/1ccZOQYLScGZfcX+nr7kmbc+/++dgznm2sOgSZZ8SMevSGSOIzU9o
        g4E01cPoOmlWGdPf8RfX7/DJgU24TmBnK+tNBk8ue/0KleqHxU0nKbgprrr/DXcMNLJmAYf71v2I6
        CbKLlc8XisgOhycv3IJQCrwvyE73mJHGxkkbLEnylXoSdDWP0t6OyxdbiEfyY1+1dhUHP6UpKwYKx
        oNsbC3Fk6/jX6UOFVqLPRnwieL3iuHuFLL3N2f+JhYvYdeUsenTHC12r7wMydM48ZPnEPX0v6jQKs
        Bn9Nr4ng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qmHq8-0004Mj-HM; Fri, 29 Sep 2023 20:03:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: sets/reset_command_0: Fix drop_seconds()
Date:   Fri, 29 Sep 2023 20:03:44 +0200
Message-ID: <20230929180345.19037-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function print_times() skips any time elements which are zero, so
output may lack the ms part. Adjust the sed call dropping anything but
the minutes value to not fail in that case.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 255ec36a11525 ("tests: shell: Stabilize sets/reset_command_0 test")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/reset_command_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index 5e769fe66d684..e663dac831f8c 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -32,7 +32,7 @@ $NFT -f - <<< "$RULESET"
 echo OK
 
 drop_seconds() {
-	sed 's/m[0-9]*s[0-9]*ms/m/g'
+	sed 's/[0-9]\+m\?s//g'
 }
 expires_minutes() {
 	sed -n 's/.*expires \([0-9]*\)m.*/\1/p'
-- 
2.41.0

