Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95032EB8FB7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjIFMCO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIFMCO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F94E1A7
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihiY0TO5+xJlCkAqisspy1I565VMauZgnhbp3m99B/I=;
        b=RZQq50663w3RqCNHJp8NR48pOBdt0v5dIV9bJLY2/c449YCSnD4m89/f4bxBdk2Jitq1bG
        CUZsugkAmxvu55pPFtR8BmkN5o96I2/xkSIaxPSCyHB5/7vQfbTNJ7EH18Fv0CfpOe0PxM
        Mt3flGbgcdqvx2fd/amYS167wHrdZyo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-aM3BNmgEN3yy3CVaE-15Cg-1; Wed, 06 Sep 2023 08:01:23 -0400
X-MC-Unique: aM3BNmgEN3yy3CVaE-15Cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FB34182BEA2
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 939C7C15BB8;
        Wed,  6 Sep 2023 12:01:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 04/19] tests/shell: export NFT_TEST_BASEDIR and NFT_TEST_TMPDIR for tests
Date:   Wed,  6 Sep 2023 13:52:07 +0200
Message-ID: <20230906120109.1773860-5-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 tests/shell/run-tests.sh | 63 +++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 34c3b324b04b..65aa041febb2 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -28,20 +28,21 @@ usage() {
 	echo "                   that is, executables that are run by the runner."
 	echo
 	echo "ENVIRONMENT VARIABLES:"
-	echo " NFT=<CMD>    : Path to nft executable. Will be called as \`\$NFT [...]\` so"
-	echo "                it can be a command with parameters. Note that in this mode quoting"
-	echo "                does not work, so the usage is limited and the command cannot contain"
-	echo "                spaces."
-	echo " VERBOSE=*|y  : Enable verbose output."
-	echo " DUMPGEN=*|y  : Regenerate dump files."
-	echo " VALGRIND=*|y : Run \$NFT in valgrind."
-	echo " KMEMLEAK=*|y : Check for kernel memleaks."
+	echo " NFT=<CMD>     : Path to nft executable. Will be called as \`\$NFT [...]\` so"
+	echo "                 it can be a command with parameters. Note that in this mode quoting"
+	echo "                 does not work, so the usage is limited and the command cannot contain"
+	echo "                 spaces."
+	echo " VERBOSE=*|y   : Enable verbose output."
+	echo " DUMPGEN=*|y   : Regenerate dump files."
+	echo " VALGRIND=*|y  : Run \$NFT in valgrind."
+	echo " KMEMLEAK=*|y  : Check for kernel memleaks."
+	echo " TMPDIR=<PATH> : select a different base directory for the result data."
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
@@ -105,7 +106,7 @@ find_tests() {
 }
 
 if [ "${#TESTS[@]}" -eq 0 ] ; then
-	TESTS=( $(find_tests "$BASEDIR/testcases/") )
+	TESTS=( $(find_tests "$NFT_TEST_BASEDIR/testcases/") )
 	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
 fi
 
@@ -126,7 +127,7 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
-[ -z "$NFT" ] && NFT=$SRC_NFT
+[ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
 if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
@@ -145,6 +146,26 @@ if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
 
+cleanup_on_exit() {
+	test -z "$NFT_TEST_TMPDIR" || rm -rf "$NFT_TEST_TMPDIR"
+}
+trap cleanup_on_exit EXIT
+
+_TMPDIR="${TMPDIR:-/tmp}"
+
+NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
+	msg_error "Failure to create temp directory in \"$_TMPDIR\""
+chmod 755 "$NFT_TEST_TMPDIR"
+
+NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
+
+ln -snf "$NFT_TEST_TMPDIR" "$NFT_TEST_LATEST"
+
+# export the tmp directory for tests. They may use it, but create
+# distinct files! It will be deleted on EXIT.
+export NFT_TEST_TMPDIR
+
+
 kernel_cleanup() {
 	$NFT flush ruleset
 	$MODPROBE -raq \
@@ -199,16 +220,10 @@ EOF
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

