From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 04/16] tests: files: Remove log statement tests.
Date: Mon, 30 Oct 2017 02:19:19 +0530
Message-ID: <20171029204931.7792-4-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:56567 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdJ2Utx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:53 -0400
Received: by mail-pg0-f68.google.com with SMTP id m18so9672273pgd.13
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:53 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New test case for log statement has been added to tests/shell file, so
remove it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/stmt-log | 6 ------
 1 file changed, 6 deletions(-)
 delete mode 100644 tests/files/stmt-log

diff --git a/tests/files/stmt-log b/tests/files/stmt-log
deleted file mode 100644
index 2ae7aae..0000000
--- a/tests/files/stmt-log
+++ /dev/null
@@ -1,6 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0; }
-
-add rule ip filter output log saddr "prefix" group 0 counter
-- 
2.13.6

