Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72606EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 12:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjGTMwb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 08:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjGTMwK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 08:52:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DEE268C
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 05:52:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qMT8X-0008IH-Db; Thu, 20 Jul 2023 14:52:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: auto-run kmemleak if its available
Date:   Thu, 20 Jul 2023 14:51:57 +0200
Message-ID: <20230720125200.17428-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On my test vm a full scan takes almost 5s. As this would slowdown
the test runs too much, only run them every couple of tests.

This allows to detect when there is a leak reported at the
end of the script, and it allows to narrow down the test
case/group that triggers the issue.

Add new -K flag to force kmemleak runs after each test if its
available, this can then be used to find the exact test case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/run-tests.sh | 55 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 1a6998759831..980aea0fc510 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -74,6 +74,11 @@ if [ "$1" == "-V" ] ; then
 	shift
 fi
 
+if [ "$1" == "-K" ]; then
+	KMEMLEAK=y
+	shift
+fi
+
 for arg in "$@"; do
 	SINGLE+=" $arg"
 	VERBOSE=y
@@ -167,6 +172,50 @@ check_taint()
 	fi
 }
 
+kmem_runs=0
+kmemleak_found=0
+
+# kmemleak may report suspected leaks
+# that get free'd after all, so
+# do not increment failed counter
+# except for the last run.
+check_kmemleak_force()
+{
+	test -f /sys/kernel/debug/kmemleak || return 0
+
+	echo scan > /sys/kernel/debug/kmemleak
+
+	lines=$(grep "unreferenced object" /sys/kernel/debug/kmemleak | wc -l)
+	if [ $lines -ne $kmemleak_found ];then
+		msg_warn "[FAILED]	kmemleak detected $lines memory leaks"
+		kmemleak_found=$lines
+	fi
+
+	if [ $lines -ne 0 ];then
+		return 1
+	fi
+
+	return 0
+}
+
+check_kmemleak()
+{
+	test -f /sys/kernel/debug/kmemleak || return
+
+	if [ "$KMEMLEAK" == "y" ] ; then
+		check_kmemleak_force
+		return
+	fi
+
+	kmem_runs=$((kmem_runs + 1))
+	if [ $((kmem_runs % 30)) -eq 0 ]; then
+		# scan slows tests down quite a bit, hence
+		# do this only for every 30th test file by
+		# default.
+		check_kmemleak_force
+	fi
+}
+
 check_taint
 
 for testfile in $(find_tests)
@@ -218,9 +267,15 @@ do
 	fi
 
 	check_taint
+	check_kmemleak
 done
 
 echo ""
+check_kmemleak_force
+if [ "$?" -ne 0 ];then
+	((failed++))
+fi
+
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
 kernel_cleanup
-- 
2.41.0

