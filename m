Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C84C46CA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 18:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjIRSrk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 14:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjIRSrk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 14:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B2EF7
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 11:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695062810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5yPfvIMclwaptt7DemfFX/A37hTww7jV2RtBQ/SSWc=;
        b=TAxxP2ZQ6yvUZnx966Gq6KWvHyFGZDgYMZF3FdTAOypVDmbFjtWS0p21gSNJ66nTcBoW8B
        q4CjV7GSVielWkUhFfY5zQbH/IXhY9/x65HV/oVO7lUYTh7wDkRGFmnutl73YtaTsSZJYZ
        jBs1dtlXTvkmZ+qA4jAU0LNRgQXFSQg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-RYelH5fhM9-b-Z9iIyR6Tg-1; Mon, 18 Sep 2023 14:46:49 -0400
X-MC-Unique: RYelH5fhM9-b-Z9iIyR6Tg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9295D3C14AAE
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 18:46:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10D7E492B16;
        Mon, 18 Sep 2023 18:46:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: don't show the exit status for failed tests
Date:   Mon, 18 Sep 2023 20:45:20 +0200
Message-ID: <20230918184634.3471832-3-thaller@redhat.com>
In-Reply-To: <20230918184634.3471832-1-thaller@redhat.com>
References: <20230918184634.3471832-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, for failed tests we would print the exit code

  W: [FAILED]     2/2 tests/shell/testcases/listing/0013objects_0: got 1

This doesn't seem very useful. For one, we have special exit codes like
0 (OK), 77 (SKIPPED), 124 (DUMP FAIL), 123 (TAINTED), 122 (VALGRIND).
Any other exit code is just an arbitrary failure. We don't define any
special codes, and printing them is not useful.

Note that further exit codes (118 - 121) are reserved, and could be
special purposed, when there is a use.

You can find the real exit code from the test in the result data in the
"rc-failed" file.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 79c818cb0f11..418fab95da94 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -704,7 +704,6 @@ print_test_header() {
 	local testfile="$2"
 	local testidx_completed="$3"
 	local status="$4"
-	local suffix="$5"
 	local text
 	local s_idx
 
@@ -713,7 +712,7 @@ print_test_header() {
 	s_idx="$text/${#TESTS[@]}"
 
 	align_text text left 12 "[$status]"
-	_msg "$msglevel" "$text $s_idx $testfile${suffix:+: $suffix}"
+	_msg "$msglevel" "$text $s_idx $testfile"
 }
 
 print_test_result() {
@@ -722,7 +721,6 @@ print_test_result() {
 	local rc_got="$3"
 
 	local result_msg_level="I"
-	local result_msg_suffix=""
 	local result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" "$NFT_TEST_TESTTMPDIR/ruleset-diff" )
 	local result_msg_status
 
@@ -743,13 +741,12 @@ print_test_result() {
 			result_msg_status="DUMP FAIL"
 		else
 			result_msg_status="FAILED"
-			result_msg_suffix="got $rc_got"
 		fi
 		result_msg_status="$RED$result_msg_status$RESET"
 		result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" )
 	fi
 
-	print_test_header "$result_msg_level" "$testfile" "$((ok + skipped + failed))" "$result_msg_status" "$result_msg_suffix"
+	print_test_header "$result_msg_level" "$testfile" "$((ok + skipped + failed))" "$result_msg_status"
 
 	if [ "$VERBOSE" = "y" ] ; then
 		local f
@@ -773,7 +770,7 @@ job_start() {
 	local testidx="$2"
 
 	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
-		print_test_header I "$testfile" "$testidx" "EXECUTING" ""
+		print_test_header I "$testfile" "$testidx" "EXECUTING"
 	fi
 
 	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
-- 
2.41.0

