Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C674FC54E76
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 12:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjKTM4O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Nov 2023 07:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjKTM4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2023 07:56:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A07410C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 04:56:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r53ou-0005sL-RG; Mon, 20 Nov 2023 13:56:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: skip maps delete test if dynset lacks delete op
Date:   Mon, 20 Nov 2023 13:56:01 +0100
Message-ID: <20231120125604.19504-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/dynset_op_delete.nft         | 12 ++++++++++++
 tests/shell/testcases/maps/typeof_maps_add_delete |  2 ++
 2 files changed, 14 insertions(+)
 create mode 100644 tests/shell/features/dynset_op_delete.nft

diff --git a/tests/shell/features/dynset_op_delete.nft b/tests/shell/features/dynset_op_delete.nft
new file mode 100644
index 000000000000..125b4526bbc3
--- /dev/null
+++ b/tests/shell/features/dynset_op_delete.nft
@@ -0,0 +1,12 @@
+# d0a8d877da97 ("netfilter: nft_dynset: support for element deletion")
+# v5.4-rc1~131^2~59^2~4
+table ip x {
+	set s {
+		flags dynamic;
+		type inet_service;
+	}
+
+	chain y {
+		delete @s { tcp dport }
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_add_delete b/tests/shell/testcases/maps/typeof_maps_add_delete
index 5e2f8ecc473f..d2ac9f1ce8c9 100755
--- a/tests/shell/testcases/maps/typeof_maps_add_delete
+++ b/tests/shell/testcases/maps/typeof_maps_add_delete
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_dynset_op_delete)
+
 CONDMATCH="ip saddr @dynmark"
 NCONDMATCH="ip saddr != @dynmark"
 
-- 
2.41.0

