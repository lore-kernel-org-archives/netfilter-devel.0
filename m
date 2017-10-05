From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: files: Remove old tests for chain rename.
Date: Thu,  5 Oct 2017 13:36:47 +0530
Message-ID: <20171005080647.15713-2-rvarsha016@gmail.com>
References: <20171005080647.15713-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35971 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdJEIHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2017 04:07:48 -0400
Received: by mail-pg0-f65.google.com with SMTP id i195so6807646pgd.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Oct 2017 01:07:48 -0700 (PDT)
In-Reply-To: <20171005080647.15713-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These tests are not required as new test cases are added in tests/shell
file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/chain-rename.1 | 7 -------
 tests/files/chain-rename.2 | 4 ----
 tests/files/chain-rename.3 | 5 -----
 3 files changed, 16 deletions(-)
 delete mode 100644 tests/files/chain-rename.1
 delete mode 100644 tests/files/chain-rename.2
 delete mode 100644 tests/files/chain-rename.3

diff --git a/tests/files/chain-rename.1 b/tests/files/chain-rename.1
deleted file mode 100644
index 870416c..0000000
--- a/tests/files/chain-rename.1
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# Create table and empty chains for rename test
-add table filter
-
-add chain filter chain1
-add chain filter chain2
diff --git a/tests/files/chain-rename.2 b/tests/files/chain-rename.2
deleted file mode 100644
index 1250dab..0000000
--- a/tests/files/chain-rename.2
+++ /dev/null
@@ -1,4 +0,0 @@
-#! nft -f
-
-# must fail: already exists
-rename chain filter chain1 chain2
diff --git a/tests/files/chain-rename.3 b/tests/files/chain-rename.3
deleted file mode 100644
index 796c1a1..0000000
--- a/tests/files/chain-rename.3
+++ /dev/null
@@ -1,5 +0,0 @@
-#! nft -f
-
-# must succeed
-rename chain filter chain1 chain3
-delete chain filter chain3
-- 
2.13.6

