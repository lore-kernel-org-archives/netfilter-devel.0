Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B67FC88CB2
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbjIDNx0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbjIDNxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBE3CFE
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AoSUWY9JQq/67guYpyEf28gaFCM3e2OFBijIclCDJHo=;
        b=M/pklE/DcX3AaYv+sjCvppWbGhMlrpULv1OTxsBE86xKAZrxQbDS1Cl7qIZkh+272GBTQI
        cqkMztptmOvanh4fUM5vlthsIEHWZUzuutyLOt1UojSraRgz0BH4ev3s2lmRef4TPNWuwB
        dp7hI0M5epii9no6nCzrfb3qnO+5f+Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-Fg3oBn71Oe-h_2w4KfWUag-1; Mon, 04 Sep 2023 09:51:55 -0400
X-MC-Unique: Fg3oBn71Oe-h_2w4KfWUag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C241B1C0CCA6
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 427B31121318;
        Mon,  4 Sep 2023 13:51:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 11/11] tests/shell: support running tests in parallel
Date:   Mon,  4 Sep 2023 15:48:13 +0200
Message-ID: <20230904135135.1568180-12-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add option to enable running jobs in parallel. The purpose is to speed
up the run time of the tests.

The global cleanup (removal of kernel modules) interferes with parallel
jobs (or even with, unrelated jobs on the system). By setting
NFT_TEST_JOBS= to a positive number, that cleanup is skipped.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 83 +++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 14 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 1451d913bd3a..160524e889ed 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -41,6 +41,7 @@ usage() {
 	echo " -R|--without-realroot : sets NFT_TEST_HAVE_REALROOT=n"
 	echo " -U|--no-unshare  : sets NFT_TEST_NO_UNSHARE=y"
 	echo " -k|--keep-logs   : sets NFT_TEST_KEEP_LOGS=y"
+	echo " -j|--jobs        : sets NFT_TEST_JOBS=12"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>   : Path to nft executable"
@@ -69,6 +70,10 @@ usage() {
 	echo "                Set to empty to not unshare. You may want to export NFT_TEST_IS_UNSHARED="
 	echo "                and NFT_TEST_HAVE_REALROOT= accordingly."
 	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
+	echo " NFT_TEST_JOBS=<NUM}>: by default, run test sequentially. Set to an integer > 1 to"
+	echo "                run jobs in parallel. Leaving this unset or at zero means to run jobs sequentially"
+	echo "                and perform global cleanups between tests (remove kernel modules). Setting this"
+	echo "                to a positive number (including \"1\") means to disable such global cleanups."
 }
 
 NFT_TEST_BASEDIR="$(dirname "$0")"
@@ -83,6 +88,7 @@ KMEMLEAK="$KMEMLEAK"
 NFT_TEST_KEEP_LOGS="$NFT_TEST_KEEP_LOGS"
 NFT_TEST_HAVE_REALROOT="$NFT_TEST_HAVE_REALROOT"
 NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
+NFT_TEST_JOBS="$NFT_TEST_JOBS"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -119,6 +125,9 @@ while [ $# -gt 0 ] ; do
 		-U|--no-unshare)
 			NFT_TEST_NO_UNSHARE=y
 			;;
+		-j|--jobs)
+			NFT_TEST_JOBS=12
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -132,6 +141,11 @@ while [ $# -gt 0 ] ; do
 	esac
 done
 
+# normalize the jobs number to be an integer.
+case "$NFT_TEST_JOBS" in
+	''|*[!0-9]*) NFT_TEST_JOBS=0 ;;
+esac
+
 find_tests() {
 	find "$1" -type f -executable | sort
 }
@@ -199,13 +213,15 @@ ${NFT} > /dev/null 2>&1
 ret=$?
 if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
 	msg_error "cannot execute nft command: ${NFT}"
-else
-	msg_info "using nft command: ${NFT}"
 fi
+msg_info "using nft command: ${NFT}"
+msg_info "parallel job mode: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 
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
@@ -231,6 +247,11 @@ export NFT_TEST_TMPDIR
 
 
 kernel_cleanup() {
+	if [ "$NFT_TEST_JOBS" -ne 0 ] ; then
+		# When we run jobs in parallel (even with only one "parallel"
+		# job via `NFT_TEST_JOBS=1`), we skip such global cleanups.
+		return
+	fi
 	if [ "$NFT_TEST_IS_UNSHARED" != y ] ; then
 		$NFT flush ruleset
 	fi
@@ -403,23 +424,57 @@ print_test_result() {
 	fi
 }
 
-for testfile in "${TESTS[@]}" ; do
-	kernel_cleanup
+declare -A JOBS_TEMPDIR
+declare -A JOBS_PIDLIST
 
-	# We also create and export a test-specific temporary directory.
-	NFT_TEST_TESTTMPDIR="$(mktemp -p "$NFT_TEST_TMPDIR" -d "test-${testfile//\//-}.XXXXXX")"
-	export NFT_TEST_TESTTMPDIR
+job_start() {
+	local testfile="$1"
 
-	print_test_header I "$testfile" "EXECUTING" ""
+	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
+		print_test_header I "$testfile" "EXECUTING" ""
+	fi
+
+	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
 	NFT="$NFT" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
 	rc_got=$?
-	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-	print_test_result "$NFT_TEST_TESTTMPDIR" "$testfile" "$rc_got"
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
+		rc_got="$?"
+		testfile2="${JOBS_PIDLIST[$JOBCOMPLETED]}"
+		print_test_result "${JOBS_TEMPDIR["$testfile2"]}" "$testfile2" "$rc_got"
+		((JOBS_N_RUNNING--))
+		check_kmemleak
+	done
+}
+
+JOBS_N_RUNNING=0
+for testfile in "${TESTS[@]}" ; do
+	kernel_cleanup
+
+	job_wait "$NFT_TEST_JOBS"
 
-	check_kmemleak
+	NFT_TEST_TESTTMPDIR="$(mktemp -p "$NFT_TEST_TMPDIR" -d "test-${testfile//\//-}.XXXXXX")"
+	JOBS_TEMPDIR["$testfile"]="$NFT_TEST_TESTTMPDIR"
+
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

