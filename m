Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439EDCA0FE4
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 15:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjIAPKQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbjIAPKQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 11:10:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E9A10F3
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693580971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHE/6OLGs2HQOunBKziawwPeR5/uWNr8lB/o48s935U=;
        b=fs0BfclbBuNViQU4iZTxI+sj/Sn70hHjPLlZwdcf4/qz7tVCfspVlIzA3L64+bxHIcB8bV
        6E6W1+xZSeR8wF8/HlDJY2g8M/uwx8xvph+xsZ3muV9uKouQl7dI0HCabBRs2A8cCXjP9H
        obWVy28/ioKv+36h4DCLbGmFteINW3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-5d47vrhtOKysJsi4da_5-Q-1; Fri, 01 Sep 2023 11:09:29 -0400
X-MC-Unique: 5d47vrhtOKysJsi4da_5-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E081944E81
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 15:09:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C325840C84A5;
        Fri,  1 Sep 2023 15:09:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 2/3] tests/shell: rework finding tests and add "--list-tests" option
Date:   Fri,  1 Sep 2023 17:05:58 +0200
Message-ID: <20230901150916.183949-3-thaller@redhat.com>
In-Reply-To: <20230901150916.183949-1-thaller@redhat.com>
References: <20230901150916.183949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cleanup finding the test files. Also add a "--list-tests" option to see
which tests are found and would run.

Also get rid of the FIND="$(which find)" detection. It's not that the
user could set the used find program via an environment variable. Also,
which system doesn't have "find"? Just fail when our call to "find"
fails.

This is still  after "unshare", which makes no sense and will be
addressed next.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 52 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 2ece280a2408..147185cb548a 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -17,10 +17,11 @@ usage() {
 	echo " $0 [OPTIONS]"
 	echo
 	echo "OPTIONS:"
-	echo " \"-v\" : also VERBOSE=y"
-	echo " \"-g\" : also DUMPGEN=y"
-	echo " \"-V\" : also VALGRIND=y"
-	echo " \"-K\" : also KMEMLEAK=y"
+	echo " \"-v\"                 : also VERBOSE=y"
+	echo " \"-g\"                 : also DUMPGEN=y"
+	echo " \"-V\"                 : also VALGRIND=y"
+	echo " \"-K\"                 : also KMEMLEAK=y"
+	echo " \"-L\"|\"-list-tests\" : list the test name and quit"
 	echo
 	echo "VARIABLES:"
 	echo "  NFT=<PATH>   : Path to nft executable"
@@ -31,8 +32,9 @@ usage() {
 }
 
 # Configuration
-TESTDIR="./$(dirname $0)/testcases"
-SRC_NFT="$(dirname $0)/../../src/nft"
+BASEDIR="$(dirname "$0")"
+TESTDIR="$BASEDIR/testcases"
+SRC_NFT="$BASEDIR/../../src/nft"
 DIFF=$(which diff)
 
 if [ "$(id -u)" != "0" ] ; then
@@ -52,6 +54,7 @@ VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+DO_LIST_TESTS=
 
 TESTS=()
 
@@ -75,6 +78,9 @@ while [ $# -gt 0 ] ; do
 			usage
 			exit 0
 			;;
+		-L|--list-tests)
+			DO_LIST_TESTS=y
+			;;
 		--)
 			TESTS=("$@")
 			VERBOSE=y
@@ -88,7 +94,19 @@ while [ $# -gt 0 ] ; do
 	esac
 done
 
-SINGLE="${TESTS[*]}"
+if [ ! -d "$TESTDIR" ] ; then
+	msg_error "missing testdir $TESTDIR"
+fi
+
+if [ "${#TESTS[@]}" -eq 0 ]; then
+	TESTS=( $(find "$TESTDIR" -type f -executable | sort) ) || \
+		msg_error "Could not find tests"
+fi
+
+if [ "$DO_LIST_TESTS" = y ] ; then
+	printf '%s\n' "${TESTS[@]}"
+	exit 0
+fi
 
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
@@ -99,15 +117,6 @@ else
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
@@ -142,14 +151,6 @@ kernel_cleanup() {
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
@@ -247,8 +248,7 @@ check_kmemleak()
 
 check_taint
 
-for testfile in $(find_tests)
-do
+for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
-- 
2.41.0

