Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1505BCA0FE2
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbjIEQ1K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354496AbjIEMB0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3595CCB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZSx1yM99noPGnhoi/Vpo07W9qNIBGynOg3AtVIWlAY=;
        b=cR87wmdKcIerngMN4sJXjlaqArBdDZDn7KDX0QD0DXDjux6pd2sx/4BBRL1CUeuuqvrOkT
        +dz3LxjKg13IhbOf8NY1uUsNDskuKCkoTloPBviSnwiKo5NnON/jLTmcJx/OdnkCvuDuQR
        GRnrZ62z0btGOHGgidFaUnQaMKooFiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-iyGC26G9PDuLl60_i9-BnQ-1; Tue, 05 Sep 2023 07:59:55 -0400
X-MC-Unique: iyGC26G9PDuLl60_i9-BnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84F2A939380
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 057D91121314;
        Tue,  5 Sep 2023 11:59:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 11/17] tests/shell: rework printing of test results
Date:   Tue,  5 Sep 2023 13:58:40 +0200
Message-ID: <20230905115936.607599-12-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- "test-wrapper.sh" no longer will print the test output to its stdout.
  Instead, it only writes the testout.log file.

- rework the loop "run-tests.sh" for printing the test results. It no
  longer captures the output of the test, as the wrapper is expected to
  be silent. Instead, they get the output from the result directory.
  The benefit is, that there is no duplication in what we print and the
  captured data in the result directory. The verbose mode is only for
  convenience, to safe looking at the test data. It's not essential
  otherwise.

- also move the evaluation of the test result (and printing of the
  information) to a separate function. Later we want to run tests in
  parallel, so the steps need to be clearly separated.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh |   2 +-
 tests/shell/run-tests.sh            | 122 +++++++++++++++++++---------
 2 files changed, 84 insertions(+), 40 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index dd5ce7ace7ad..bdbe2c370c6b 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -12,7 +12,7 @@ TESTDIR="$(dirname "$TEST")"
 printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
 
 rc_test=0
-"$TEST" |& tee "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
+"$TEST" &> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 
 $NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
 
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index dc5295634baa..f88e244f9625 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,16 +1,31 @@
 #!/bin/bash
 
+_msg() {
+	local level="$1"
+	shift
+	local msg
+
+	msg="$level: $*"
+	if [ "$level" = E -o "$level" = W ] ; then
+		printf '%s\n' "$msg" >&2
+	else
+		printf '%s\n' "$msg"
+	fi
+	if [ "$level" = E ] ; then
+		exit 1
+	fi
+}
+
 msg_error() {
-	echo "E: $1 ..." >&2
-	exit 1
+	_msg E "$@"
 }
 
 msg_warn() {
-	echo "W: $1" >&2
+	_msg W "$@"
 }
 
 msg_info() {
-	echo "I: $1"
+	_msg I "$@"
 }
 
 bool_y() {
@@ -393,6 +408,67 @@ check_kmemleak()
 
 check_taint
 
+print_test_header() {
+	local msglevel="$1"
+	local testfile="$2"
+	local status="$3"
+	local suffix="$4"
+	local text
+
+	if [ -n "$suffix" ] ; then
+		suffix=": $suffix"
+	fi
+	text="[$status]"
+	text="$(printf '%-12s' "$text")"
+	_msg "$msglevel" "$text $testfile$suffix"
+}
+
+print_test_result() {
+	local NFT_TEST_TESTTMPDIR="$1"
+	local testfile="$2"
+	local rc_got="$3"
+	shift 3
+
+	local result_msg_level="I"
+	local result_msg_status="OK"
+	local result_msg_suffix=""
+	local result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" "$NFT_TEST_TESTTMPDIR/ruleset-diff" )
+
+	if [ "$rc_got" -eq 0 ] ; then
+		((ok++))
+	elif [ "$rc_got" -eq 124 ] ; then
+		((failed++))
+		result_msg_level="W"
+		result_msg_status="DUMP FAIL"
+	elif [ "$rc_got" -eq 77 ] ; then
+		((skipped++))
+		result_msg_level="I"
+		result_msg_status="SKIPPED"
+	else
+		((failed++))
+		result_msg_level="W"
+		result_msg_status="FAILED"
+		result_msg_suffix="got $rc_got"
+		result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" )
+	fi
+
+	print_test_header "$result_msg_level" "$testfile" "$result_msg_status" "$result_msg_suffix"
+
+	if [ "$VERBOSE" = "y" ] ; then
+		local f
+
+		for f in "${result_msg_files[@]}"; do
+			if [ -s "$f" ] ; then
+				cat "$f"
+			fi
+		done
+
+		if [ "$rc_got" -ne 0 ] ; then
+			msg_info "check \"$NFT_TEST_TESTTMPDIR\""
+		fi
+	fi
+}
+
 TESTIDX=0
 for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
@@ -406,44 +482,12 @@ for testfile in "${TESTS[@]}" ; do
 	chmod 755 "$NFT_TEST_TESTTMPDIR"
 	export NFT_TEST_TESTTMPDIR
 
-	msg_info "[EXECUTING]	$testfile"
-	test_output="$(NFT="$NFT" DIFF=$DIFF DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile" 2>&1)"
+	print_test_header I "$testfile" "EXECUTING" ""
+	NFT="$NFT" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-	if [ -s "$NFT_TEST_TESTTMPDIR/ruleset-diff" ] ; then
-		test_output="$test_output$(cat "$NFT_TEST_TESTTMPDIR/ruleset-diff")"
-	fi
-
-	if [ "$rc_got" -eq 0 ] ; then
-		((ok++))
-		msg_info "[OK]		$testfile"
-		[ "$VERBOSE" == "y" ] && [ ! -z "$test_output" ] && echo "$test_output"
-	elif [ "$rc_got" -eq 124 ] ; then
-		((failed++))
-		if [ "$VERBOSE" == "y" ] ; then
-			msg_warn "[DUMP FAIL]	$testfile: dump diff detected"
-			[ ! -z "$test_output" ] && echo "$test_output"
-		else
-			msg_warn "[DUMP FAIL]	$testfile"
-		fi
-	elif [ "$rc_got" -eq 77 ] ; then
-		((skipped++))
-		if [ "$VERBOSE" == "y" ] ; then
-			msg_warn "[SKIPPED]	$testfile"
-			[ ! -z "$test_output" ] && echo "$test_output"
-		else
-			msg_warn "[SKIPPED]	$testfile"
-		fi
-	else
-		((failed++))
-		if [ "$VERBOSE" == "y" ] ; then
-			msg_warn "[FAILED]	$testfile: got $rc_got"
-			[ ! -z "$test_output" ] && echo "$test_output"
-		else
-			msg_warn "[FAILED]	$testfile"
-		fi
-	fi
+	print_test_result "$NFT_TEST_TESTTMPDIR" "$testfile" "$rc_got"
 
 	check_taint
 	check_kmemleak
-- 
2.41.0

