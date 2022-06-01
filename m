Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451D8C43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 16:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355117AbiFAQS6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 12:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240224AbiFAQS5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 12:18:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF8D159081
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 09:18:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: sets_with_ifnames release netns on exit
Date:   Wed,  1 Jun 2022 18:18:48 +0200
Message-Id: <20220601161848.102116-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing ip netns del call from cleanup()

Fixes: d6fdb0d8d482 ("sets_with_ifnames: add test case for concatenated range")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/sets_with_ifnames | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
index f4ef4db59f51..9531c8566631 100755
--- a/tests/shell/testcases/sets/sets_with_ifnames
+++ b/tests/shell/testcases/sets/sets_with_ifnames
@@ -13,6 +13,7 @@ ns2="nft2ifname-$rnd"
 cleanup()
 {
 	ip netns del "$ns1"
+	ip netns del "$ns2"
 }
 
 trap cleanup EXIT
-- 
2.30.2

