Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A58C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC2E61008
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhHKWxy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 18:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKWxy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 18:53:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03524C061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 15:53:29 -0700 (PDT)
Received: from localhost ([::1]:56298 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mDx6F-0005Oz-So; Thu, 12 Aug 2021 00:53:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/3] tests: monitor: Print errors to stderr
Date:   Thu, 12 Aug 2021 00:53:26 +0200
Message-Id: <20210811225327.26229-2-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811225327.26229-1-phil@nwl.cc>
References: <20210811225327.26229-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While being at it, introduce die() to error and exit. But don't use it
everywhere to prepare for continuing on errors.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 1fe613c7bc301..c30c328ca6e1e 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -9,15 +9,22 @@ mydiff() {
 	diff -w -I '^# ' "$@"
 }
 
-if [ "$(id -u)" != "0" ] ; then
-	echo "this requires root!"
+err() {
+	echo "$*" >&2
+}
+
+die() {
+	err "$*"
 	exit 1
+}
+
+if [ "$(id -u)" != "0" ] ; then
+	die "this requires root!"
 fi
 
 testdir=$(mktemp -d)
 if [ ! -d $testdir ]; then
-	echo "Failed to create test directory" >&2
-	exit 1
+	die "Failed to create test directory"
 fi
 trap 'rm -rf $testdir; $nft flush ruleset' EXIT
 
@@ -67,7 +74,7 @@ monitor_run_test() {
 		cat $command_file
 	}
 	$nft -f $command_file || {
-		echo "nft command failed!"
+		err "nft command failed!"
 		kill $monitor_pid
 		wait >/dev/null 2>&1
 		exit 1
@@ -77,8 +84,8 @@ monitor_run_test() {
 	wait >/dev/null 2>&1
 	$test_json && json_output_filter $monitor_output
 	if ! mydiff -q $monitor_output $output_file >/dev/null 2>&1; then
-		echo "monitor output differs!"
-		mydiff -u $output_file $monitor_output
+		err "monitor output differs!"
+		mydiff -u $output_file $monitor_output >&2
 		exit 1
 	fi
 	rm $command_file
@@ -94,12 +101,12 @@ echo_run_test() {
 		cat $command_file
 	}
 	$nft -nn -e -f $command_file >$echo_output || {
-		echo "nft command failed!"
+		err "nft command failed!"
 		exit 1
 	}
 	if ! mydiff -q $echo_output $output_file >/dev/null 2>&1; then
-		echo "echo output differs!"
-		mydiff -u $output_file $echo_output
+		err "echo output differs!"
+		mydiff -u $output_file $echo_output >&2
 		exit 1
 	fi
 	rm $command_file
-- 
2.32.0

