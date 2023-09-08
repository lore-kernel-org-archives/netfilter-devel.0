Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AAAEE8010
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbjIHO06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbjIHO06 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E2C1FC1
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 07:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694183178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BNWSKq/Evm/Kxor9ytUas6gH+0+88TyXBPIwsxaSk3k=;
        b=c5PbQfBn6KBCakIC/TJSa3mN2B1K9wBD1Z+jgA17VqM3LNlqWwek9efh11hu6sOut+4bnN
        zLMXvUvItTnNTvPT4q2Ksi1pZJ3t7GXEkb5pFrGwQFuxbIc69cOUHy8qj9e1vv3kSLYSUb
        jHC58H0ANMdyFZo65ZuDkjxoMUpMv+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-FsTRXlt8MsGH3iikNZRRBw-1; Fri, 08 Sep 2023 10:26:16 -0400
X-MC-Unique: FsTRXlt8MsGH3iikNZRRBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A66805BC3
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 14:26:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EE142026D2B;
        Fri,  8 Sep 2023 14:26:15 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: print number of completed tests to show progress
Date:   Fri,  8 Sep 2023 16:26:02 +0200
Message-ID: <20230908142605.1143992-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Especially with VALGRIND=y, a full test run can take a long time. When
looking at the output, it's interesting to get a feel how far along we
are.

Print the number of completed jobs vs. the number of total jobs, in the
line showing the test result. It gives a nice progress status.

Example:

    I: [OK]           1/373 ./tests/shell/testcases/bitwise/0040mark_binop_1
    I: [OK]           2/373 ./tests/shell/testcases/bitwise/0040mark_binop_0
    ...

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 5931b20e1645..d57108c054d1 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -511,19 +511,24 @@ fi
 print_test_header() {
 	local msglevel="$1"
 	local testfile="$2"
-	local status="$3"
-	local suffix="$4"
+	local testidx_completed="$3"
+	local status="$4"
+	local suffix="$5"
 	local text
+	local s_idx
+
+	s_idx="${#TESTS[@]}"
+	align_text text right "${#s_idx}" "$testidx_completed"
+	s_idx="$text/${#TESTS[@]}"
 
 	align_text text left 12 "[$status]"
-	_msg "$msglevel" "$text $testfile${suffix:+: $suffix}"
+	_msg "$msglevel" "$text $s_idx $testfile${suffix:+: $suffix}"
 }
 
 print_test_result() {
 	local NFT_TEST_TESTTMPDIR="$1"
 	local testfile="$2"
 	local rc_got="$3"
-	shift 3
 
 	local result_msg_level="I"
 	local result_msg_suffix=""
@@ -553,7 +558,7 @@ print_test_result() {
 		result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" )
 	fi
 
-	print_test_header "$result_msg_level" "$testfile" "$result_msg_status" "$result_msg_suffix"
+	print_test_header "$result_msg_level" "$testfile" "$((ok + skipped + failed))" "$result_msg_status" "$result_msg_suffix"
 
 	if [ "$VERBOSE" = "y" ] ; then
 		local f
@@ -575,9 +580,10 @@ declare -A JOBS_PIDLIST
 
 job_start() {
 	local testfile="$1"
+	local testidx="$2"
 
 	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
-		print_test_header I "$testfile" "EXECUTING" ""
+		print_test_header I "$testfile" "$testidx" "EXECUTING" ""
 	fi
 
 	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
@@ -619,7 +625,7 @@ for testfile in "${TESTS[@]}" ; do
 	chmod 755 "$NFT_TEST_TESTTMPDIR"
 	JOBS_TEMPDIR["$testfile"]="$NFT_TEST_TESTTMPDIR"
 
-	job_start "$testfile" &
+	job_start "$testfile" "$TESTIDX" &
 	JOBS_PIDLIST[$!]="$testfile"
 	((JOBS_N_RUNNING++))
 done
-- 
2.41.0

