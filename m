From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: build: Add README.
Date: Thu, 18 Jan 2018 00:28:33 +0530
Message-ID: <20180117185833.18912-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32878 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752579AbeAQS6t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 13:58:49 -0500
Received: by mail-pg0-f65.google.com with SMTP id i196so11791062pgd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 10:58:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add readme for compile options test script.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/build/README | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 tests/build/README

diff --git a/tests/build/README b/tests/build/README
new file mode 100644
index 0000000..d6900ff
--- /dev/null
+++ b/tests/build/README
@@ -0,0 +1,12 @@
+Testsuite for NFT compile options.
+
+In this testsuite, automated testing is done for following nft compile options:
+
+  cli support
+  enable debugging symbols
+  use mini-gmp
+  enable pdf documentation
+  libxtables support
+
+Run the test script 'run-tests.sh' as root user: ./run-tests.sh
+Any error encountered on compiling is saved in tests/build/tests.log file.
-- 
2.14.3

