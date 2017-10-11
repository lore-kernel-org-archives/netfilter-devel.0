From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 8/9] tests: files: Remove tests for table.
Date: Wed, 11 Oct 2017 10:29:03 +0530
Message-ID: <4ca609955395f301bc0462fae05954a8f592dcce.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36068 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKE7j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:59:39 -0400
Received: by mail-pf0-f196.google.com with SMTP id z11so1218991pfk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:59:39 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test case for table. As test case for it is present
in tests/shell file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/obj-table | 9 ---------
 1 file changed, 9 deletions(-)
 delete mode 100644 tests/files/obj-table

diff --git a/tests/files/obj-table b/tests/files/obj-table
deleted file mode 100644
index 8b264cf..0000000
--- a/tests/files/obj-table
+++ /dev/null
@@ -1,9 +0,0 @@
-#! nft -f
-
-# table: add and delete table
-add table filter
-table delete filter
-
-# table: deleting table with chain must fail
-add chain filter output
-table delete filter
-- 
2.13.6

