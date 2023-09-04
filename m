Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8050FC71153
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbjIDNxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbjIDNxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4E0CF6
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSiQhYgUH0xGuXT9jFizlEcbh7nfbgNNMnLZSbBSiog=;
        b=d99zbktlo+5tf7YEb8csrhUS3ywTZa7jqhiyXJfJ0H9nH/xDjsriAs9qtypVpMcZG10GuG
        fv2tt86QegyC5wF+WFYTN0u8t5N3L67lA+UFZjKXzdUpnEyo0oBpzLNu5rEeJcDtUkwV8x
        1IEL9fk0XQBLr1RVKxFxkufTcWrV9z8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-aMA4N6QrM16ootYmLsDU0g-1; Mon, 04 Sep 2023 09:51:52 -0400
X-MC-Unique: aMA4N6QrM16ootYmLsDU0g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 766C11C0CCA2
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EADAA1121314;
        Mon,  4 Sep 2023 13:51:51 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 08/11] tests/shell: move the dump diff handling inside "test-wrapper.sh"
Date:   Mon,  4 Sep 2023 15:48:10 +0200
Message-ID: <20230904135135.1568180-9-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fits there better. At this point, we are  still inside the unshared
namespace and right after the test. The test-wrapper.sh should compare
(and generate) the dumps.

Also change behavior for DUMPGEN=y.

- Previously it would only rewrite the dump if the dumpfile didn't
  exist yet. Now instead, always rewrite the file with DUMPGEN=y.
  The mode of operation is anyway, that the developer afterwards
  checks `git diff|status` to pick up the changes. There should be
  no changes to existing files (as existing tests are supposed to
  pass). So a diff there either means something went wrong (and we
  should see it) or it just means the dumps correctly should be
  regenerated.

- also, only generate the file if the "dumps/" directory exists. This
  allows to write tests that don't have a dump file and don't get it
  automatically generated.

The test wrapper will return a special error code 124 to indicate that
the test passed, but the dumps file differed.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 56 +++++++++++++++++++++++++----
 tests/shell/run-tests.sh            | 45 +++++++++--------------
 2 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 8f0dc685e1fe..f9d759d0bb03 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -6,18 +6,60 @@
 # For some printf debugging, you can also patch this file.
 
 TEST="$1"
+TESTBASE="$(basename "$TEST")"
+TESTDIR="$(dirname "$TEST")"
 
 rc_test=0
 "$TEST" |& tee "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 
-if [ "$rc_test" -eq 0 ] ; then
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-ok"
+$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
+
+DUMPPATH="$TESTDIR/dumps"
+DUMPFILE="$DUMPPATH/$TESTBASE.nft"
+
+dump_written=
+rc_dump=
+
+# The caller can request a re-geneating of the dumps, by setting
+# DUMPGEN=y.
+#
+# This only will happen if the command completed with success.
+#
+# It also will only happen for tests, that have a "$DUMPPATH" directory. There
+# might be tests, that don't want to have dumps created. The existence of the
+# directory controls that.
+if [ "$rc_test" -eq 0 -a "$DUMPGEN" = y -a -d "$DUMPPATH" ] ; then
+	dump_written=y
+	cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
+fi
+
+if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
+	rc_dump=0
+	if [ "$dump_written" != y ] ; then
+		$DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" || rc_dump=$?
+		if [ "$rc_dump" -eq 0 ] ; then
+			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
+		fi
+	fi
+fi
+
+rc_exit="$rc_test"
+if [ -n "$rc_dump" ] && [ "$rc_dump" -ne 0 ] ; then
+	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-failed"
+	if [ "$rc_exit" -eq 0 ] ; then
+		# Special exit code to indicate dump diff.
+		rc_exit=124
+	fi
+elif [ "$rc_test" -eq 0 ] ; then
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-ok"
 elif [ "$rc_test" -eq 77 ] ; then
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-skipped"
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-skipped"
 else
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-failed"
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-failed"
+	if [ "$rc_test" -eq 124 ] ; then
+		rc_exit=125
+	fi
 fi
 
-$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
-
-exit "$rc_test"
+exit "$rc_exit"
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 8da0cc3d5702..a35337750ab7 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -30,7 +30,9 @@ usage() {
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>   : Path to nft executable"
 	echo " VERBOSE=*|y  : Enable verbose output"
-	echo " DUMPGEN=*|y  : Regenerate dump files"
+	echo " DUMPGEN=*|y  : Regenerate dump files. Dump files are only recreated if the"
+	echo "                test completes successfully and the \"dumps\" directory for the"
+	echo "                test exits."
 	echo " VALGRIND=*|y : Run \$NFT in valgrind"
 	echo " KMEMLEAK=*|y : Check for kernel memleaks"
 	echo " NFT_TEST_HAVE_REALROOT=*|y : To indicate whether the test has real root permissions."
@@ -340,38 +342,25 @@ for testfile in "${TESTS[@]}" ; do
 	export NFT_TEST_TESTTMPDIR
 
 	msg_info "[EXECUTING]	$testfile"
-	test_output="$(NFT="$NFT" DIFF=$DIFF $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile" 2>&1)"
+	test_output="$(NFT="$NFT" DIFF=$DIFF DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile" 2>&1)"
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-	if [ "$rc_got" -eq 0 ] ; then
-		# FIXME: this should move inside test-wrapper.sh.
-		# check nft dump only for positive tests
-		dumppath="$(dirname ${testfile})/dumps"
-		dumpfile="${dumppath}/$(basename ${testfile}).nft"
-		rc_spec=0
-		if [ "$rc_got" -eq 0 ] && [ -f ${dumpfile} ]; then
-			test_output=$(${DIFF} -u ${dumpfile} <(cat "$NFT_TEST_TESTTMPDIR/ruleset-after") 2>&1)
-			rc_spec=$?
-		fi
-
-		if [ "$rc_spec" -eq 0 ]; then
-			msg_info "[OK]		$testfile"
-			[ "$VERBOSE" == "y" ] && [ ! -z "$test_output" ] && echo "$test_output"
-			((ok++))
+	if [ -s "$NFT_TEST_TESTTMPDIR/ruleset-diff" ] ; then
+		test_output="$test_output$(cat "$NFT_TEST_TESTTMPDIR/ruleset-diff")"
+	fi
 
-			if [ "$DUMPGEN" == "y" ] && [ "$rc_got" == 0 ] && [ ! -f "${dumpfile}" ]; then
-				mkdir -p "${dumppath}"
-				cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "${dumpfile}"
-			fi
+	if [ "$rc_got" -eq 0 ] ; then
+		((ok++))
+		msg_info "[OK]		$testfile"
+		[ "$VERBOSE" == "y" ] && [ ! -z "$test_output" ] && echo "$test_output"
+	elif [ "$rc_got" -eq 124 ] ; then
+		((failed++))
+		if [ "$VERBOSE" == "y" ] ; then
+			msg_warn "[DUMP FAIL]	$testfile: dump diff detected"
+			[ ! -z "$test_output" ] && echo "$test_output"
 		else
-			((failed++))
-			if [ "$VERBOSE" == "y" ] ; then
-				msg_warn "[DUMP FAIL]	$testfile: dump diff detected"
-				[ ! -z "$test_output" ] && echo "$test_output"
-			else
-				msg_warn "[DUMP FAIL]	$testfile"
-			fi
+			msg_warn "[DUMP FAIL]	$testfile"
 		fi
 	elif [ "$rc_got" -eq 77 ] ; then
 		((skipped++))
-- 
2.41.0

