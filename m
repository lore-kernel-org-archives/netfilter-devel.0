Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74436C83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbjIDNxY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbjIDNxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0382CE5
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRp+9geDN7Gd6Q0zMTSUf0dW/Xt1QaWQfF4/fhcgCLg=;
        b=dcmh4+8e7m1hSWWsUrMhvqvHwFxeUS0mlgdunwiDk2uFm+ipPW0VTSSjcwWemFIXK+Sror
        RZ+bgkNr1ex4dzLFflpID3BqOxVGaRmNDJOPgWJrUGw4TF2VEo3D8jPym7rXe2c0VNnBEZ
        l5xW2hwy5E+K5Pu4581l45LHJRyANQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-NG_W9QtaNHy16dEh61ozrQ-1; Mon, 04 Sep 2023 09:51:52 -0400
X-MC-Unique: NG_W9QtaNHy16dEh61ozrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF23A939EC2
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EFAE1121314;
        Mon,  4 Sep 2023 13:51:51 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 07/11] tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to preserve test output
Date:   Mon,  4 Sep 2023 15:48:09 +0200
Message-ID: <20230904135135.1568180-8-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
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
index f3b58e1e200b..8da0cc3d5702 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -25,6 +25,7 @@ usage() {
 	echo " -K               : sets KMEMLEAK=y"
 	echo " -R|--without-realroot : sets NFT_TEST_HAVE_REALROOT=n"
 	echo " -U|--no-unshare  : sets NFT_TEST_NO_UNSHARE=y"
+	echo " -k|--keep-logs   : sets NFT_TEST_KEEP_LOGS=y"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>   : Path to nft executable"
@@ -50,6 +51,7 @@ usage() {
 	echo "                will not try to unshare. Instead, it uses this command to unshare."
 	echo "                Set to empty to not unshare. You may want to export NFT_TEST_IS_UNSHARED="
 	echo "                and NFT_TEST_HAVE_REALROOT= accordingly."
+	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
 }
 
 NFT_TEST_BASEDIR="$(dirname "$0")"
@@ -61,6 +63,7 @@ VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+NFT_TEST_KEEP_LOGS="$NFT_TEST_KEEP_LOGS"
 NFT_TEST_HAVE_REALROOT="$NFT_TEST_HAVE_REALROOT"
 NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
 DO_LIST_TESTS=
@@ -87,6 +90,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-k|--keep-logs)
+			NFT_TEST_KEEP_LOGS=y
+			;;
 		-L|--list-tests)
 			DO_LIST_TESTS=y
 			;;
@@ -202,8 +208,8 @@ chmod 755 "$NFT_TEST_TMPDIR"
 
 ln -snf "$NFT_TEST_TMPDIR" "$_TMPDIR/nft-test.latest"
 
-# export the tmp directory for tests. They may use it, but create
-# distinct files! It will be deleted on EXIT.
+# export the tmp directory for tests. They may use it, but create distinct
+# files! On success, it will be deleted on EXIT. See also "--keep-logs"
 export NFT_TEST_TMPDIR
 
 
@@ -407,4 +413,12 @@ if [ "$failed" -gt 0 -a "$NFT_TEST_HAVE_REALROOT" != y ] ; then
 	msg_info "test was not running as real root"
 fi
 
+if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
+	ln -snf "$NFT_TEST_TMPDIR" "$_TMPDIR/nftables-test.latest"
+	msg_info "check the temp directory \"$NFT_TEST_TMPDIR\" (\"$_TMPDIR/nftables-test.latest\")"
+	msg_info "   ls -lad /tmp/nftables-test.latest/*/*"
+	msg_info "   grep -R ^ /tmp/nftables-test.latest/"
+	NFT_TEST_TMPDIR=
+fi
+
 [ "$failed" -eq 0 ]
-- 
2.41.0

