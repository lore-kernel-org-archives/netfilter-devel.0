From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 9/9] tests: files: Remove tests for verdict maps.
Date: Wed, 11 Oct 2017 10:31:49 +0530
Message-ID: <f412bf2bc5b2a126b32aaa578d4ce9be09cf9990.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37654 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756888AbdJKFCH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 01:02:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id z80so1214565pff.4
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 22:02:07 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove test cases for verdict maps. As they are already there in
tests/shell file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/verdict-maps | 20 --------------------
 1 file changed, 20 deletions(-)
 delete mode 100644 tests/files/verdict-maps

diff --git a/tests/files/verdict-maps b/tests/files/verdict-maps
deleted file mode 100644
index c1630ce..0000000
--- a/tests/files/verdict-maps
+++ /dev/null
@@ -1,20 +0,0 @@
-#! nft -f
-#
-
-add table ip filter
-add chain ip filter input { type filter hook input priority 0; }
-
-add chain ip filter chain1
-add filter chain1 counter
-
-add chain ip filter chain2
-add filter chain2 counter
-
-add chain ip filter chain3
-add filter chain3 counter
-
-add filter input ip saddr vmap { \
-	10.0.0.0/24 : jump chain1, \
-	10.0.0.0/8  : jump chain2, \
-	8.8.8.8 : jump chain3 \
-}
-- 
2.13.6

