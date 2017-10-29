From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 15/16] tests: files: Remove tests for concat expression.
Date: Mon, 30 Oct 2017 02:19:30 +0530
Message-ID: <20171029204931.7792-15-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:43728 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:21 -0400
Received: by mail-pf0-f194.google.com with SMTP id a8so9238391pfc.0
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:21 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New test cases for concat expression has been added to tests/shell file,
so remove it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/expr-concat | 19 -------------------
 1 file changed, 19 deletions(-)
 delete mode 100644 tests/files/expr-concat

diff --git a/tests/files/expr-concat b/tests/files/expr-concat
deleted file mode 100644
index bb284cc..0000000
--- a/tests/files/expr-concat
+++ /dev/null
@@ -1,19 +0,0 @@
-#! nft -f
-
-# Concat element mismatch
-add rule ip filter output ip daddr . tcp sport . tcp dport { \
-	192.168.0.1 . 22,	\
-	192.168.0.1 . 80,	\
-}
-
-# Concat type mismatch
-add rule ip filter output ip daddr . tcp dport { \
-	192.168.0.1 . 192.168.0.2,	\
-	192.168.0.1 . 192.168.0.3,	\
-}
-
-# Concat expression
-add rule ip filter output ip daddr . tcp dport { \
-	192.168.0.1 . 22,	\
-	192.168.0.1 . 80,	\
-}
-- 
2.13.6

