From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 4/9] tests: files: Remove tests for set.
Date: Wed, 11 Oct 2017 10:17:51 +0530
Message-ID: <7f1fc657c298db7c56ade6aa7897f51d0385256f.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35313 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdJKEsK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:48:10 -0400
Received: by mail-pg0-f67.google.com with SMTP id l24so881528pgu.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:48:10 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test case for set. As new test case is added to
tests/shell file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/set | 14 --------------
 1 file changed, 14 deletions(-)
 delete mode 100644 tests/files/set

diff --git a/tests/files/set b/tests/files/set
deleted file mode 100644
index 3c040b0..0000000
--- a/tests/files/set
+++ /dev/null
@@ -1,14 +0,0 @@
-#! nft -f
-
-add table filter
-add chain filter output { type filter hook output priority 0 ; }
-
-# set: IP addresses
-add rule filter output ip daddr { \
-	192.168.0.1, \
-	192.168.0.2, \
-	192.168.0.3, \
-}
-
-# set: tcp ports
-add rule filter output tcp dport { 22, 23 } counter
-- 
2.13.6

