Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B24EC61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjKVKcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjKVKca (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:32:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3ACAFC1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:32:27 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/8] tests: shell: skip synproxy test if kernel does not support it
Date:   Wed, 22 Nov 2023 11:32:17 +0100
Message-Id: <20231122103221.90160-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231122103221.90160-1-pablo@netfilter.org>
References: <20231122103221.90160-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/synproxy.nft         | 9 +++++++++
 tests/shell/testcases/sets/0024synproxy_0 | 2 ++
 2 files changed, 11 insertions(+)
 create mode 100644 tests/shell/features/synproxy.nft

diff --git a/tests/shell/features/synproxy.nft b/tests/shell/features/synproxy.nft
new file mode 100644
index 000000000000..bea4f9205b3d
--- /dev/null
+++ b/tests/shell/features/synproxy.nft
@@ -0,0 +1,9 @@
+# v5.3-rc1~140^2~44^2~10
+# ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
+table inet x {
+       synproxy https-synproxy {
+               mss 1460
+               wscale 7
+               timestamp sack-perm
+       }
+}
diff --git a/tests/shell/testcases/sets/0024synproxy_0 b/tests/shell/testcases/sets/0024synproxy_0
index ccaed0325d44..0c7da5729b0d 100755
--- a/tests/shell/testcases/sets/0024synproxy_0
+++ b/tests/shell/testcases/sets/0024synproxy_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_synproxy)
+
 # * creating valid named objects
 # * referencing them from a valid rule
 
-- 
2.30.2

