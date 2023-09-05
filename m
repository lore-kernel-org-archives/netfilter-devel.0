Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C433AC83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352423AbjIEQ1Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354482AbjIEMAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1B41B3
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbrQ3xK4+NxjhGJJdlN5TZjbMVId3IEsUYuyXJX1/b8=;
        b=exnO0C2Wg6mDMGf1EeChDbxJ3oi4o2HWE1yi67XdXTPRPLZPgNiI4L9rRSlgbQxIYqHRX7
        9Id9errerOIrK0NJaU89KJHWhVbwCzxXU5wK4qqKgWWFhg8wxGalzn2s410bQJl5jI6gd6
        Z1u0yECBBZ2yYMxNA9ZklDBCZWlvH7c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-AIB9AyxrPSGb4ocBsuwZcA-1; Tue, 05 Sep 2023 07:59:48 -0400
X-MC-Unique: AIB9AyxrPSGb4ocBsuwZcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AA2E8001EA
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF10D1121314;
        Tue,  5 Sep 2023 11:59:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 02/17] tests/shell: rework finding tests and add "--list-tests" option
Date:   Tue,  5 Sep 2023 13:58:31 +0200
Message-ID: <20230905115936.607599-3-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cleanup finding the test files. Also add a "--list-tests" option to see
which tests are found and would run.

Also get rid of the FIND="$(which find)" detection. Which system doesn't
have a working find? Also, we can just fail when we try to use find, and
don't need a check first.

This is still  after "unshare", which will be addressed next.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 53 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index ae8c6d934dcf..184dd3f38be5 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -17,11 +17,12 @@ usage() {
 	echo " $0 [OPTIONS]"
 	echo
 	echo "OPTIONS:"
-	echo " -h|--help : print usage"
-	echo " -v        : sets VERBOSE=y"
-	echo " -g        : sets DUMPGEN=y"
-	echo " -V        : sets VALGRIND=y"
-	echo " -K        : sets KMEMLEAK=y"
+	echo " -h|--help       : print usage"
+	echo " -L|--list-tests : list test names and quit"
+	echo " -v              : sets VERBOSE=y"
+	echo " -g              : sets DUMPGEN=y"
+	echo " -V              : sets VALGRIND=y"
+	echo " -K              : sets KMEMLEAK=y"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>   : Path to nft executable"
@@ -32,8 +33,8 @@ usage() {
 }
 
 # Configuration
-TESTDIR="./$(dirname $0)/testcases"
-SRC_NFT="$(dirname $0)/../../src/nft"
+BASEDIR="$(dirname "$0")"
+SRC_NFT="$BASEDIR/../../src/nft"
 DIFF=$(which diff)
 
 if [ "$(id -u)" != "0" ] ; then
@@ -53,6 +54,7 @@ VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+DO_LIST_TESTS=
 
 TESTS=()
 
@@ -76,6 +78,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-L|--list-tests)
+			DO_LIST_TESTS=y
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -89,7 +94,19 @@ while [ $# -gt 0 ] ; do
 	esac
 done
 
-SINGLE="${TESTS[*]}"
+find_tests() {
+	find "$1" -type f -executable | sort
+}
+
+if [ "${#TESTS[@]}" -eq 0 ] ; then
+	TESTS=( $(find_tests "$BASEDIR/testcases/") )
+	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
+fi
+
+if [ "$DO_LIST_TESTS" = y ] ; then
+	printf '%s\n' "${TESTS[@]}"
+	exit 0
+fi
 
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
@@ -100,15 +117,6 @@ else
 	msg_info "using nft command: ${NFT}"
 fi
 
-if [ ! -d "$TESTDIR" ] ; then
-	msg_error "missing testdir $TESTDIR"
-fi
-
-FIND="$(which find)"
-if [ ! -x "$FIND" ] ; then
-	msg_error "no find binary found"
-fi
-
 MODPROBE="$(which modprobe)"
 if [ ! -x "$MODPROBE" ] ; then
 	msg_error "no modprobe binary found"
@@ -143,14 +151,6 @@ kernel_cleanup() {
 	nft_xfrm
 }
 
-find_tests() {
-	if [ ! -z "$SINGLE" ] ; then
-		echo $SINGLE
-		return
-	fi
-	${FIND} ${TESTDIR} -type f -executable | sort
-}
-
 printscript() { # (cmd, tmpd)
 	cat <<EOF
 #!/bin/bash
@@ -248,8 +248,7 @@ check_kmemleak()
 
 check_taint
 
-for testfile in $(find_tests)
-do
+for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
-- 
2.41.0

