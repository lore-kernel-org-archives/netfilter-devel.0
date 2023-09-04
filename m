Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B40C83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 09:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352612AbjIDJH0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352631AbjIDJHZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 05:07:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC181B8
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:07:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qd5YA-0000Fb-FM; Mon, 04 Sep 2023 11:07:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/5] tests: shell skip inner matching tests if unsupported
Date:   Mon,  4 Sep 2023 11:06:34 +0200
Message-ID: <20230904090640.3015-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904090640.3015-1-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/inner_matching.nft | 7 +++++++
 tests/shell/testcases/sets/inner_0      | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/features/inner_matching.nft

diff --git a/tests/shell/features/inner_matching.nft b/tests/shell/features/inner_matching.nft
new file mode 100644
index 000000000000..6c86fd3558ac
--- /dev/null
+++ b/tests/shell/features/inner_matching.nft
@@ -0,0 +1,7 @@
+# 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
+# v6.2-rc1~99^2~350^2~4
+table ip t {
+        chain c {
+                udp dport 4789 vxlan ip saddr 1.2.3.4
+        }
+}
diff --git a/tests/shell/testcases/sets/inner_0 b/tests/shell/testcases/sets/inner_0
index 0eb172a8cf06..ceb35115cc7d 100755
--- a/tests/shell/testcases/sets/inner_0
+++ b/tests/shell/testcases/sets/inner_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+[ $NFT_HAVE_inner_matching -eq 0 ] && exit 123
+
 set -e
 
 RULESET="table netdev x {
-- 
2.41.0

