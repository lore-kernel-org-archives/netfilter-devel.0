Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9536EEB8FB9
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbjIFMCy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6EAE6B
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjofSJv36yEndLN2Vcyz7H+oy9MS7WeH5QHVlpXXiDo=;
        b=ZPyHUSK0oy0CVeco83SSpd77da119cYAQ9aJh48QeNsqAdlxF/iw1Ot/0v6Sk8/RXi/gKx
        +oexoIUGorKx7nOJGXr6secwgYoDCooZTu+QeIerotJaDo7uIUekcmyvIgAAu6bDxaN7Vb
        KUnqJ3od4mr4HfPYoFMMYRHLNtYhlCU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-h-I792awMyOfJjCkTlWS1g-1; Wed, 06 Sep 2023 08:01:25 -0400
X-MC-Unique: h-I792awMyOfJjCkTlWS1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B83F38149AD
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A7AC15BB8;
        Wed,  6 Sep 2023 12:01:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 07/19] tests/shell: run each test in separate namespace and allow rootless
Date:   Wed,  6 Sep 2023 13:52:10 +0200
Message-ID: <20230906120109.1773860-8-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't unshare the entire shell script. Instead, call unshare each test
separately. That means, all tests use now a different sandbox and will
also allow (with further changes) to run them in parallel.

Also, allow to run rootless/unprivileged.

The script first tries to run a separate PID+USER+NET namespace. If that
fails, it downgrades to USER+NET. If that fails, it downgrades to a
separate NET namespace. If unshare still fails, the script fails
entirely. That differs from before, where the script would proceed
without sandboxing. The script will now always require that unsharing
works, unless the user opts-out.

If the user cannot unshare, they can set NFT_TEST_UNSHARE_CMD to the
command used for unsharing. It may be empty for no unshare.  The command
line arguments -U/--no-unshare are a shortcut for setting
NFT_TEST_UNSHARE_CMD="".

If we are able to create a separate USER namespace, then this mode
allows to run the test as rootless/unprivileged. We no longer require
[ `id -u` = 0 ]. Some tests may not work as rootless. For example, the
socket buffers is limited by /proc/sys/net/core/{wmem_max,rmem_max}
which real-root can override, but rootless tests cannot. Such tests
should check for [ "$NFT_TEST_HAS_REALROOT" != y ] and skip gracefully.

Usually, the user doesn't need to tell the script whether they have
real-root. The script will autodetect it via [ `id -u` = 0 ]. But that
won't work when run inside a rootless container already. In that case,
the user would want to tell the script that there is no real-root. They
can do so via the -R/--without-root option or NFT_TEST_HAS_REALROOT=n.

If tests wish, the can know whether they run inside "unshare"
environment by checking for [ "$NFT_TEST_HAS_UNSHARED" = y ].

When setting NFT_TEST_UNSHARE_CMD to override the unshare command, users
may want to also set NFT_TEST_HAS_UNSHARED= and NFT_TEST_HAS_REALROOT=
correctly.

As we run each test in a separate unshare environment, we need a wrapper
"tests/shell/helpers/test-wrapper.sh" around the test, which executes
inside the tested environment. Also, each test gets its own temp
directory prepared in NFT_TEST_TESTTMPDIR. This is also the place, where
test artifacts and results will be collected.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh |  23 ++++++
 tests/shell/run-tests.sh            | 124 ++++++++++++++++++++++++----
 2 files changed, 130 insertions(+), 17 deletions(-)
 create mode 100755 tests/shell/helpers/test-wrapper.sh

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
new file mode 100755
index 000000000000..f811b44aab0d
--- /dev/null
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -0,0 +1,23 @@
+#!/bin/bash -e
+
+# This wrapper wraps the invocation of the test. It is called by run-tests.sh,
+# and already in the unshared namespace.
+#
+# For some printf debugging, you can also patch this file.
+
+TEST="$1"
+
+printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
+
+rc_test=0
+"$TEST" |& tee "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
+
+if [ "$rc_test" -eq 0 ] ; then
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-ok"
+else
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-failed"
+fi
+
+$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
+
+exit "$rc_test"
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 2c6eaea3636f..f083773c2310 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -34,6 +34,8 @@ usage() {
 	echo " -g              : Sets DUMPGEN=y."
 	echo " -V              : Sets VALGRIND=y."
 	echo " -K              : Sets KMEMLEAK=y."
+	echo " -R|--without-realroot : Sets NFT_TEST_HAS_REALROOT=n."
+	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
 	echo "                   that is, executables that are run by the runner."
@@ -47,6 +49,25 @@ usage() {
 	echo " DUMPGEN=*|y   : Regenerate dump files."
 	echo " VALGRIND=*|y  : Run \$NFT in valgrind."
 	echo " KMEMLEAK=*|y  : Check for kernel memleaks."
+	echo " NFT_TEST_HAS_REALROOT=*|y : To indicate whether the test has real root permissions."
+	echo "                 Usually, you don't need this and it gets autodetected."
+	echo "                 You might want to set it, if you know better than the"
+	echo "                 \`id -u\` check, whether the user is root in the main namespace."
+	echo "                 Note that without real root, certain tests may not work,"
+	echo "                 e.g. due to limited /proc/sys/net/core/{wmem_max,rmem_max}."
+	echo "                 Checks that cannot pass in such environment should check for"
+	echo "                 [ \"\$NFT_TEST_HAS_REALROOT\" != y ] and skip gracefully."
+	echo " NFT_TEST_UNSHARE_CMD=cmd : when set, this is the command line for an unshare"
+	echo "                 command, which is used to sandbox each test invocation. By"
+	echo "                 setting it to empty, no unsharing is done."
+	echo "                 By default it is unset, in which case it's autodetected as"
+	echo "                 \`unshare -f -p\` (for root) or as \`unshare -f -p --mount-proc -U --map-root-user -n\`"
+	echo "                 for non-root."
+	echo "                 When setting this, you may also want to set NFT_TEST_HAS_UNSHARED="
+	echo "                 and NFT_TEST_HAS_REALROOT= accordingly."
+	echo " NFT_TEST_HAS_UNSHARED=*|y : To indicate to the test whether the test run will be unshared."
+	echo "                 Test may consider this."
+	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data."
 }
 
@@ -55,23 +76,11 @@ NFT_TEST_BASEDIR="$(dirname "$0")"
 # Export the base directory. It may be used by tests.
 export NFT_TEST_BASEDIR
 
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
-
 VERBOSE="$(bool_y "$VERBOSE")"
 DUMPGEN="$(bool_y "$DUMPGEN")"
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
+NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -99,6 +108,12 @@ while [ $# -gt 0 ] ; do
 		-L|--list-tests)
 			DO_LIST_TESTS=y
 			;;
+		-R|--without-realroot)
+			NFT_TEST_HAS_REALROOT=n
+			;;
+		-U|--no-unshare)
+			NFT_TEST_UNSHARE_CMD=
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -140,6 +155,62 @@ fi
 
 _TMPDIR="${TMPDIR:-/tmp}"
 
+if [ "$NFT_TEST_HAS_REALROOT" = "" ] ; then
+	# The caller didn't set NFT_TEST_HAS_REALROOT and didn't specify
+	# -R/--without-root option. Autodetect it based on `id -u`.
+	export NFT_TEST_HAS_REALROOT="$(test "$(id -u)" = "0" && echo y || echo n)"
+else
+	NFT_TEST_HAS_REALROOT="$(bool_y "$NFT_TEST_HAS_REALROOT")"
+fi
+export NFT_TEST_HAS_REALROOT
+
+detect_unshare() {
+	if ! $1 true &>/dev/null ; then
+		return 1
+	fi
+	NFT_TEST_UNSHARE_CMD="$1"
+	return 0
+}
+
+if [ -n "${NFT_TEST_UNSHARE_CMD+x}" ] ; then
+	# User overrides the unshare command.
+	if ! detect_unshare "$NFT_TEST_UNSHARE_CMD" ; then
+		msg_error "Cannot unshare via NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
+	fi
+	if [ -z "${NFT_TEST_HAS_UNSHARED+x}" ] ; then
+		# Autodetect NFT_TEST_HAS_UNSHARED based one whether
+		# $NFT_TEST_UNSHARE_CMD is set.
+		if [ -n "$NFT_TEST_UNSHARE_CMD" ] ; then
+			NFT_TEST_HAS_UNSHARED="y"
+		else
+			NFT_TEST_HAS_UNSHARED="n"
+		fi
+	else
+		NFT_TEST_HAS_UNSHARED="$(bool_y "$NFT_TEST_HAS_UNSHARED")"
+	fi
+else
+	if [ "$NFT_TEST_HAS_REALROOT" = y ] ; then
+		# We appear to have real root. So try to unshare
+		# without a separate USERNS. CLONE_NEWUSER will break
+		# tests that are limited by
+		# /proc/sys/net/core/{wmem_max,rmem_max}. With real
+		# root, we want to test that.
+		detect_unshare "unshare -f -n -m" ||
+			detect_unshare "unshare -f -n" ||
+			detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
+			detect_unshare "unshare -f -U --map-root-user -n"
+	else
+		detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
+			detect_unshare "unshare -f -U --map-root-user -n"
+	fi
+	if [ -z "$NFT_TEST_UNSHARE_CMD" ] ; then
+		msg_error "Unshare does not work. Run as root with -U/--no-unshare or set NFT_TEST_UNSHARE_CMD"
+	fi
+	NFT_TEST_HAS_UNSHARED=y
+fi
+# If tests wish, they can know whether they are unshared via this variable.
+export NFT_TEST_HAS_UNSHARED
+
 [ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -171,6 +242,9 @@ msg_info "conf: VERBOSE=$(printf '%q' "$VERBOSE")"
 msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
 msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
+msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
+msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
+msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
 NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
@@ -181,9 +255,14 @@ ln -snf "$NFT_TEST_TMPDIR" "$NFT_TEST_LATEST"
 # distinct files! It will be deleted on EXIT.
 export NFT_TEST_TMPDIR
 
+echo
+msg_info "info: NFT_TEST_BASEDIR=$(printf '%q' "$NFT_TEST_BASEDIR")"
+msg_info "info: NFT_TEST_TMPDIR=$(printf '%q' "$NFT_TEST_TMPDIR")"
 
 kernel_cleanup() {
-	$NFT flush ruleset
+	if [ "$NFT_TEST_HAS_UNSHARED" != y ] ; then
+		$NFT flush ruleset
+	fi
 	$MODPROBE -raq \
 	nft_reject_ipv4 nft_reject_bridge nft_reject_ipv6 nft_reject \
 	nft_redir_ipv4 nft_redir_ipv6 nft_redir \
@@ -297,22 +376,32 @@ check_kmemleak()
 
 check_taint
 
+TESTIDX=0
 for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
+	((TESTIDX++))
+
+	# We also create and export a test-specific temporary directory.
+	NFT_TEST_TESTTMPDIR="$NFT_TEST_TMPDIR/test-${testfile//\//-}.$TESTIDX"
+	mkdir "$NFT_TEST_TESTTMPDIR"
+	chmod 755 "$NFT_TEST_TESTTMPDIR"
+	export NFT_TEST_TESTTMPDIR
+
 	msg_info "[EXECUTING]	$testfile"
-	test_output=$(NFT="$NFT" DIFF=$DIFF ${testfile} 2>&1)
+	test_output="$(NFT="$NFT" DIFF=$DIFF $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile" 2>&1)"
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
 	if [ "$rc_got" -eq 0 ] ; then
+		# FIXME: this should move inside test-wrapper.sh.
 		# check nft dump only for positive tests
 		dumppath="$(dirname ${testfile})/dumps"
 		dumpfile="${dumppath}/$(basename ${testfile}).nft"
 		rc_spec=0
 		if [ "$rc_got" -eq 0 ] && [ -f ${dumpfile} ]; then
-			test_output=$(${DIFF} -u ${dumpfile} <($NFT list ruleset) 2>&1)
+			test_output=$(${DIFF} -u ${dumpfile} <(cat "$NFT_TEST_TESTTMPDIR/ruleset-after") 2>&1)
 			rc_spec=$?
 		fi
 
@@ -323,7 +412,7 @@ for testfile in "${TESTS[@]}" ; do
 
 			if [ "$DUMPGEN" == "y" ] && [ "$rc_got" == 0 ] && [ ! -f "${dumpfile}" ]; then
 				mkdir -p "${dumppath}"
-				$NFT list ruleset > "${dumpfile}"
+				cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "${dumpfile}"
 			fi
 		else
 			((failed++))
@@ -361,4 +450,5 @@ check_kmemleak_force
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
 kernel_cleanup
+
 [ "$failed" -eq 0 ]
-- 
2.41.0

