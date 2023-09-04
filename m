Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C6AC71153
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjIDNwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjIDNwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98966CDE
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4VA5K+sjWux1TfpCHpYkqMRAjfeHnEzoVXnDyLJvMn4=;
        b=idRgbYK1PRwt2ui5Ae0HsgbSMaFS6uqBOPoQluwnlNuKsqwr8dt0rotSe7QUC7fk5NKUvO
        6Ja03wwCzJp0lbdfarI5p2Xwh+/VBXFGQsLqm0gbkEN4wwPn55X+MZrwAgpui+uoKU5jfJ
        md2UY2vgvpF85efOFvTAqcdwrTV5HMs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-7_NUwGSNNfeoCjJg7tXxkw-1; Mon, 04 Sep 2023 09:51:49 -0400
X-MC-Unique: 7_NUwGSNNfeoCjJg7tXxkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44A0729DD985
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8ECB1121314;
        Mon,  4 Sep 2023 13:51:48 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 04/11] tests/shell: export NFT_TEST_BASEDIR and NFT_TEST_TMPDIR for tests
Date:   Mon,  4 Sep 2023 15:48:06 +0200
Message-ID: <20230904135135.1568180-5-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let the test wrapper prepare and export two environment variables for
the test:

- "$NFT_TEST_BASEDIR" is just the top directory where the test scripts
  lie.

- "$NFT_TEST_TMPDIR" is a `mktemp` directory created by "run-tests.sh"
  and removed at the end. Tests may use that to leave data there.
  This directory will be used for various things, like the "nft" wrapper
  in valgrind mode, the results of the tests and possibly as cache for
  feature detection.

The "$NFT_TEST_TMPDIR" was already used before with the "VALGRIND=y"
mode. It's only renamed and got an extended purpose.

Also drop the unnecessary first detection of "$DIFF" and the "$SRC_NFT"
variable.

Also, note that the mktemp creates the temporary directory under /tmp.
Which is commonly a tempfs. The user can override that by exporting
TMPDIR.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 43 +++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 0a2598f10bed..22a34f1f7898 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -32,10 +32,10 @@ usage() {
 	echo " KMEMLEAK=*|y : Check for kernel memleaks"
 }
 
-# Configuration
-BASEDIR="$(dirname "$0")"
-SRC_NFT="$BASEDIR/../../src/nft"
-DIFF=$(which diff)
+NFT_TEST_BASEDIR="$(dirname "$0")"
+
+# Export the base directory. It may be used by tests.
+export NFT_TEST_BASEDIR
 
 if [ "$(id -u)" != "0" ] ; then
 	msg_error "this requires root!"
@@ -99,7 +99,7 @@ find_tests() {
 }
 
 if [ "${#TESTS[@]}" -eq 0 ] ; then
-	TESTS=( $(find_tests "$BASEDIR/testcases/") )
+	TESTS=( $(find_tests "$NFT_TEST_BASEDIR/testcases/") )
 	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
 fi
 
@@ -120,7 +120,7 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
-[ -z "$NFT" ] && NFT=$SRC_NFT
+[ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
 if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
@@ -139,6 +139,23 @@ if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
 
+cleanup_on_exit() {
+	test -z "$NFT_TEST_TMPDIR" || rm -rf "$NFT_TEST_TMPDIR"
+}
+trap cleanup_on_exit EXIT
+
+_TMPDIR="${TMPDIR:-/tmp}"
+
+NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")"
+chmod 755 "$NFT_TEST_TMPDIR"
+
+ln -snf "$NFT_TEST_TMPDIR" "$_TMPDIR/nft-test.latest"
+
+# export the tmp directory for tests. They may use it, but create
+# distinct files! It will be deleted on EXIT.
+export NFT_TEST_TMPDIR
+
+
 kernel_cleanup() {
 	$NFT flush ruleset
 	$MODPROBE -raq \
@@ -193,16 +210,10 @@ EOF
 }
 
 if [ "$VALGRIND" == "y" ]; then
-	tmpd=$(mktemp -d)
-	chmod 755 $tmpd
-
-	msg_info "writing valgrind logs to $tmpd"
-
-	printscript "$NFT" "$tmpd" >${tmpd}/nft
-	trap "rm ${tmpd}/nft" EXIT
-	chmod a+x ${tmpd}/nft
-
-	NFT="${tmpd}/nft"
+	msg_info "writing valgrind logs to $NFT_TEST_TMPDIR"
+	printscript "$NFT" "$NFT_TEST_TMPDIR" > "$NFT_TEST_TMPDIR/nft"
+	chmod a+x "$NFT_TEST_TMPDIR/nft"
+	NFT="$NFT_TEST_TMPDIR/nft"
 fi
 
 echo ""
-- 
2.41.0

