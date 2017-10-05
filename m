From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] test: shell: execute shell/run-tests.sh from any directory
Date: Thu,  5 Oct 2017 13:13:47 +0530
Message-ID: <20171005074347.20953-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Update shell/run-tests.sh to refer /src/nft with a relative path

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 4eba0a8..dbddd8d 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -3,7 +3,7 @@
 # Configuration
 TESTDIR="./"
 RETURNCODE_SEPARATOR="_"
-SRC_NFT="../../src/nft"
+SRC_NFT="$(dirname $0)/../../src/nft"
 
 msg_error() {
 	echo "E: $1 ..." >&2
-- 
2.11.0
