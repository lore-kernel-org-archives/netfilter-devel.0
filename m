From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/6] tests/monitor: Ignore newgen messages in output
Date: Tue, 25 Jul 2017 16:56:24 +0200
Message-ID: <20170725145629.20974-2-phil@nwl.cc>
References: <20170725145629.20974-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59769 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbdGYO4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 10:56:48 -0400
In-Reply-To: <20170725145629.20974-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Predicting the new ID value is not feasible and neither is implementing
support for regular expressions when matching monitor output, so simply
ignore them.

Also use diff option '-w' instead of '-Z' to ignore all whitespace, not
just at EOL.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 7447adf1febd6..e21ed6880bc13 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -10,6 +10,9 @@ fi
 trap "rm -rf $testdir" EXIT
 
 nft=../../src/nft
+mydiff() {
+	diff -w -I '^# ' "$@"
+}
 command_file=$(mktemp -p $testdir)
 output_file=$(mktemp -p $testdir)
 
@@ -35,9 +38,9 @@ run_test() {
 	sleep 0.5
 	kill $monitor_pid
 	wait >/dev/null 2>&1
-	if ! diff -Z -q $monitor_output $output_file >/dev/null 2>&1; then
+	if ! mydiff -q $monitor_output $output_file >/dev/null 2>&1; then
 		echo "monitor output differs!"
-		diff -Z -u $output_file $monitor_output
+		mydiff -u $output_file $monitor_output
 		exit 1
 	fi
 	rm $command_file
-- 
2.13.1

