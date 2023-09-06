Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4A5EB8FAF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbjIFMC4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjIFMCz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D544171D
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ls6kQXZKUqselUpJ+TaOqzGcVyfdbrMgR7zl/GMSdUQ=;
        b=dGx9Pjr0dMrHlPno/qmmxG4j6yt3vJ/s4sQEeXYPWPDQEFR6UK4MPF5FE+GzzoT+c9FWXT
        CTh91Q0fMy9pwhVyz4ZtvEEaNtJGAiU/g1bFfxl96AqFFBzW4YfEN3B6g4SXIKf/k9ugtW
        GZkLpAFNgduxrUx1zMYzEkY36L0WyDg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-kHhSrkVjNLKGdxdV2ZQW6g-1; Wed, 06 Sep 2023 08:01:29 -0400
X-MC-Unique: kHhSrkVjNLKGdxdV2ZQW6g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6884C8AA800
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCCDBC15BB8;
        Wed,  6 Sep 2023 12:01:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 12/19] tests/shell: move taint check to "test-wrapper.sh"
Date:   Wed,  6 Sep 2023 13:52:15 +0200
Message-ID: <20230906120109.1773860-13-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We will run tests in parallel. That means, we have multiple tests data and results
in fly. That becomes simpler, if we move more result data to the
test-wrapper and out of "run-tests.sh".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 18 +++++++++++++++---
 tests/shell/run-tests.sh            | 16 ++++------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index bdbe2c370c6b..fee55e5f9df5 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -11,11 +11,15 @@ TESTDIR="$(dirname "$TEST")"
 
 printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
 
+read tainted_before < /proc/sys/kernel/tainted
+
 rc_test=0
 "$TEST" &> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 
 $NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
 
+read tainted_after < /proc/sys/kernel/tainted
+
 DUMPPATH="$TESTDIR/dumps"
 DUMPFILE="$DUMPPATH/$TESTBASE.nft"
 
@@ -45,6 +49,10 @@ if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
 	fi
 fi
 
+if [ "$tainted_before" != "$tainted_after" ] ; then
+	echo "$tainted_after" > "$NFT_TEST_TESTTMPDIR/rc-failed-tainted"
+fi
+
 rc_exit="$rc_test"
 if [ -n "$rc_dump" ] && [ "$rc_dump" -ne 0 ] ; then
 	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
@@ -53,13 +61,17 @@ if [ -n "$rc_dump" ] && [ "$rc_dump" -ne 0 ] ; then
 		# Special exit code to indicate dump diff.
 		rc_exit=124
 	fi
-elif [ "$rc_test" -eq 0 ] ; then
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-ok"
 elif [ "$rc_test" -eq 77 ] ; then
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-skipped"
+elif [ "$rc_test" -eq 0 -a "$tainted_before" = "$tainted_after" ] ; then
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-ok"
 else
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-failed"
-	if [ "$rc_test" -eq 124 ] ; then
+	if [ "$rc_test" -eq 0 -a "$tainted_before" != "$tainted_after" ] ; then
+		# Special exit code to indicate tainted.
+		rc_exit=123
+	elif [ "$rc_test" -eq 124 -o "$rc_test" -eq 123 ] ; then
+		# These exit codes are reserved
 		rc_exit=125
 	fi
 fi
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f52df85b0e43..92c63e354b96 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -351,15 +351,6 @@ echo ""
 ok=0
 skipped=0
 failed=0
-taint=0
-
-check_taint()
-{
-	read taint_now < /proc/sys/kernel/tainted
-	if [ $taint -ne $taint_now ] ; then
-		msg_warn "[FAILED]	kernel is tainted: $taint  -> $taint_now"
-	fi
-}
 
 kmem_runs=0
 kmemleak_found=0
@@ -401,7 +392,10 @@ check_kmemleak()
 	fi
 }
 
-check_taint
+read kernel_tainted < /proc/sys/kernel/tainted
+if [ "$kernel_tainted" -ne 0 ] ; then
+	msg_warn "[FAILED]	kernel is tainted"
+fi
 
 print_test_header() {
 	local msglevel="$1"
@@ -463,7 +457,6 @@ print_test_result() {
 
 TESTIDX=0
 for testfile in "${TESTS[@]}" ; do
-	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
 	((TESTIDX++))
@@ -481,7 +474,6 @@ for testfile in "${TESTS[@]}" ; do
 
 	print_test_result "$NFT_TEST_TESTTMPDIR" "$testfile" "$rc_got"
 
-	check_taint
 	check_kmemleak
 done
 
-- 
2.41.0

