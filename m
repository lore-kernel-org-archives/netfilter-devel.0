Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D321C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 20:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40D864F41
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 20:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhCQUg7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhCQUgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 16:36:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49AFEC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 13:36:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0B8EA6352C
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 21:36:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: flowtable add after delete in batch
Date:   Wed, 17 Mar 2021 21:36:36 +0100
Message-Id: <20210317203636.14869-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for bogus EEXIST and EBUSY errors.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/flowtable/0013addafterdelete_0  | 27 ++++++++++++++
 .../testcases/flowtable/0014addafterdelete_0  | 36 +++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100755 tests/shell/testcases/flowtable/0013addafterdelete_0
 create mode 100755 tests/shell/testcases/flowtable/0014addafterdelete_0

diff --git a/tests/shell/testcases/flowtable/0013addafterdelete_0 b/tests/shell/testcases/flowtable/0013addafterdelete_0
new file mode 100755
index 000000000000..b23ab9782909
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0013addafterdelete_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+set -e
+
+RULESET='table inet filter {
+
+    flowtable f {
+	hook ingress priority filter - 1
+	devices = { lo }
+	counter
+    }
+}'
+
+$NFT -f - <<< "$RULESET"
+
+RULESET='delete flowtable inet filter f
+
+table inet filter {
+
+    flowtable f {
+	hook ingress priority filter - 1
+	devices = { lo }
+	counter
+    }
+}'
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/flowtable/0014addafterdelete_0 b/tests/shell/testcases/flowtable/0014addafterdelete_0
new file mode 100755
index 000000000000..6a24c4b9a140
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0014addafterdelete_0
@@ -0,0 +1,36 @@
+#!/bin/bash
+
+set -e
+
+RULESET='table inet filter {
+
+    flowtable f {
+        hook ingress priority filter - 1
+        devices = { lo }
+    }
+
+    chain y {
+        type filter hook forward priority 0;
+        flow add @f counter
+    }
+}'
+
+$NFT -f - <<< "$RULESET"
+
+RULESET='delete rule inet filter y handle 3
+delete flowtable inet filter f
+
+table inet filter {
+    flowtable f {
+        hook ingress priority filter - 1
+        devices = { lo }
+        counter
+    }
+
+    chain y {
+        type filter hook forward priority 0;
+        flow add @f counter
+    }
+}'
+
+$NFT -f - <<< "$RULESET"
-- 
2.20.1

