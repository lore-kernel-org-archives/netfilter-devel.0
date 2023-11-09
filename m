Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8269AC41535
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbjKIQXO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjKIQXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F01B5327D
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:10 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 03/12] tests: shell: skip prerouting reject tests if kernel lacks support
Date:   Thu,  9 Nov 2023 17:22:55 +0100
Message-Id: <20231109162304.119506-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests that require reject at prerouting hook.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/prerouting_reject.nft  | 8 ++++++++
 tests/shell/testcases/optimizations/ruleset | 2 ++
 2 files changed, 10 insertions(+)
 create mode 100644 tests/shell/features/prerouting_reject.nft

diff --git a/tests/shell/features/prerouting_reject.nft b/tests/shell/features/prerouting_reject.nft
new file mode 100644
index 000000000000..26098bb54534
--- /dev/null
+++ b/tests/shell/features/prerouting_reject.nft
@@ -0,0 +1,8 @@
+# f53b9b0bdc59 netfilter: introduce support for reject at prerouting stage
+# v5.13-rc1~94^2~10^2~2
+table inet t {
+	chain nat_filter {
+		type filter hook prerouting priority 0; policy accept;
+		reject with icmpx type host-unreachable
+	}
+}
diff --git a/tests/shell/testcases/optimizations/ruleset b/tests/shell/testcases/optimizations/ruleset
index ef2652dbeae8..2b2d80ffc009 100755
--- a/tests/shell/testcases/optimizations/ruleset
+++ b/tests/shell/testcases/optimizations/ruleset
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_prerouting_reject)
+
 RULESET="table inet uni {
 	chain gtfo {
 		reject with icmpx type host-unreachable
-- 
2.30.2

