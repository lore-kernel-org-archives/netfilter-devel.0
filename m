From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 08/16] tests: files: Remove test for syntactical errors.
Date: Mon, 30 Oct 2017 02:19:23 +0530
Message-ID: <20171029204931.7792-8-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:51269 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:03 -0400
Received: by mail-pg0-f68.google.com with SMTP id p9so9675722pgc.8
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:03 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test for syntax error as they are not required.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/error.1 |  9 ---------
 tests/files/error.2 | 18 ------------------
 2 files changed, 27 deletions(-)
 delete mode 100644 tests/files/error.1
 delete mode 100644 tests/files/error.2

diff --git a/tests/files/error.1 b/tests/files/error.1
deleted file mode 100644
index bc3bf16..0000000
--- a/tests/files/error.1
+++ /dev/null
@@ -1,9 +0,0 @@
-#! nft -f
-
-# mixed syntactical and non-syntactical errors
-filter {
-filter input
-filter input tcp
-filter input tcp dport
-filter input tcp dport tcp
-filter input tcp dport tcp dport
diff --git a/tests/files/error.2 b/tests/files/error.2
deleted file mode 100644
index 744a63d..0000000
--- a/tests/files/error.2
+++ /dev/null
@@ -1,18 +0,0 @@
-#! nft -f
-
-# mixed syntactical and non-syntactical errors in blocks
-table filter {
-	# missing identifier
-	chain
-
-	# missing chain block
-	chain output
-
-	chain output {
-		tcp
-		tcp dport
-		tcp dport tcp
-		tcp dport tcp dport
-		tcp dport ssh
-	}
-}
-- 
2.13.6

