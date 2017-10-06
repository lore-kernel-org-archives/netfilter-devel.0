From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] test: shell: update shell/run-tests.sh to refer to relative path of testcase
Date: Sat,  7 Oct 2017 04:17:52 +0530
Message-ID: <20171006224752.2188-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35422 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJFWuK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 18:50:10 -0400
Received: by mail-pg0-f65.google.com with SMTP id l24so2297714pgu.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Oct 2017 15:50:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refer to relative path for tests from any directory if path for testcases
is specified.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index dbddd8d..fe30115 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
 # Configuration
-TESTDIR="./"
+TESTDIR="./$(dirname $0)/"
 RETURNCODE_SEPARATOR="_"
 SRC_NFT="$(dirname $0)/../../src/nft"
 
-- 
2.11.0

