Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193BDCA0FFA
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351877AbjIEQ0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354485AbjIEMBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C19CC3
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Amw7iR74t21ev0W7uDVMU31zFrWW0fZ2HLXZRr3gI6w=;
        b=RfgqCaiSQVWvWMLhbCYw9XWWcqzLTocGMHna2UwxskbZCD07ysD5TOFLZTWf7e8F+9E8pK
        mzXe7EBfnECnYkGQMUiHRtAu249wJPiyj0qQw5DxM1ZUjHDGLQIsJQ5gMhSnHiTqYJHeFj
        8RtJDGwFt2puyccQ0xYy/udjjENSHcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-Xc9IOu_QM5m7nn-vni0Arw-1; Tue, 05 Sep 2023 07:59:54 -0400
X-MC-Unique: Xc9IOu_QM5m7nn-vni0Arw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01DB78001EA
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 770231121314;
        Tue,  5 Sep 2023 11:59:53 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 09/17] tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to preserve test output
Date:   Tue,  5 Sep 2023 13:58:38 +0200
Message-ID: <20230905115936.607599-10-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test output is now all collected in the temporary directory. On
success, that directory is deleted. Add an option to always preserve
that directory.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 394073024f5f..a71e5e9a9087 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -43,6 +43,7 @@ usage() {
 	echo " -K               : sets KMEMLEAK=y"
 	echo " -R|--without-realroot : sets NFT_TEST_HAS_REALROOT=n"
 	echo " -U|--no-unshare  : sets NFT_TEST_UNSHARE_CMD="
+	echo " -k|--keep-logs   : sets NFT_TEST_KEEP_LOGS=y"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>    : Path to nft executable"
@@ -69,6 +70,7 @@ usage() {
 	echo " NFT_TEST_HAS_UNSHARED=*|y : To indicate to the test whether the test run will be unshared."
 	echo "                 Test may consider this."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
+	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data"
 }
 
@@ -81,6 +83,7 @@ VERBOSE="$(bool_y "$VERBOSE")"
 DUMPGEN="$(bool_y "$DUMPGEN")"
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
+NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
 DO_LIST_TESTS=
@@ -107,6 +110,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-k|--keep-logs)
+			NFT_TEST_KEEP_LOGS=y
+			;;
 		-L|--list-tests)
 			DO_LIST_TESTS=y
 			;;
@@ -233,6 +239,7 @@ msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
+msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
 MODPROBE="$(which modprobe)"
@@ -258,8 +265,8 @@ NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
 
 ln -snf "$NFT_TEST_TMPDIR" "$NFT_TEST_LATEST"
 
-# export the tmp directory for tests. They may use it, but create
-# distinct files! It will be deleted on EXIT.
+# export the tmp directory for tests. They may use it, but create distinct
+# files! On success, it will be deleted on EXIT. See also "--keep-logs"
 export NFT_TEST_TMPDIR
 
 echo
@@ -471,4 +478,11 @@ if [ "$failed" -gt 0 -a "$NFT_TEST_HAS_REALROOT" != y ] ; then
 	msg_info "test was not running as real root"
 fi
 
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

