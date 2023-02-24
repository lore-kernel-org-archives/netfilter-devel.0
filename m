Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEC4C64ED8
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 10:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBXKsB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 05:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBXKr7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 05:47:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AAD27AAB
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 02:47:57 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 1/2,v2] tests: shell: cover rule insertion by index
Date:   Fri, 24 Feb 2023 11:47:51 +0100
Message-Id: <20230224104752.144447-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Original patch including this feature did not include a test, add it.

Fixes: 816d8c7659c1 ("Support 'add/insert rule index <IDX>'")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 tests/shell/testcases/cache/0011_index_0           | 12 ++++++++++++
 tests/shell/testcases/cache/dumps/0011_index_0.nft |  8 ++++++++
 2 files changed, 20 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0011_index_0
 create mode 100644 tests/shell/testcases/cache/dumps/0011_index_0.nft

diff --git a/tests/shell/testcases/cache/0011_index_0 b/tests/shell/testcases/cache/0011_index_0
new file mode 100755
index 000000000000..c9eb86830c8d
--- /dev/null
+++ b/tests/shell/testcases/cache/0011_index_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+set -e
+
+RULESET="flush ruleset
+add table inet t
+add chain inet t c { type filter hook input priority 0 ; }
+add rule inet t c tcp dport 1234 accept
+add rule inet t c accept
+insert rule inet t c index 1 udp dport 4321 accept"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/cache/dumps/0011_index_0.nft b/tests/shell/testcases/cache/dumps/0011_index_0.nft
new file mode 100644
index 000000000000..7e855eb1cfb9
--- /dev/null
+++ b/tests/shell/testcases/cache/dumps/0011_index_0.nft
@@ -0,0 +1,8 @@
+table inet t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		tcp dport 1234 accept
+		udp dport 4321 accept
+		accept
+	}
+}
-- 
2.30.2

