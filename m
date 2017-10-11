From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 7/9] tests: files: Remove tests for chain.
Date: Wed, 11 Oct 2017 10:26:08 +0530
Message-ID: <e54decd6d96b05de3fd424a465ec6ee2641dced2.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36419 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdJKE4i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:56:38 -0400
Received: by mail-pf0-f195.google.com with SMTP id z11so1207496pfk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:56:38 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test cases for chain are there in tests/shell file. So, remove these
testcases.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/obj-chain | 22 ----------------------
 1 file changed, 22 deletions(-)
 delete mode 100644 tests/files/obj-chain

diff --git a/tests/files/obj-chain b/tests/files/obj-chain
deleted file mode 100644
index 2bce026..0000000
--- a/tests/files/obj-chain
+++ /dev/null
@@ -1,22 +0,0 @@
-#! nft -f
-
-add table filter
-
-# chains: add and delete chain
-add chain filter testchain
-delete chain filter testchain
-
-# chains: add and delete base chain
-add chain filter input { type filter hook input priority 0 ; }
-delete chain filter input
-
-# chains: can not delete chain while referenced
-add chain filter testchain
-add chain filter testchain2
-
-add rule filter testchain handle 1 jump testchain2
-delete chain filter testchain2
-delete rule filter testchain handle 1
-
-delete chain filter testchain2
-delete chain filter testchain
-- 
2.13.6

