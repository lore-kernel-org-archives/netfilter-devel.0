Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D40CA0FE6
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 15:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbjIAPKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbjIAPKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 11:10:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F22210EF
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 08:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693580971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvgLsgpDP1WTm4gL91qYXo2AQvyFjFAdyOEtAGuxZNQ=;
        b=cZjzMSFABro+ev5cc/iVa0im8IW8cJRw6xfPzN2vLgWEJ0H1t1NeLGtf6fNv/kOVZMaCNz
        oCPwfOa7ZDBQ+eyEFhJxXKWxv9UCLaEO7557eccrY9MP8cb6Y/aJ7sw5duUJuFPJk9gNHm
        97Z3gYCIsBKwYnWGpvkCbqG8WPqyv1M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-1tfNnNADOwOjra0PgT_lEQ-1; Fri, 01 Sep 2023 11:09:30 -0400
X-MC-Unique: 1tfNnNADOwOjra0PgT_lEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15049923004
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 15:09:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A9A440C84A5;
        Fri,  1 Sep 2023 15:09:29 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 3/3] tests/shell: run each test in separate namespace and allow rootless
Date:   Fri,  1 Sep 2023 17:05:59 +0200
Message-ID: <20230901150916.183949-4-thaller@redhat.com>
In-Reply-To: <20230901150916.183949-1-thaller@redhat.com>
References: <20230901150916.183949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't unshare the entire shell script, calling itself again. Instead,
call unshare separately for each test invocation. That means, all tests
use now a different sandbox.

Also, allow to run rootless/unprivileged.

The user still can opt-out from unshare via -U/--no-unshare option
or NFT_TEST_NO_UNSHARE=y. That might be useful if unshare for some
reason doesn't work for the user, or if you want to test on your host
system.

Also try to also run a separate PID namespace, to get more isolation. If
that is not working, then fallback without separate PID namespace.

We no longer require [ `id -u` = 0 ] to proceed, so a rootless user can
run the tests. We detect whether we have real root and set
NFT_TEST_HAVE_REALROOT=y. Some tests won't work rootless. For example,
the socket buffers is limited by /proc/sys/net/core/{wmem_max,rmem_max}
which real-root can override, but rootless tests cannot. Such tests
should check for [ "$NFT_TEST_HAVE_REALROOT" != y ] and skip the test
gracefully. Optimally, tests also work in the rootless environment and
most tests should pass in both, and not check for have-realroot.

Usually, the user doesn't need to tell the script whether they have real
root. The script will autodetect it via [ `id -u` = 0 ]. But that won't
work if you run inside a rootless container already. In that case, you
would want to tell the script that we don't have real-root. Either via
-R/--without-root option or NFT_TEST_HAVE_REALROOT=n.

If they wish, the test can know whether they run inside "unshare"
environment by checking for [ "$NFT_TEST_IS_UNSHARED" = y ].

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 83 +++++++++++++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 22 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 147185cb548a..fda738983ec9 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -17,11 +17,13 @@ usage() {
 	echo " $0 [OPTIONS]"
 	echo
 	echo "OPTIONS:"
-	echo " \"-v\"                 : also VERBOSE=y"
-	echo " \"-g\"                 : also DUMPGEN=y"
-	echo " \"-V\"                 : also VALGRIND=y"
-	echo " \"-K\"                 : also KMEMLEAK=y"
-	echo " \"-L\"|\"-list-tests\" : list the test name and quit"
+	echo " \"-v\"                   : also VERBOSE=y"
+	echo " \"-g\"                   : also DUMPGEN=y"
+	echo " \"-V\"                   : also VALGRIND=y"
+	echo " \"-K\"                   : also KMEMLEAK=y"
+	echo " \"-L\"|\"--list-tests\"  : list the test name and quit"
+	echo " \"-R\"|\"--without-realroot\" : sets NFT_TEST_HAVE_REALROOT=n"
+	echo " \"-U\"|\"--no-unshare\"  : sets NFT_TEST_NO_UNSHARE=y"
 	echo
 	echo "VARIABLES:"
 	echo "  NFT=<PATH>   : Path to nft executable"
@@ -29,31 +31,28 @@ usage() {
 	echo "  DUMPGEN=*|y  : See also \"-g\" option"
 	echo "  VALGRIND=*|y : See also \"-V\" option"
 	echo "  KMEMLEAK=*|y : See also \"-y\" option"
+	echo "  NFT_TEST_HAVE_REALROOT=*|y : To indicate whether the test has real root permissions."
+	echo "                 Usually, you don't need this and it gets autodetected."
+	echo "                 You might want to set it, if you know better than the"
+	echo "                 \`id -u\` check, whether the user is root in the main namespace."
+	echo "                 Note that without real root, certain tests may not work,"
+	echo "                 e.g. due to limited /proc/sys/net/core/{wmem_max,rmem_max}."
+	echo "                 Checks that cannot pass in such environment should check for"
+	echo "                 [ \"$NFT_TEST_HAVE_REALROOT\" != y ] and skip gracefully."
+	echo " NFT_TEST_NO_UNSHARE=*|y : Usually, each test will run in a separate namespace."
+	echo "                 You can opt-out from that by setting NFT_TEST_NO_UNSHARE=y."
 }
 
-# Configuration
 BASEDIR="$(dirname "$0")"
 TESTDIR="$BASEDIR/testcases"
 SRC_NFT="$BASEDIR/../../src/nft"
-DIFF=$(which diff)
-
-if [ "$(id -u)" != "0" ] ; then
-	msg_error "this requires root!"
-fi
-
-if [ "${1}" != "run" ]; then
-	if unshare -f -n true; then
-		unshare -n "${0}" run $@
-		exit $?
-	fi
-	msg_warn "cannot run in own namespace, connectivity might break"
-fi
-shift
 
 VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+NFT_TEST_HAVE_REALROOT="$NFT_TEST_HAVE_REALROOT"
+NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -81,6 +80,12 @@ while [ $# -gt 0 ] ; do
 		-L|--list-tests)
 			DO_LIST_TESTS=y
 			;;
+		-R|--without-realroot)
+			NFT_TEST_HAVE_REALROOT=n
+			;;
+		-U|--no-unshare)
+			NFT_TEST_NO_UNSHARE=y
+			;;
 		--)
 			TESTS=("$@")
 			VERBOSE=y
@@ -108,6 +113,33 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
+if [ "$NFT_TEST_HAVE_REALROOT" = "" ] ; then
+	# The caller didn't set NFT_TEST_HAVE_REALROOT and didn't specify
+	# -R/--without-root option. Autodetect it based on `id -u`.
+	export NFT_TEST_HAVE_REALROOT="$(test "$(id -u)" = "0" && echo y || echo n)"
+fi
+
+UNSHARE=()
+NFT_TEST_IS_UNSHARED=n
+if [ "$NFT_TEST_NO_UNSHARE" != y ]; then
+	# We unshare both if we NFT_TEST_HAVE_REALROOT and the rootless/unpriv
+	# case. Without real root, some tests may fail. Tests that don't work
+	# without real root should check for [ "$NFT_TEST_HAVE_REALROOT" != y ]
+	# and skip gracefully.
+	UNSHARE=( unshare -f -p --mount-proc -U --map-root-user -n )
+	if ! "${UNSHARE[@]}" true ; then
+		# Try without PID namespace.
+		UNSHARE=( unshare -f -U --map-root-user -n )
+		if ! "${UNSHARE[@]}" true ; then
+			msg_error "Unshare does not work. Rerun with -U/--no-unshare or NFT_TEST_NO_UNSHARE=y"
+		fi
+	fi
+	NFT_TEST_IS_UNSHARED=y
+fi
+
+# If they wish, test can check whether they run unshared.
+export NFT_TEST_IS_UNSHARED
+
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -128,7 +160,9 @@ if [ ! -x "$DIFF" ] ; then
 fi
 
 kernel_cleanup() {
-	$NFT flush ruleset
+	if [ "$NFT_TEST_IS_UNSHARED" != y ] ; then
+		$NFT flush ruleset
+	fi
 	$MODPROBE -raq \
 	nft_reject_ipv4 nft_reject_bridge nft_reject_ipv6 nft_reject \
 	nft_redir_ipv4 nft_redir_ipv6 nft_redir \
@@ -253,7 +287,7 @@ for testfile in "${TESTS[@]}" ; do
 	kernel_cleanup
 
 	msg_info "[EXECUTING]	$testfile"
-	test_output=$(NFT="$NFT" DIFF=$DIFF ${testfile} 2>&1)
+	test_output=$(NFT="$NFT" DIFF=$DIFF "${UNSHARE[@]}" "$testfile" 2>&1)
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
@@ -312,4 +346,9 @@ check_kmemleak_force
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
 kernel_cleanup
+
+if [ "$failed" -gt 0 -a "$NFT_TEST_HAVE_REALROOT" != y ] ; then
+	msg_info "test was not running as real root"
+fi
+
 [ "$failed" -eq 0 ]
-- 
2.41.0

