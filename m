Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69584EB8FB7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbjIFMDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjIFMDA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C91723
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dYBnHXPHQiS/0PoPimR0nX5moMiVw8D6QiwiV3fUlg4=;
        b=IglG8WH6+RpSPi2jwVXI6/E1dMJ3s3kF70zzjbpF/ZHquABuMpLZwrlwQSvph0qVNUUGlH
        UZQkwL9tT7HEjMXVeJOtG80oZ2sRG5lEhdMoVVBALd7VkCDvvcqPo9VcsBas7xQ7N0EQeM
        xDk8r2czgDEF6Ct9qo9JeSD5hpHgiqY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-jyp3Qv9INeGaF15mfX6Sdw-1; Wed, 06 Sep 2023 08:01:31 -0400
X-MC-Unique: jyp3Qv9INeGaF15mfX6Sdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F26EE8015AA
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72F24C15BB8;
        Wed,  6 Sep 2023 12:01:30 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 14/19] tests/shell: support running tests in parallel
Date:   Wed,  6 Sep 2023 13:52:17 +0200
Message-ID: <20230906120109.1773860-15-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add option to enable running jobs in parallel. The purpose is to speed
up the run time of the tests.

The global cleanup (removal of kernel modules) interferes with parallel
jobs (or even with, unrelated jobs on the system). By setting
NFT_TEST_JOBS= to a positive number, that cleanup is skipped.

This option is too good to miss. Hence parallel execution is enabled by
default, and you have to opt-out from it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 86 ++++++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b49877fe473e..1af1c0f3013f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -52,6 +52,7 @@ usage() {
 	echo " -R|--without-realroot : Sets NFT_TEST_HAS_REALROOT=n."
 	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " -k|--keep-logs  : Sets NFT_TEST_KEEP_LOGS=y."
+	echo " -s|--sequential : Sets NFT_TEST_JOBS=0, which also enables global cleanups."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
 	echo "                   that is, executables that are run by the runner."
@@ -89,6 +90,11 @@ usage() {
 	echo "                 Test may consider this."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
 	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
+	echo " NFT_TEST_JOBS=<NUM}>: number of jobs for parallel execution. Defaults to \"12\" for parallel run."
+	echo "                 Setting this to \"0\" or \"1\", means to run jobs sequentially."
+	echo "                 Setting this to \"0\" means also to perform global cleanups between tests (remove"
+	echo "                 kernel modules)."
+	echo "                 Parallel jobs requires unshare and are disabled with NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data."
 }
 
@@ -103,6 +109,7 @@ VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
+NFT_TEST_JOBS="${NFT_TEST_JOBS:-12}"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -139,6 +146,9 @@ while [ $# -gt 0 ] ; do
 		-U|--no-unshare)
 			NFT_TEST_UNSHARE_CMD=
 			;;
+		-s|--sequential)
+			NFT_TEST_JOBS=0
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -236,6 +246,14 @@ fi
 # If tests wish, they can know whether they are unshared via this variable.
 export NFT_TEST_HAS_UNSHARED
 
+# normalize the jobs number to be an integer.
+case "$NFT_TEST_JOBS" in
+	''|*[!0-9]*) NFT_TEST_JOBS=12 ;;
+esac
+if [ -z "$NFT_TEST_UNSHARE_CMD" -a "$NFT_TEST_JOBS" -gt 1 ] ; then
+	NFT_TEST_JOBS=1
+fi
+
 [ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -243,9 +261,11 @@ if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
 	msg_error "cannot execute nft command: $NFT"
 fi
 
-MODPROBE="$(which modprobe)"
-if [ ! -x "$MODPROBE" ] ; then
-	msg_error "no modprobe binary found"
+if [ "$NFT_TEST_JOBS" -eq 0 ] ; then
+	MODPROBE="$(which modprobe)"
+	if [ ! -x "$MODPROBE" ] ; then
+		msg_error "no modprobe binary found"
+	fi
 fi
 
 DIFF="$(which diff)"
@@ -276,6 +296,7 @@ msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
+msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
 NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
@@ -291,6 +312,11 @@ msg_info "info: NFT_TEST_BASEDIR=$(printf '%q' "$NFT_TEST_BASEDIR")"
 msg_info "info: NFT_TEST_TMPDIR=$(printf '%q' "$NFT_TEST_TMPDIR")"
 
 kernel_cleanup() {
+	if [ "$NFT_TEST_JOBS" -ne 0 ] ; then
+		# When we run jobs in parallel (even with only one "parallel"
+		# job via `NFT_TEST_JOBS=1`), we skip such global cleanups.
+		return
+	fi
 	if [ "$NFT_TEST_HAS_UNSHARED" != y ] ; then
 		$NFT flush ruleset
 	fi
@@ -428,28 +454,62 @@ print_test_result() {
 	fi
 }
 
+declare -A JOBS_TEMPDIR
+declare -A JOBS_PIDLIST
+
+job_start() {
+	local testfile="$1"
+
+	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
+		print_test_header I "$testfile" "EXECUTING" ""
+	fi
+
+	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
+	NFT="$NFT" NFT_REAL="$NFT_REAL" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
+	local rc_got=$?
+
+	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
+		echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
+	fi
+
+	return "$rc_got"
+}
+
+job_wait()
+{
+	local num_jobs="$1"
+
+	while [ "$JOBS_N_RUNNING" -gt 0 -a "$JOBS_N_RUNNING" -ge "$num_jobs" ] ; do
+		wait -n -p JOBCOMPLETED
+		local rc_got="$?"
+		testfile2="${JOBS_PIDLIST[$JOBCOMPLETED]}"
+		print_test_result "${JOBS_TEMPDIR["$testfile2"]}" "$testfile2" "$rc_got"
+		((JOBS_N_RUNNING--))
+		check_kmemleak
+	done
+}
+
 TESTIDX=0
+JOBS_N_RUNNING=0
 for testfile in "${TESTS[@]}" ; do
+	job_wait "$NFT_TEST_JOBS"
+
 	kernel_cleanup
 
 	((TESTIDX++))
 
-	# We also create and export a test-specific temporary directory.
 	NFT_TEST_TESTTMPDIR="$NFT_TEST_TMPDIR/test-${testfile//\//-}.$TESTIDX"
 	mkdir "$NFT_TEST_TESTTMPDIR"
 	chmod 755 "$NFT_TEST_TESTTMPDIR"
-	export NFT_TEST_TESTTMPDIR
-
-	print_test_header I "$testfile" "EXECUTING" ""
-	NFT="$NFT" NFT_REAL="$NFT_REAL" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
-	rc_got=$?
-	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
-
-	print_test_result "$NFT_TEST_TESTTMPDIR" "$testfile" "$rc_got"
+	JOBS_TEMPDIR["$testfile"]="$NFT_TEST_TESTTMPDIR"
 
-	check_kmemleak
+	job_start "$testfile" &
+	JOBS_PIDLIST[$!]="$testfile"
+	((JOBS_N_RUNNING++))
 done
 
+job_wait 0
+
 echo ""
 
 # kmemleak may report suspected leaks
-- 
2.41.0

