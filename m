From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: build: Add enable man page option.
Date: Thu, 25 Jan 2018 20:48:52 +0530
Message-ID: <20180125151853.4740-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33022 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeAYPTb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jan 2018 10:19:31 -0500
Received: by mail-pg0-f67.google.com with SMTP id u1so5250073pgr.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 07:19:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add test for man page compile option.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/build/README       | 1 +
 tests/build/run-tests.sh | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/build/README b/tests/build/README
index 8eca252..dfe344b 100644
--- a/tests/build/README
+++ b/tests/build/README
@@ -5,6 +5,7 @@ In this testsuite, automated testing is done for following nft compile options:
   cli support
   enable debugging symbols
   use mini-gmp
+  enable man page
   enable pdf documentation
   libxtables support
 
diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index 36cd8d8..109b2b5 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -9,7 +9,8 @@ log_file="`pwd`/tests.log"
 tarball="nftables-0.8.1.tar.bz2"
 dir=../..
 cmd=./configure
-argument=( --without-cli --enable-debug --with-mini-gmp --enable-pdf-doc --with-xtables )
+argument=( --without-cli --enable-debug --with-mini-gmp --enable-man-doc
+	    --enable-pdf-doc --with-xtables)
 ok=0
 failed=0
 
-- 
2.14.3

