Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6589CA5508
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 08:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjIMIXY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbjIMIXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 04:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BC2DE73
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 01:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694593353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uN9sAaZWWLMb4AjDmgFm2EpnswfMKD6LOCo4eiYfFGg=;
        b=MESAG8qYhe8AqJEe8X71BpVDsX6kgcv50rear1PjDBlE0mz1ph1/zDJRS507FUnab4ZJiA
        Ui35wMACwaVQOMBpYhLBpdgQJZTuV7inXpG36XNgxCG39tJBg+M+ptcFfghf9/g4gWWxYI
        XtcJNvn0kqdfJG+hPmiYZrCLVaPH6t8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-R8O7fjnlMfWTUcfRVH4RBw-1; Wed, 13 Sep 2023 04:22:32 -0400
X-MC-Unique: R8O7fjnlMfWTUcfRVH4RBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C118B829DF8
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 08:22:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F727728FD;
        Wed, 13 Sep 2023 08:22:31 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] tests/shell: add option to shuffle execution order of tests
Date:   Wed, 13 Sep 2023 10:20:25 +0200
Message-ID: <20230913082217.2711665-4-thaller@redhat.com>
In-Reply-To: <20230913082217.2711665-1-thaller@redhat.com>
References: <20230913082217.2711665-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The user can set NFT_TEST_SHUFFLE_TESTS=y|n to have the tests shuffled
randomly. The purpose of shuffling is to find tests that depend on each
other, or would break when run in unexpected order.

If unspecified, by default tests are shuffled if no tests are selected
on the command line.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 2acea85e7836..a66f32abfc5a 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -143,6 +143,7 @@ usage() {
 	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " -k|--keep-logs  : Sets NFT_TEST_KEEP_LOGS=y."
 	echo " -s|--sequential : Sets NFT_TEST_JOBS=0, which also enables global cleanups."
+	echo "                   Also sets NFT_TEST_SHUFFLE_TESTS=n if left unspecified."
 	echo " -Q|--quick      : Sets NFT_TEST_SKIP_slow=y."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
@@ -198,6 +199,9 @@ usage() {
 	echo " NFT_TEST_RANDOM_SEED=<SEED>: The test runner will export the environment variable NFT_TEST_RANDOM_SEED"
 	echo "                 set to a random number. This can be used as a stable seed for tests to randomize behavior."
 	echo "                 Set this to a fixed value to get reproducible behavior."
+	echo " NFT_TEST_SHUFFLE_TESTS=*|n|y: control whether to randomly shuffle the order of tests. By default, if"
+	echo "                 tests are specified explicitly, they are not shuffled while they are shuffled when"
+	echo "                 all tests are run. The shuffling is based on NFT_TEST_RANDOM_SEED."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data."
 	echo
 	echo " NFT_TEST_HAVE_<FEATURE>=*|y: Some tests requires certain features or will be skipped."
@@ -238,6 +242,7 @@ NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_JOBS="${NFT_TEST_JOBS:-$_NFT_TEST_JOBS_DEFAULT}"
 NFT_TEST_RANDOM_SEED="$NFT_TEST_RANDOM_SEED"
+NFT_TEST_SHUFFLE_TESTS="$NFT_TEST_SHUFFLE_TESTS"
 NFT_TEST_SKIP_slow="$(bool_y "$NFT_TEST_SKIP_slow")"
 DO_LIST_TESTS=
 
@@ -293,6 +298,9 @@ while [ $# -gt 0 ] ; do
 			;;
 		-s|--sequential)
 			NFT_TEST_JOBS=0
+			if [ -z "$NFT_TEST_SHUFFLE_TESTS" ] ; then
+				NFT_TEST_SHUFFLE_TESTS=n
+			fi
 			;;
 		-Q|--quick)
 			NFT_TEST_SKIP_slow=y
@@ -314,6 +322,9 @@ find_tests() {
 if [ "${#TESTS[@]}" -eq 0 ] ; then
 	TESTS=( $(find_tests "$NFT_TEST_BASEDIR/testcases/") )
 	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
+	if [ -z "$NFT_TEST_SHUFFLE_TESTS" ] ; then
+		NFT_TEST_SHUFFLE_TESTS=y
+	fi
 fi
 
 TESTSOLD=( "${TESTS[@]}" )
@@ -328,6 +339,8 @@ for t in "${TESTSOLD[@]}" ; do
 	fi
 done
 
+NFT_TEST_SHUFFLE_TESTS="$(bool_y "$NFT_TEST_SHUFFLE_TESTS")"
+
 if [ "$DO_LIST_TESTS" = y ] ; then
 	printf '%s\n' "${TESTS[@]}"
 	exit 0
@@ -496,6 +509,7 @@ msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARE
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: NFT_TEST_RANDOM_SEED=$NFT_TEST_RANDOM_SEED"
+msg_info "conf: NFT_TEST_SHUFFLE_TESTS=$NFT_TEST_SHUFFLE_TESTS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 echo
 for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
@@ -709,6 +723,10 @@ job_wait()
 	done
 }
 
+if [ "$NFT_TEST_SHUFFLE_TESTS" = y ] ; then
+	TESTS=( $(printf '%s\n' "${TESTS[@]}" | shuf --random-source=<("$NFT_TEST_BASEDIR/helpers/random-source.sh" "nft-test-shuffle-tests" "$NFT_TEST_RANDOM_SEED") ) )
+fi
+
 TESTIDX=0
 JOBS_N_RUNNING=0
 for testfile in "${TESTS[@]}" ; do
-- 
2.41.0

