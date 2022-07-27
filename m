Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220DBC04A68
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jul 2022 11:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiG0LUf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 07:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiG0LUe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 07:20:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9772CDEB
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2022 04:20:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGf5b-0003cH-At; Wed, 27 Jul 2022 13:20:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/7] tests: add a test case for ether and vlan listing
Date:   Wed, 27 Jul 2022 13:20:01 +0200
Message-Id: <20220727112003.26022-6-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220727112003.26022-1-fw@strlen.de>
References: <20220727112003.26022-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

before this patch series, test fails dump validation:
-               update @macset { ether saddr . vlan id timeout 5s } counter packets 0 bytes 0
-               ether saddr . vlan id @macset
+               update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s } counter packets 0 bytes 0
+               @ll,48,48 . @ll,112,16 & 0xfff @macset

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/sets/0070stacked_l2_headers  |  6 ++++++
 .../sets/dumps/0070stacked_l2_headers.nft          | 14 ++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0070stacked_l2_headers
 create mode 100644 tests/shell/testcases/sets/dumps/0070stacked_l2_headers.nft

diff --git a/tests/shell/testcases/sets/0070stacked_l2_headers b/tests/shell/testcases/sets/0070stacked_l2_headers
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/sets/0070stacked_l2_headers
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/sets/dumps/0070stacked_l2_headers.nft b/tests/shell/testcases/sets/dumps/0070stacked_l2_headers.nft
new file mode 100644
index 000000000000..ef254b96879e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0070stacked_l2_headers.nft
@@ -0,0 +1,14 @@
+table netdev nt {
+	set macset {
+		typeof ether saddr . vlan id
+		size 1024
+		flags dynamic,timeout
+	}
+
+	chain nc {
+		update @macset { ether saddr . vlan id timeout 5s } counter packets 0 bytes 0
+		ether saddr . vlan id @macset
+		vlan pcp 1
+		ether saddr 0a:0b:0c:0d:0e:0f vlan id 42
+	}
+}
-- 
2.35.1

