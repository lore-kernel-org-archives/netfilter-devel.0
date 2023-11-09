Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D97EC05027
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbjKIQXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343567AbjKIQXO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B1A235A9
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:12 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 06/12] tests: shell: skip comment tests if kernel lacks support
Date:   Thu,  9 Nov 2023 17:22:58 +0100
Message-Id: <20231109162304.119506-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests that require comment support

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/comment.sh                    | 11 +++++++++++
 tests/shell/testcases/json/0006obj_comment_0       |  1 +
 tests/shell/testcases/optionals/comments_chain_0   |  2 ++
 tests/shell/testcases/optionals/comments_objects_0 |  2 ++
 tests/shell/testcases/optionals/comments_table_0   |  2 ++
 tests/shell/testcases/sets/0020comments_0          |  2 ++
 6 files changed, 20 insertions(+)
 create mode 100755 tests/shell/features/comment.sh

diff --git a/tests/shell/features/comment.sh b/tests/shell/features/comment.sh
new file mode 100755
index 000000000000..516cf5e183ad
--- /dev/null
+++ b/tests/shell/features/comment.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+EXPECTED="table ip x {
+	chain y {
+		comment \"test\"
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+$DIFF -u <($NFT list ruleset) - <<<"$EXPECTED"
diff --git a/tests/shell/testcases/json/0006obj_comment_0 b/tests/shell/testcases/json/0006obj_comment_0
index 4c2a0e8c0880..7ce859d2529f 100755
--- a/tests/shell/testcases/json/0006obj_comment_0
+++ b/tests/shell/testcases/json/0006obj_comment_0
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_comment)
 
 set -e
 
diff --git a/tests/shell/testcases/optionals/comments_chain_0 b/tests/shell/testcases/optionals/comments_chain_0
index fba961c76841..1a84cfa67a2a 100755
--- a/tests/shell/testcases/optionals/comments_chain_0
+++ b/tests/shell/testcases/optionals/comments_chain_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_comment)
+
 EXPECTED='table ip test_table {
 	chain test_chain {
 		comment "test"
diff --git a/tests/shell/testcases/optionals/comments_objects_0 b/tests/shell/testcases/optionals/comments_objects_0
index 301f5518fb80..28041ebd2a43 100755
--- a/tests/shell/testcases/optionals/comments_objects_0
+++ b/tests/shell/testcases/optionals/comments_objects_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_comment)
+
 set -e
 
 COMMENT128="12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678"
diff --git a/tests/shell/testcases/optionals/comments_table_0 b/tests/shell/testcases/optionals/comments_table_0
index a0dfd7494661..56bb206bddcf 100755
--- a/tests/shell/testcases/optionals/comments_table_0
+++ b/tests/shell/testcases/optionals/comments_table_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_comment)
+
 # comments are shown
 
 $NFT add table test { comment \"test_comment\"\; }
diff --git a/tests/shell/testcases/sets/0020comments_0 b/tests/shell/testcases/sets/0020comments_0
index 44d451a8ad3a..1df38326ab57 100755
--- a/tests/shell/testcases/sets/0020comments_0
+++ b/tests/shell/testcases/sets/0020comments_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_comment)
+
 # Test that comments are added to set elements in standard sets.
 # Explicitly test bitmap backend set implementation.
 
-- 
2.30.2

