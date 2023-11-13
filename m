Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52C4C04E83
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjKMNjO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjKMNjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FB3A1A2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:07 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 04/11] tests: shell: skip NAT netmap tests if kernel lacks support
Date:   Mon, 13 Nov 2023 14:38:51 +0100
Message-Id: <20231113133858.121324-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests that require NAT netmap support

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use git describe --contains, requested by Florian.

 tests/shell/features/netmap.nft         | 8 ++++++++
 tests/shell/testcases/sets/0046netmap_0 | 2 ++
 2 files changed, 10 insertions(+)
 create mode 100644 tests/shell/features/netmap.nft

diff --git a/tests/shell/features/netmap.nft b/tests/shell/features/netmap.nft
new file mode 100644
index 000000000000..2580a8dcf534
--- /dev/null
+++ b/tests/shell/features/netmap.nft
@@ -0,0 +1,8 @@
+# 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
+# v5.8-rc1~165^2~393^2
+table ip x {
+        chain y {
+              type nat hook postrouting priority srcnat; policy accept;
+              snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
+        }
+}
diff --git a/tests/shell/testcases/sets/0046netmap_0 b/tests/shell/testcases/sets/0046netmap_0
index 60bda4017c59..7533623e7f7b 100755
--- a/tests/shell/testcases/sets/0046netmap_0
+++ b/tests/shell/testcases/sets/0046netmap_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netmap)
+
 EXPECTED="table ip x {
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
-- 
2.30.2

