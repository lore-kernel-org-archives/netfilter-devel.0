Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28004C61DB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjKVKcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjKVKcb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:32:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FA23D8
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:32:27 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/8] tests: shell: skip nat inet if kernel does not support it
Date:   Wed, 22 Nov 2023 11:32:18 +0100
Message-Id: <20231122103221.90160-5-pablo@netfilter.org>
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
 tests/shell/features/inet_nat.nft           | 7 +++++++
 tests/shell/testcases/maps/0010concat_map_0 | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/features/inet_nat.nft

diff --git a/tests/shell/features/inet_nat.nft b/tests/shell/features/inet_nat.nft
new file mode 100644
index 000000000000..189ea1d0e280
--- /dev/null
+++ b/tests/shell/features/inet_nat.nft
@@ -0,0 +1,7 @@
+# v5.2-rc1~133^2~174^2~15
+# d164385ec572 ("netfilter: nat: add inet family nat support")
+table inet x {
+        chain y {
+                type nat hook prerouting priority dstnat;
+	}
+}
diff --git a/tests/shell/testcases/maps/0010concat_map_0 b/tests/shell/testcases/maps/0010concat_map_0
index 4848d97212fd..859bbfcf69e4 100755
--- a/tests/shell/testcases/maps/0010concat_map_0
+++ b/tests/shell/testcases/maps/0010concat_map_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_nat)
+
 set -e
 
 EXPECTED="table inet x {
-- 
2.30.2

