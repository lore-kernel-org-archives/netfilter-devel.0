From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 6/9] tests: files: Remove test cases for variable definition.
Date: Wed, 11 Oct 2017 10:23:53 +0530
Message-ID: <ffd4d5178cf344bbdcf08f2db31cde308143a31b.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35470 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbdJKEyO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:54:14 -0400
Received: by mail-pf0-f193.google.com with SMTP id i23so1204748pfi.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:54:14 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New test cases for variable definition are added in tests/shell file.
So, remove these test cases.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/symbolic-define.1 | 7 -------
 tests/files/symbolic-define.2 | 7 -------
 tests/files/symbolic-define.3 | 6 ------
 3 files changed, 20 deletions(-)
 delete mode 100644 tests/files/symbolic-define.1
 delete mode 100644 tests/files/symbolic-define.2
 delete mode 100644 tests/files/symbolic-define.3

diff --git a/tests/files/symbolic-define.1 b/tests/files/symbolic-define.1
deleted file mode 100644
index 712ef71..0000000
--- a/tests/files/symbolic-define.1
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# error: variable use before definition
-define var2 = $var1
-define var1 = eth0
-
-filter input iif $var2
diff --git a/tests/files/symbolic-define.2 b/tests/files/symbolic-define.2
deleted file mode 100644
index cd3c23c..0000000
--- a/tests/files/symbolic-define.2
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-# error: redefinition of an existing variable
-define var1 = eth0
-define var1 = eth0
-
-filter input iif $var1
diff --git a/tests/files/symbolic-define.3 b/tests/files/symbolic-define.3
deleted file mode 100644
index ba224df..0000000
--- a/tests/files/symbolic-define.3
+++ /dev/null
@@ -1,6 +0,0 @@
-#! nft -f
-
-# error: recursive definition of a variable
-define var1 = $var1
-
-filter input iif $var1
-- 
2.13.6

