From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 07/16] tests: files: Remove payload expression tests.
Date: Mon, 30 Oct 2017 02:19:22 +0530
Message-ID: <20171029204931.7792-7-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:54133 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:01 -0400
Received: by mail-pg0-f67.google.com with SMTP id s2so9670614pge.10
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:01 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove test for payload expression as new test has been added to
tests/shell.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/feat-adjancent-load-merging | 13 -------------
 1 file changed, 13 deletions(-)
 delete mode 100644 tests/files/feat-adjancent-load-merging

diff --git a/tests/files/feat-adjancent-load-merging b/tests/files/feat-adjancent-load-merging
deleted file mode 100644
index 1177174..0000000
--- a/tests/files/feat-adjancent-load-merging
+++ /dev/null
@@ -1,13 +0,0 @@
-#! nft -f
-
-# adjacent payload expressions: 4 bytes in order
-add rule filter output tcp sport 1024 tcp dport 22 counter
-
-# adjacent payload expressions: 8 bytes in order
-add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter
-
-# adjacent payload expressions: 8 bytes in order
-add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22
-
-# adjacent payload expressions: 8 bytes in reverse order
-add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0
-- 
2.13.6

