Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0183BEB8FAF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbjIFMC4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7303E1717
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8Eqzv9sCArFOcMO5aaXZQDVTMWRsqHsRUseiMFxWC8=;
        b=Dj9Hw296OiPeHHXSxY/Be0L+vqDG7DCRdnXczRSGEiIjtYmU0DAT75cfdalESxYUzdOOvc
        9E06RUdhBM0BM24ugbiRQ7QM9zoaHsIK4oQ4rd9CD66MDbdMocC5wihKo+NGGLRo8n7gVx
        mtOaNnuXE4bc8/4dI/HIeIFwcsde+Ss=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584--iTnEYTtM_K6COpsCnRmAQ-1; Wed, 06 Sep 2023 08:01:28 -0400
X-MC-Unique: -iTnEYTtM_K6COpsCnRmAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B5A9182BEA1
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 900F7C15BB8;
        Wed,  6 Sep 2023 12:01:26 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 09/19] tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to preserve test output
Date:   Wed,  6 Sep 2023 13:52:12 +0200
Message-ID: <20230906120109.1773860-10-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test output is now all collected in the temporary directory. On
success, that directory is deleted. Add an option to always preserve
that directory.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index fec9e7743226..efc4f127b797 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -36,6 +36,7 @@ usage() {
 	echo " -K              : Sets KMEMLEAK=y."
 	echo " -R|--without-realroot : Sets NFT_TEST_HAS_REALROOT=n."
 	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
+	echo " -k|--keep-logs  : Sets NFT_TEST_KEEP_LOGS=y."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
 	echo "                   that is, executables that are run by the runner."
@@ -68,6 +69,7 @@ usage() {
 	echo " NFT_TEST_HAS_UNSHARED=*|y : To indicate to the test whether the test run will be unshared."
 	echo "                 Test may consider this."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
+	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data."
 }
 
@@ -80,6 +82,7 @@ VERBOSE="$(bool_y "$VERBOSE")"
 DUMPGEN="$(bool_y "$DUMPGEN")"
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
+NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 DO_LIST_TESTS=
 
@@ -105,6 +108,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-k|--keep-logs)
+			NFT_TEST_KEEP_LOGS=y
+			;;
 		-L|--list-tests)
 			DO_LIST_TESTS=y
 			;;
@@ -229,7 +235,9 @@ if [ ! -x "$DIFF" ] ; then
 fi
 
 cleanup_on_exit() {
-	test -z "$NFT_TEST_TMPDIR" || rm -rf "$NFT_TEST_TMPDIR"
+	if [ "$NFT_TEST_KEEP_LOGS" != y -a -n "$NFT_TEST_TMPDIR" ] ; then
+		rm -rf "$NFT_TEST_TMPDIR"
+	fi
 }
 trap cleanup_on_exit EXIT
 
@@ -245,14 +253,15 @@ msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
+msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
 NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
 
 ln -snf "$NFT_TEST_TMPDIR" "$NFT_TEST_LATEST"
 
-# export the tmp directory for tests. They may use it, but create
-# distinct files! It will be deleted on EXIT.
+# export the tmp directory for tests. They may use it, but create distinct
+# files! On success, it will be deleted on EXIT. See also "--keep-logs"
 export NFT_TEST_TMPDIR
 
 echo
@@ -460,4 +469,11 @@ msg_info "results: [OK] $ok [SKIPPED] $skipped [FAILED] $failed [TOTAL] $((ok+sk
 
 kernel_cleanup
 
+if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
+	msg_info "check the temp directory \"$NFT_TEST_TMPDIR\" (\"$NFT_TEST_LATEST\")"
+	msg_info "   ls -lad \"$NFT_TEST_LATEST\"/*/*"
+	msg_info "   grep -R ^ \"$NFT_TEST_LATEST\"/"
+	NFT_TEST_TMPDIR=
+fi
+
 [ "$failed" -eq 0 ]
-- 
2.41.0

