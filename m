Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9BCC54E76
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 13:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjKTNHW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Nov 2023 08:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjKTNHV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2023 08:07:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD196FF
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 05:07:17 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: adjust add-after-delete flowtable for older kernels
Date:   Mon, 20 Nov 2023 14:07:12 +0100
Message-Id: <20231120130712.114129-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove counter from flowtable, older kernels (<=5.4) do not support this
in testcases/flowtable/0013addafterdelete_0 so this bug is still
covered.

Skip testcases/flowtable/0014addafterdelete_0 if flowtable counter
support is not available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/flowtable/0013addafterdelete_0           | 2 --
 tests/shell/testcases/flowtable/0014addafterdelete_0           | 2 ++
 tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/shell/testcases/flowtable/0013addafterdelete_0 b/tests/shell/testcases/flowtable/0013addafterdelete_0
index b23ab9782909..56c9834f526f 100755
--- a/tests/shell/testcases/flowtable/0013addafterdelete_0
+++ b/tests/shell/testcases/flowtable/0013addafterdelete_0
@@ -7,7 +7,6 @@ RULESET='table inet filter {
     flowtable f {
 	hook ingress priority filter - 1
 	devices = { lo }
-	counter
     }
 }'
 
@@ -20,7 +19,6 @@ table inet filter {
     flowtable f {
 	hook ingress priority filter - 1
 	devices = { lo }
-	counter
     }
 }'
 
diff --git a/tests/shell/testcases/flowtable/0014addafterdelete_0 b/tests/shell/testcases/flowtable/0014addafterdelete_0
index 6a24c4b9a140..1ac651044d48 100755
--- a/tests/shell/testcases/flowtable/0014addafterdelete_0
+++ b/tests/shell/testcases/flowtable/0014addafterdelete_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_flowtable_counter)
+
 set -e
 
 RULESET='table inet filter {
diff --git a/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft b/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
index 83fdd5d01d3a..67db7d029392 100644
--- a/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
@@ -2,6 +2,5 @@ table inet filter {
 	flowtable f {
 		hook ingress priority filter - 1
 		devices = { lo }
-		counter
 	}
 }
-- 
2.30.2

