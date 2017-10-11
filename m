From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 1/9] tests: files: Remove jump chain tests.
Date: Wed, 11 Oct 2017 10:07:47 +0530
Message-ID: <85195a19a17e1148e076670ce3f355d6436401df.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36839 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdJKEiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:38:16 -0400
Received: by mail-pf0-f194.google.com with SMTP id z11so1138166pfk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:38:15 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tests for loop-detect 1, 2 and 3 are already there in tests/shell file.
New test for loop-detect.4 has been added to tests/shell file. So, remove
them.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/loop-detect.1 | 8 --------
 tests/files/loop-detect.2 | 7 -------
 tests/files/loop-detect.3 | 7 -------
 tests/files/loop-detect.4 | 7 -------
 4 files changed, 29 deletions(-)
 delete mode 100644 tests/files/loop-detect.1
 delete mode 100644 tests/files/loop-detect.2
 delete mode 100644 tests/files/loop-detect.3
 delete mode 100644 tests/files/loop-detect.4

diff --git a/tests/files/loop-detect.1 b/tests/files/loop-detect.1
deleted file mode 100644
index e55864c..0000000
--- a/tests/files/loop-detect.1
+++ /dev/null
@@ -1,8 +0,0 @@
-#! nft -f
-
-# Create table and empty chains for loop detection tests
-add table filter
-
-add chain filter chain1
-add chain filter chain2
-add chain filter chain3
diff --git a/tests/files/loop-detect.2 b/tests/files/loop-detect.2
deleted file mode 100644
index 88a95e0..0000000
--- a/tests/files/loop-detect.2
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# Circular regular jumps: chain1 -> chain2 -> chain3 -> chain1
-flush table filter
-add filter chain1 jump chain2
-add filter chain2 jump chain3
-add filter chain3 jump chain1
diff --git a/tests/files/loop-detect.3 b/tests/files/loop-detect.3
deleted file mode 100644
index 80f7fc5..0000000
--- a/tests/files/loop-detect.3
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# Circular jump when creating an anonymous verdict map: chain1 -> chain2 -> chain3 -> chain1
-flush table filter
-add filter chain1 jump chain2
-add filter chain2 jump chain3
-add filter chain3 ip daddr vmap { 10.0.0.1 : continue, 192.168.0.1 : jump chain1 }
diff --git a/tests/files/loop-detect.4 b/tests/files/loop-detect.4
deleted file mode 100644
index acd9a34..0000000
--- a/tests/files/loop-detect.4
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# Circular jump with an intermediate anonymous verdict map: chain1 -> chain2 -> chain3 -> chain1
-flush table filter
-add filter chain1 jump chain2
-add filter chain2 ip daddr vmap { 10.0.0.1 : continue, 192.168.0.1 : jump chain3 }
-add filter chain3 jump chain1
-- 
2.13.6

