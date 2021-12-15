Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C72DC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 11:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhLOLA4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 06:00:56 -0500
Received: from mail.netfilter.org ([217.70.188.207]:54786 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhLOLA4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 06:00:56 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 83584625D0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 11:58:26 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] tests: shell: implicit chains simple coverage
Date:   Wed, 15 Dec 2021 12:00:30 +0100
Message-Id: <20211215110031.84328-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Already fixed by 17297d1acbbf ("cache: Filter chain list on kernel side").

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1577
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/cache/0010_implicit_chain_0          | 5 +++++
 .../shell/testcases/cache/dumps/0010_implicit_chain_0.nft  | 7 +++++++
 2 files changed, 12 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0010_implicit_chain_0
 create mode 100644 tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft

diff --git a/tests/shell/testcases/cache/0010_implicit_chain_0 b/tests/shell/testcases/cache/0010_implicit_chain_0
new file mode 100755
index 000000000000..43bdb6477542
--- /dev/null
+++ b/tests/shell/testcases/cache/0010_implicit_chain_0
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+set -e
+
+$NFT 'table ip f { chain c { jump { accept; }; }; }'
diff --git a/tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft b/tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft
new file mode 100644
index 000000000000..aba92c0e5065
--- /dev/null
+++ b/tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft
@@ -0,0 +1,7 @@
+table ip f {
+	chain c {
+		jump {
+			accept
+		}
+	}
+}
-- 
2.30.2

