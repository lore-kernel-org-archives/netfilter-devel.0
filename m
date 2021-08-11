Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB44C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0286161008
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHKWx7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 18:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKWx7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 18:53:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC07CC061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 15:53:34 -0700 (PDT)
Received: from localhost ([::1]:56304 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mDx6L-0005PL-5P; Thu, 12 Aug 2021 00:53:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] tests: monitor: Continue on error
Date:   Thu, 12 Aug 2021 00:53:27 +0200
Message-Id: <20210811225327.26229-3-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811225327.26229-1-phil@nwl.cc>
References: <20210811225327.26229-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just make sure return code reflects the overall result.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index c30c328ca6e1e..ff00450b19c23 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -63,6 +63,7 @@ monitor_run_test() {
 	monitor_output=$(mktemp -p $testdir)
 	monitor_args=""
 	$test_json && monitor_args="vm json"
+	local rc=0
 
 	$nft -nn monitor $monitor_args >$monitor_output &
 	monitor_pid=$!
@@ -75,44 +76,48 @@ monitor_run_test() {
 	}
 	$nft -f $command_file || {
 		err "nft command failed!"
-		kill $monitor_pid
-		wait >/dev/null 2>&1
-		exit 1
+		rc=1
 	}
 	sleep 0.5
 	kill $monitor_pid
 	wait >/dev/null 2>&1
 	$test_json && json_output_filter $monitor_output
-	if ! mydiff -q $monitor_output $output_file >/dev/null 2>&1; then
+	mydiff -q $monitor_output $output_file >/dev/null 2>&1
+	if [[ $rc == 0 && $? != 0 ]]; then
 		err "monitor output differs!"
 		mydiff -u $output_file $monitor_output >&2
-		exit 1
+		rc=1
 	fi
 	rm $command_file
 	rm $output_file
 	touch $command_file
 	touch $output_file
+	return $rc
 }
 
 echo_run_test() {
 	echo_output=$(mktemp -p $testdir)
+	local rc=0
+
 	$debug && {
 		echo "command file:"
 		cat $command_file
 	}
 	$nft -nn -e -f $command_file >$echo_output || {
 		err "nft command failed!"
-		exit 1
+		rc=1
 	}
-	if ! mydiff -q $echo_output $output_file >/dev/null 2>&1; then
+	mydiff -q $echo_output $output_file >/dev/null 2>&1
+	if [[ $rc == 0 && $? != 0 ]]; then
 		err "echo output differs!"
 		mydiff -u $output_file $echo_output >&2
-		exit 1
+		rc=1
 	fi
 	rm $command_file
 	rm $output_file
 	touch $command_file
 	touch $output_file
+	return $rc
 }
 
 testcases=""
@@ -150,6 +155,7 @@ else
 	variants="monitor echo"
 fi
 
+rc=0
 for variant in $variants; do
 	run_test=${variant}_run_test
 	output_append=${variant}_output_append
@@ -169,7 +175,10 @@ for variant in $variants; do
 		while read dir line; do
 			case $dir in
 			I)
-				$input_complete && $run_test
+				$input_complete && {
+					$run_test
+					let "rc += $?"
+				}
 				input_complete=false
 				cmd_append "$line"
 				;;
@@ -186,6 +195,10 @@ for variant in $variants; do
 				;;
 			esac
 		done <$testcase
-		$input_complete && $run_test
+		$input_complete && {
+			$run_test
+			let "rc += $?"
+		}
 	done
 done
+exit $rc
-- 
2.32.0

