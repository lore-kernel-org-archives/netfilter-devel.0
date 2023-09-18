Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B60CD37B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 20:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjIRU2P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 16:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjIRU2O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 16:28:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1953E10A
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 13:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695068845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c/YP1P/Izmc2cQU2udtUv1+3d8kNLXsp1uGRmHUSVUI=;
        b=RpowvLXEn/zE6bn1oM0G/+zcBInCEj1hBjwWcpaHMwh4DYOKIJdWbWYExWA61JQSUgOuxY
        3ZSBP/eriEPBGWFliHhDOjTm6DGFzrLyVe0ejdwJrM2+u7dnT+C03xUjW0MB3T+goeiQvu
        gUC13GOn8sDS7KhR/jeHiha1yoalJMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-Dwy9h5x2NGyDOY8YUPi_wQ-1; Mon, 18 Sep 2023 16:27:21 -0400
X-MC-Unique: Dwy9h5x2NGyDOY8YUPi_wQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9D39800883
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 20:27:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2813210EE402;
        Mon, 18 Sep 2023 20:27:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: honor NFT_TEST_FAIL_ON_SKIP variable to fail on any skipped tests
Date:   Mon, 18 Sep 2023 22:27:07 +0200
Message-ID: <20230918202709.470288-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test suite should pass with various kernels and build
configurations. Of course, that means, that some tests will be
gracefully skipped, and we don't treat that as an overall failure.

However, it should be possible to run a specific kernel (net-next?) and
build configuration, where we expect that all tests pass.

Add an option to fail the run, if any tests were skipped. This is to
ensure that we don't have broken tests that never pass.

This will make more sense with automated CI is running, to enable on a
test system and ensure that at least on that system, all tests pass.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 528646f57eca..d60237cdc7d9 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -201,6 +201,7 @@ usage() {
 	echo "                 Setting this to \"0\" means also to perform global cleanups between tests (remove"
 	echo "                 kernel modules)."
 	echo "                 Parallel jobs requires unshare and are disabled with NFT_TEST_UNSHARE_CMD=\"\"."
+	echo " NFT_TEST_FAIL_ON_SKIP=*|y: if any jobs are skipped, exit with error."
 	echo " NFT_TEST_RANDOM_SEED=<SEED>: The test runner will export the environment variable NFT_TEST_RANDOM_SEED"
 	echo "                 set to a random number. This can be used as a stable seed for tests to randomize behavior."
 	echo "                 Set this to a fixed value to get reproducible behavior."
@@ -261,6 +262,7 @@ KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_JOBS="${NFT_TEST_JOBS:-$_NFT_TEST_JOBS_DEFAULT}"
+NFT_TEST_FAIL_ON_SKIP="$(bool_y "$NFT_TEST_FAIL_ON_SKIP")"
 NFT_TEST_RANDOM_SEED="$NFT_TEST_RANDOM_SEED"
 NFT_TEST_SHUFFLE_TESTS="$NFT_TEST_SHUFFLE_TESTS"
 NFT_TEST_SKIP_slow="$(bool_y "$NFT_TEST_SKIP_slow")"
@@ -573,6 +575,7 @@ msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
+msg_info "conf: NFT_TEST_FAIL_ON_SKIP=$NFT_TEST_FAIL_ON_SKIP"
 msg_info "conf: NFT_TEST_RANDOM_SEED=$NFT_TEST_RANDOM_SEED"
 msg_info "conf: NFT_TEST_SHUFFLE_TESTS=$NFT_TEST_SHUFFLE_TESTS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
@@ -837,7 +840,7 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-if [ "$failed" -gt 0 ] ; then
+if [ "$failed" -gt 0 ] || [ "$NFT_TEST_FAIL_ON_SKIP" = y -a "$skipped" -gt 0 ] ; then
 	RR="$RED"
 elif [ "$skipped" -gt 0 ] ; then
 	RR="$YELLOW"
@@ -871,6 +874,9 @@ fi
 
 if [ "$failed" -gt 0 ] ; then
 	exit 1
+elif [ "$NFT_TEST_FAIL_ON_SKIP" = y -a "$skipped" -gt 0 ] ; then
+	msg_info "some tests were skipped. Fail due to NFT_TEST_FAIL_ON_SKIP=y"
+	exit 1
 elif [ "$ok" -eq 0 -a "$skipped" -gt 0 ] ; then
 	exit 77
 else
-- 
2.41.0

