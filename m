Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEED2CDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjJPNbb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjJPNbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:31:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DA611A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697463033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6E1Ml2gp4fJRfK3ZW84DDiT75Y+VKGYK8R9gw54IWU=;
        b=hUyuxrqiSM+GKSpIMoDyhr4rI9BuCvisDbAaB1be7/CGTaMyi8ufXkeQz2a+fdn81KJLSv
        Kzwv5Wf5jHzWZxMPviSQ2aXJu5mWnNVVy7pTxDJYr1Pw9Fq5t7/+537xG1IDiKyPnxK6M3
        J1gpXwPlRqNZBIBo/+38WkABEf7gWYY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-tHgqxa8IPOGzWzetSeGOfQ-1; Mon, 16 Oct 2023 09:30:32 -0400
X-MC-Unique: tHgqxa8IPOGzWzetSeGOfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1037B81DB81
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 13:30:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3788AC15BB8;
        Mon, 16 Oct 2023 13:30:31 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: honor NFT_TEST_VERBOSE_TEST variable to debug tests via `bash -x`
Date:   Mon, 16 Oct 2023 15:30:11 +0200
Message-ID: <20231016133019.1134188-2-thaller@redhat.com>
In-Reply-To: <20231016133019.1134188-1-thaller@redhat.com>
References: <20231016133019.1134188-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It can be cumbersome to debug why a test fails. Our tests are just shell
scripts, which for the most part don't print much. That is good, but for
debugging, it can be useful to run the test via `bash -x`. Previously,
we would just patch the source file while debugging.

Add an option "-x" and NFT_TEST_VERBOSE_TEST=y environment variable. If set,
"test-wrapper.sh" will check whether the shebang is "#!/bin/bash" and add
"-x" to the command line.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh |  9 ++++++++-
 tests/shell/run-tests.sh            | 15 ++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 13b918f8b8e1..832bd89a19bc 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -93,7 +93,14 @@ if [ "$rc_test" -eq 0 ] ; then
 fi
 
 if [ "$rc_test" -eq 0 ] ; then
-	"$TEST" &>> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
+	CMD=( "$TEST" )
+	if [ "$NFT_TEST_VERBOSE_TEST" = y ] ; then
+		X="$(sed -n '1 s/^#!\(\/bin\/bash\>.*$\)/\1/p' "$TEST" 2>/dev/null)"
+		if [ -n "$X" ] ; then
+			CMD=( $X -x "$TEST" )
+		fi
+	fi
+	"${CMD[@]}" &>> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 fi
 
 $NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 22105c2e90e2..27a0ec43042a 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -163,6 +163,7 @@ usage() {
 	echo " -R|--without-realroot : Sets NFT_TEST_HAS_REALROOT=n."
 	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " -k|--keep-logs  : Sets NFT_TEST_KEEP_LOGS=y."
+	echo " -x              : Sets NFT_TEST_VERBOSE_TEST=y."
 	echo " -s|--sequential : Sets NFT_TEST_JOBS=0, which also enables global cleanups."
 	echo "                   Also sets NFT_TEST_SHUFFLE_TESTS=n if left unspecified."
 	echo " -Q|--quick      : Sets NFT_TEST_SKIP_slow=y."
@@ -181,6 +182,8 @@ usage() {
 	echo " NFT_REAL=<CMD> : Real nft comand. Usually this is just the same as \$NFT,"
 	echo "                 however, you may set NFT='valgrind nft' and NFT_REAL to the real command."
 	echo " VERBOSE=*|y   : Enable verbose output."
+	echo " NFT_TEST_VERBOSE_TEST=*|y: if true, enable verbose output for tests. For bash scripts, this means"
+	echo "                 to pass \"-x\" to the interpreter."
 	echo " DUMPGEN=*|y   : Regenerate dump files. Dump files are only recreated if the"
 	echo "                 test completes successfully and the \"dumps\" directory for the"
 	echo "                 test exits."
@@ -275,6 +278,7 @@ _NFT_TEST_JOBS_DEFAULT="$(nproc)"
 _NFT_TEST_JOBS_DEFAULT="$(( _NFT_TEST_JOBS_DEFAULT + (_NFT_TEST_JOBS_DEFAULT + 1) / 2 ))"
 
 VERBOSE="$(bool_y "$VERBOSE")"
+NFT_TEST_VERBOSE_TEST="$(bool_y "$NFT_TEST_VERBOSE_TEST")"
 DUMPGEN="$(bool_y "$DUMPGEN")"
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
@@ -327,6 +331,9 @@ while [ $# -gt 0 ] ; do
 		-v)
 			VERBOSE=y
 			;;
+		-x)
+			NFT_TEST_VERBOSE_TEST=y
+			;;
 		-g)
 			DUMPGEN=y
 			;;
@@ -627,6 +634,7 @@ exec &> >(tee "$NFT_TEST_TMPDIR/test.log")
 msg_info "conf: NFT=$(printf '%q' "$NFT")"
 msg_info "conf: NFT_REAL=$(printf '%q' "$NFT_REAL")"
 msg_info "conf: VERBOSE=$(printf '%q' "$VERBOSE")"
+msg_info "conf: NFT_TEST_VERBOSE_TEST=$(printf '%q' "$NFT_TEST_VERBOSE_TEST")"
 msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
 msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
@@ -832,7 +840,12 @@ job_start() {
 	fi
 
 	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
-	NFT="$NFT" NFT_REAL="$NFT_REAL" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
+	NFT="$NFT" \
+	NFT_REAL="$NFT_REAL" \
+	DIFF="$DIFF" \
+	DUMPGEN="$DUMPGEN" \
+	NFT_TEST_VERBOSE_TEST="$NFT_TEST_VERBOSE_TEST" \
+	$NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
 	local rc_got=$?
 
 	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
-- 
2.41.0

