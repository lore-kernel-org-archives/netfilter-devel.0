Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85533EE3F3F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 22:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbjILWqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 18:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbjILWqv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 18:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E20610EB
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 15:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694558761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ik8Zmquj2hY431jQPDOmkdinFp5YSjKI3oZbrLomBx8=;
        b=Ro127omfb9LpCv0w5rhxTEZrg0WpqnyDfGySaoB2SQ7/r4ImlhdzRpjOWeNFpEJoR1vfpB
        /odtKYePIrB8wr1eFsjMEtUCQ0K+RUGpYyggusF1pErJnSQpSWgn/QT44E+7aynmYJ7YCN
        E/dxiOmWq/coCtWPgogqboql2xa25OY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-_GRepfSwNryiOs26Nvg-Yw-1; Tue, 12 Sep 2023 18:45:59 -0400
X-MC-Unique: _GRepfSwNryiOs26Nvg-Yw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35680181A6E0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 22:45:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A586840C6EA8;
        Tue, 12 Sep 2023 22:45:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: kill running child processes when aborting "run-tests.sh"
Date:   Wed, 13 Sep 2023 00:44:49 +0200
Message-ID: <20230912224501.2549359-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When aborting "run-tests.sh", child processes were left running.  Kill
them. It's surprisingly complicated to get this somewhat right. Do it by
enabling monitor mode for each test call, so that they run in separate
process groups and we can kill the entire group.

Note that we cannot just `kill -- -$$`, because it's not clear who is in
this process group. Also, we don't want to kill the `tee` process which
handles our logging.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f20a2bec9e9b..cf17302fdc19 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -424,12 +424,29 @@ if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
 
+declare -A JOBS_PIDLIST
+
 cleanup_on_exit() {
+	pids_search=''
+	for pid in "${!JOBS_PIDLIST[@]}" ; do
+		kill -- "-$pid" &>/dev/null
+		pids_search="$pids_search\\|\\<$pid\\>"
+	done
+	if [ -n "$pids_search" ] ; then
+		pids_search="${pids_search:2}"
+		for i in {1..100}; do
+			ps xh -o pgrp | grep -q "$pids_search" || break
+			sleep 0.01
+		done
+	fi
 	if [ "$NFT_TEST_KEEP_LOGS" != y -a -n "$NFT_TEST_TMPDIR" ] ; then
 		rm -rf "$NFT_TEST_TMPDIR"
 	fi
 }
-trap cleanup_on_exit EXIT
+
+trap 'exit 130' SIGINT
+trap 'exit 143' SIGTERM
+trap 'rc=$?; cleanup_on_exit; exit $rc' EXIT
 
 NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
@@ -628,7 +645,6 @@ print_test_result() {
 }
 
 declare -A JOBS_TEMPDIR
-declare -A JOBS_PIDLIST
 
 job_start() {
 	local testfile="$1"
@@ -656,7 +672,8 @@ job_wait()
 	while [ "$JOBS_N_RUNNING" -gt 0 -a "$JOBS_N_RUNNING" -ge "$num_jobs" ] ; do
 		wait -n -p JOBCOMPLETED
 		local rc_got="$?"
-		testfile2="${JOBS_PIDLIST[$JOBCOMPLETED]}"
+		local testfile2="${JOBS_PIDLIST[$JOBCOMPLETED]}"
+		unset JOBS_PIDLIST[$JOBCOMPLETED]
 		print_test_result "${JOBS_TEMPDIR["$testfile2"]}" "$testfile2" "$rc_got"
 		((JOBS_N_RUNNING--))
 		check_kmemleak
@@ -677,8 +694,12 @@ for testfile in "${TESTS[@]}" ; do
 	chmod 755 "$NFT_TEST_TESTTMPDIR"
 	JOBS_TEMPDIR["$testfile"]="$NFT_TEST_TESTTMPDIR"
 
-	job_start "$testfile" "$TESTIDX" &
-	JOBS_PIDLIST[$!]="$testfile"
+	[[ -o monitor ]] && set_old_state='set -m' || set_old_state='set +m'
+	set -m
+	( job_start "$testfile" "$TESTIDX" ) &
+	pid=$!
+	eval "$set_old_state"
+	JOBS_PIDLIST[$pid]="$testfile"
 	((JOBS_N_RUNNING++))
 done
 
-- 
2.41.0

