Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6AAC83F3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352246AbjIEQ0j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354493AbjIEMB0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7EBCDB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IVLCwt6vJgEJHnMncfFpOO/FpHOH4pbxA9voePpa7Y=;
        b=Dfs3eh+daWSMMmoWVCyzUn3cSuAw7fLCYmKPvJ/v7OI+/29d+sQw31wv55shDWDQQ3XFrQ
        kdQSXy/SoXXPQzUE3ZiR+iRXe0SQXGCD6XlijkxfFNCWsejid+XTw+GkEm0EuLzs4PjZxp
        qaZZ8kbt14g3brBKn8zGsJLf7yp7Sb4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-A2tvquEaP_22N2KSPDDvAQ-1; Tue, 05 Sep 2023 07:59:57 -0400
X-MC-Unique: A2tvquEaP_22N2KSPDDvAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13FC7382254E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 887D61121314;
        Tue,  5 Sep 2023 11:59:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 13/17] tests/shell: support running tests in parallel
Date:   Tue,  5 Sep 2023 13:58:42 +0200
Message-ID: <20230905115936.607599-14-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
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
 tests/shell/run-tests.sh | 86 ++++++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index d9ec22f11830..d157f14eb9a5 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -59,6 +59,7 @@ usage() {
 	echo " -R|--without-realroot : sets NFT_TEST_HAS_REALROOT=n"
 	echo " -U|--no-unshare  : sets NFT_TEST_UNSHARE_CMD="
 	echo " -k|--keep-logs   : sets NFT_TEST_KEEP_LOGS=y"
+	echo " -j|--jobs        : sets NFT_TEST_JOBS=12"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>    : Path to nft executable"
@@ -88,6 +89,11 @@ usage() {
 	echo "                 Test may consider this."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
 	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
+	echo " NFT_TEST_JOBS=<NUM}>: by default, run test sequentially. Set to an integer > 1 to"
+	echo "                 run jobs in parallel. Leaving this unset or at zero means to run jobs sequentially"
+	echo "                 and perform global cleanups between tests (remove kernel modules). Setting this"
+	echo "                 to a positive number (including \"1\") means to disable such global cleanups."
+	echo "                 Parallel jobs requires unshare and does not work with NFT_TEST_NO_UNSHARE=."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data"
 }
 
@@ -103,6 +109,7 @@ KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
+NFT_TEST_JOBS="$NFT_TEST_JOBS"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -139,6 +146,9 @@ while [ $# -gt 0 ] ; do
 		-U|--no-unshare)
 			NFT_TEST_NO_UNSHARE=y
 			;;
+		-j|--jobs)
+			NFT_TEST_JOBS=12
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -242,6 +252,14 @@ fi
 # If tests wish, they can know whether they are unshared via this variable.
 export NFT_TEST_HAS_UNSHARED
 
+# normalize the jobs number to be an integer.
+case "$NFT_TEST_JOBS" in
+	''|*[!0-9]*) NFT_TEST_JOBS=0 ;;
+esac
+if [ -z "$NFT_TEST_UNSHARE_CMD" -a "$NFT_TEST_JOBS" -gt 1 ] ; then
+	NFT_TEST_JOBS=1
+fi
+
 [ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -257,11 +275,14 @@ msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
+msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
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
@@ -463,28 +489,62 @@ print_test_result() {
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
+	NFT="$NFT" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
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
-	NFT="$NFT" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
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

