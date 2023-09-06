Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75548EB8FAF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjIFMCM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjIFMCL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD5BF
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srl2+6Vt9IS3WLr8iPyTCkWSt+7T/UK7ibq4M6sX7wU=;
        b=LWN1ja5Keq7wjSYI33joMuMI0fSvn09JyMsoUCXuCDa20DVFx7SYSVQ6fCzDuRVoTGjIOM
        GUwO7cEM9Ryakz16PvbEMaJXqbimfQI6nenxnW+pZiRaOcZpI/OzdpRmzC5pDtCeU/uv51
        hpAJa77Rmh7jE1omqhXE5qW6FKcp3JA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-F2ft_lG1NKu_grwTvjnaMw-1; Wed, 06 Sep 2023 08:01:21 -0400
X-MC-Unique: F2ft_lG1NKu_grwTvjnaMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D6231C0725C
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D135C15BB8;
        Wed,  6 Sep 2023 12:01:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 02/19] tests/shell: rework finding tests and add "--list-tests" option
Date:   Wed,  6 Sep 2023 13:52:05 +0200
Message-ID: <20230906120109.1773860-3-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 tests/shell/run-tests.sh | 58 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index a15764935ec6..5f526dd8f258 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -14,14 +14,18 @@ msg_info() {
 }
 
 usage() {
-	echo " $0 [OPTIONS]"
+	echo " $0 [OPTIONS] [TESTS...]"
 	echo
 	echo "OPTIONS:"
-	echo " -h|--help : Print usage."
-	echo " -v        : Sets VERBOSE=y."
-	echo " -g        : Sets DUMPGEN=y."
-	echo " -V        : Sets VALGRIND=y."
-	echo " -K        : Sets KMEMLEAK=y."
+	echo " -h|--help       : Print usage."
+	echo " -L|--list-tests : List test names and quit."
+	echo " -v              : Sets VERBOSE=y. Specifying tests without \"--\" enables verbose mode."
+	echo " -g              : Sets DUMPGEN=y."
+	echo " -V              : Sets VALGRIND=y."
+	echo " -K              : Sets KMEMLEAK=y."
+	echo " --              : Separate options from tests."
+	echo " [TESTS...]      : Other options are treated as test names,"
+	echo "                   that is, executables that are run by the runner."
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<CMD>    : Path to nft executable. Will be called as \`\$NFT [...]\` so"
@@ -35,8 +39,8 @@ usage() {
 }
 
 # Configuration
-TESTDIR="./$(dirname $0)/testcases"
-SRC_NFT="$(dirname $0)/../../src/nft"
+BASEDIR="$(dirname "$0")"
+SRC_NFT="$BASEDIR/../../src/nft"
 DIFF=$(which diff)
 
 if [ "$(id -u)" != "0" ] ; then
@@ -56,6 +60,7 @@ VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+DO_LIST_TESTS=
 
 TESTS=()
 
@@ -79,6 +84,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-L|--list-tests)
+			DO_LIST_TESTS=y
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -92,7 +100,19 @@ while [ $# -gt 0 ] ; do
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
@@ -103,15 +123,6 @@ else
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
@@ -146,14 +157,6 @@ kernel_cleanup() {
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
@@ -251,8 +254,7 @@ check_kmemleak()
 
 check_taint
 
-for testfile in $(find_tests)
-do
+for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
-- 
2.41.0

