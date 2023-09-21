Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0768EE7109A
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 17:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjIURIj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjIURI0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 13:08:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A355F59FF
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:05:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qjFMp-0004Lf-LR; Thu, 21 Sep 2023 10:48:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] tests: shell: skip adding catchall elements if unuspported
Date:   Thu, 21 Sep 2023 10:48:44 +0200
Message-ID: <20230921084849.634-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921084849.634-1-fw@strlen.de>
References: <20230921084849.634-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test fails on kernels without catchall support, so elide this
small part.

No need to skip the test in this case, the dump file validates that
the added elements are no longer there after the timeout.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/maps/vmap_timeout | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index 43d031979cb3..0cd965f76d0e 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -42,8 +42,12 @@ for i in $(seq 1 100) ; do
 	$NFT add element inet filter portaddrmap "$batched_addr"
 done
 
-$NFT add element inet filter portaddrmap { "* timeout 2s : drop" }
-$NFT add element inet filter portmap { "* timeout 3s : drop" }
+if [ "$NFT_TEST_HAVE_catchall_element" = n ] ; then
+	echo "Partial test due to NFT_TEST_HAVE_catchall_element=n."
+else
+	$NFT add element inet filter portaddrmap { "* timeout 2s : drop" }
+	$NFT add element inet filter portmap { "* timeout 3s : drop" }
+fi
 
 # wait for elements to time out
 sleep 5
-- 
2.41.0

