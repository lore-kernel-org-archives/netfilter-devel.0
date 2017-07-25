From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 3/3] tests/monitor: Clear ruleset after testing
Date: Tue, 25 Jul 2017 20:39:44 +0200
Message-ID: <20170725183944.9377-4-phil@nwl.cc>
References: <20170725183944.9377-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39361 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750857AbdGYSj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 14:39:57 -0400
In-Reply-To: <20170725183944.9377-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index de19462438d64..9fd0e504d08c0 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -2,17 +2,18 @@
 
 cd $(dirname $0)
 
+nft=../../src/nft
+mydiff() {
+	diff -w -I '^# ' "$@"
+}
+
 testdir=$(mktemp -d)
 if [ ! -d $testdir ]; then
 	echo "Failed to create test directory" >&2
 	exit 0
 fi
-trap "rm -rf $testdir" EXIT
+trap "rm -rf $testdir; $nft flush ruleset" EXIT
 
-nft=../../src/nft
-mydiff() {
-	diff -w -I '^# ' "$@"
-}
 command_file=$(mktemp -p $testdir)
 output_file=$(mktemp -p $testdir)
 
-- 
2.13.1

