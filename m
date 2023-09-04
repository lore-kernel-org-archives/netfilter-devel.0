Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE263C83F3F
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbjIDNxZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbjIDNxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86223CE0
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SC94s1nGvKm+XcvSSdeodAD0889Jgt9wNRI6WAUlIMw=;
        b=dbpsTHt0XsNgWDz6cnej6E434NH1Ec4xkF0TQHS+Xcjx13xlRztKJPMB7NCDREQFizQy3Q
        kUsHk5t8Ks3K1b2A2p7H86nuP4i41XEU+iNsNEA9ilRorAI77Y9dEVwTC9ZN1wgEv6/POW
        ARcYh6/FGkf27q4p7HqkQ36TbyODlnM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-f9dqCm1QO0qR1eB-CuTnGA-1; Mon, 04 Sep 2023 09:51:50 -0400
X-MC-Unique: f9dqCm1QO0qR1eB-CuTnGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AE4229DD986
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 810241121318;
        Mon,  4 Sep 2023 13:51:49 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 05/11] tests/shell: run each test in separate namespace and allow rootless
Date:   Mon,  4 Sep 2023 15:48:07 +0200
Message-ID: <20230904135135.1568180-6-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

If the user cannot unshare, they have two options. Either the
NFT_TEST_NO_UNSHARE=y variable (-U/--no-unshare), which disables unshare
done by the script. This allows the user to run the script as before.
Alternatively, the user can set NFT_TEST_UNSHARE_CMD for the command to
unshare, including setting it to empty for no unshare.

If we are able to create a separate USER namespace, then this mode
allows to run the test as rootless/unprivileged. We no longer require
[ `id -u` = 0 ]. Some tests may not work as rootless. For example, the
socket buffers is limited by /proc/sys/net/core/{wmem_max,rmem_max}
which real-root can override, but rootless tests cannot. Such tests
should check for [ "$NFT_TEST_HAVE_REALROOT" != y ] and skip gracefully.

Usually, the user doesn't need to tell the script whether they have
real-root. The script will autodetect it via [ `id -u` = 0 ]. But that
won't work when run inside a rootless container already. In that case,
the user would want to tell the script that there is no real-root. They
can do so via the -R/--without-root option or NFT_TEST_HAVE_REALROOT=n.

If tests wish, the can know whether they run inside "unshare"
environment by checking for [ "$NFT_TEST_IS_UNSHARED" = y ].

When setting NFT_TEST_UNSHARE_CMD to override the unshare command, users
may want to also set NFT_TEST_IS_UNSHARED= and NFT_TEST_HAVE_REALROOT=
correctly.

As we run each test in a separate unshare environment, we need a wrapper
"tests/shell/helpers/test-wrapper.sh" around the test, which executes
inside the tested environment. Also, each test gets its own temp
directory prepared in NFT_TEST_TESTTMPDIR. This is also the place, where
test artifacts and results will be collected.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh |  21 ++++++
 tests/shell/run-tests.sh            | 109 ++++++++++++++++++++++------
 2 files changed, 107 insertions(+), 23 deletions(-)
 create mode 100755 tests/shell/helpers/test-wrapper.sh

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
new file mode 100755
index 000000000000..99546f060e26
--- /dev/null
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -0,0 +1,21 @@
+#!/bin/bash -e
+
+# This wrapper wraps the invocation of the test. It is called by run-tests.sh,
+# and already in the unshared namespace.
+#
+# For some printf debugging, you can also patch this file.
+
+TEST="$1"
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
index 22a34f1f7898..3d0ef6fa8499 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -17,12 +17,14 @@ usage() {
 	echo " $0 [OPTIONS]"
 	echo
 	echo "OPTIONS:"
-	echo " -h|--help       : print usage"
-	echo " -L|--list-tests : list test names and quit"
-	echo " -v              : sets VERBOSE=y"
-	echo " -g              : sets DUMPGEN=y"
-	echo " -V              : sets VALGRIND=y"
-	echo " -K              : sets KMEMLEAK=y"
+	echo " -h|--help        : print usage"
+	echo " -L|--list-tests  : list test names and quit"
+	echo " -v               : sets VERBOSE=y"
+	echo " -g               : sets DUMPGEN=y"
+	echo " -V               : sets VALGRIND=y"
+	echo " -K               : sets KMEMLEAK=y"
+	echo " -R|--without-realroot : sets NFT_TEST_HAVE_REALROOT=n"
+	echo " -U|--no-unshare  : sets NFT_TEST_NO_UNSHARE=y"
 	echo
 	echo "ENVIRONMENT VARIABLES:"
 	echo " NFT=<PATH>   : Path to nft executable"
@@ -30,6 +32,24 @@ usage() {
 	echo " DUMPGEN=*|y  : Regenerate dump files"
 	echo " VALGRIND=*|y : Run \$NFT in valgrind"
 	echo " KMEMLEAK=*|y : Check for kernel memleaks"
+	echo " NFT_TEST_HAVE_REALROOT=*|y : To indicate whether the test has real root permissions."
+	echo "                Usually, you don't need this and it gets autodetected."
+	echo "                You might want to set it, if you know better than the"
+	echo "                \`id -u\` check, whether the user is root in the main namespace."
+	echo "                Note that without real root, certain tests may not work,"
+	echo "                e.g. due to limited /proc/sys/net/core/{wmem_max,rmem_max}."
+	echo "                Checks that cannot pass in such environment should check for"
+	echo "                [ \"\$NFT_TEST_HAVE_REALROOT\" != y ] and skip gracefully."
+	echo " NFT_TEST_NO_UNSHARE=*|y : Usually, each test will run in a separate user namespace."
+	echo "                That allows to run rootless."
+	echo "                If creating a user namespace fails, fallback to only unshare the"
+	echo "                network namespace. This requires root. If that still fails, error out."
+	echo "                Setting NFT_TEST_NO_UNSHARE=y disables any unshare and the test runs"
+	echo "                in the callers namespace. This is ignored when NFT_TEST_UNSHARE_CMD is set."
+	echo " NFT_TEST_UNSHARE_CMD=cmd : when set, NFT_TEST_NO_UNSHARE is ignored and the script"
+	echo "                will not try to unshare. Instead, it uses this command to unshare."
+	echo "                Set to empty to not unshare. You may want to export NFT_TEST_IS_UNSHARED="
+	echo "                and NFT_TEST_HAVE_REALROOT= accordingly."
 }
 
 NFT_TEST_BASEDIR="$(dirname "$0")"
@@ -37,23 +57,12 @@ NFT_TEST_BASEDIR="$(dirname "$0")"
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
 VERBOSE="$VERBOSE"
 DUMPGEN="$DUMPGEN"
 VALGRIND="$VALGRIND"
 KMEMLEAK="$KMEMLEAK"
+NFT_TEST_HAVE_REALROOT="$NFT_TEST_HAVE_REALROOT"
+NFT_TEST_NO_UNSHARE="$NFT_TEST_NO_UNSHARE"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -81,6 +90,12 @@ while [ $# -gt 0 ] ; do
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
 			TESTS+=( "$@" )
 			shift $#
@@ -120,6 +135,42 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
+if [ "$NFT_TEST_HAVE_REALROOT" = "" ] ; then
+	# The caller didn't set NFT_TEST_HAVE_REALROOT and didn't specify
+	# -R/--without-root option. Autodetect it based on `id -u`.
+	export NFT_TEST_HAVE_REALROOT="$(test "$(id -u)" = "0" && echo y || echo n)"
+fi
+
+if [ -n "${NFT_TEST_UNSHARE_CMD+x}" ] ; then
+	# User overrides the unshare command. We ignore NFT_TEST_NO_UNSHARE.
+	# It may be set to empty, to not unshare. The user should export NFT_TEST_IS_UNSHARED=
+	# accordingly.
+	NFT_TEST_UNSHARE_CMD="${NFT_TEST_UNSHARE_CMD}"
+	NFT_TEST_IS_UNSHARED="${NFT_TEST_IS_UNSHARED}"
+else
+	NFT_TEST_UNSHARE_CMD=""
+	NFT_TEST_IS_UNSHARED="n"
+	if [ "$NFT_TEST_NO_UNSHARE" != y ] ; then
+		# We unshare both if we NFT_TEST_HAVE_REALROOT and the rootless/unpriv
+		# case. Without real root, some tests may fail. Tests that don't work
+		# without real root should check for [ "$NFT_TEST_HAVE_REALROOT" != y ]
+		# and skip gracefully.
+		NFT_TEST_UNSHARE_CMD="unshare -f -p --mount-proc -U --map-root-user -n"
+		if ! $NFT_TEST_UNSHARE_CMD true &>/dev/null ; then
+			NFT_TEST_UNSHARE_CMD="unshare -f -U --map-root-user -n"
+			if ! $NFT_TEST_UNSHARE_CMD true &>/dev/null ; then
+				NFT_TEST_UNSHARE_CMD="unshare -f -n"
+				if ! $NFT_TEST_UNSHARE_CMD true &>/dev/null ; then
+					msg_error "Unshare does not work. Run as root with -U/--no-unshare/NFT_TEST_NO_UNSHARE=y or set NFT_TEST_UNSHARE_CMD"
+				fi
+			fi
+		fi
+		NFT_TEST_IS_UNSHARED=y
+	fi
+fi
+# If tests wish, they can know whether they are unshared via this variable.
+export NFT_TEST_IS_UNSHARED
+
 [ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -157,7 +208,9 @@ export NFT_TEST_TMPDIR
 
 
 kernel_cleanup() {
-	$NFT flush ruleset
+	if [ "$NFT_TEST_IS_UNSHARED" != y ] ; then
+		$NFT flush ruleset
+	fi
 	$MODPROBE -raq \
 	nft_reject_ipv4 nft_reject_bridge nft_reject_ipv6 nft_reject \
 	nft_redir_ipv4 nft_redir_ipv6 nft_redir \
@@ -275,18 +328,23 @@ for testfile in "${TESTS[@]}" ; do
 	read taint < /proc/sys/kernel/tainted
 	kernel_cleanup
 
+	# We also create and export a test-specific temporary directory.
+	NFT_TEST_TESTTMPDIR="$(mktemp -p "$NFT_TEST_TMPDIR" -d "test-${testfile//\//-}.XXXXXX")"
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
 
@@ -297,7 +355,7 @@ for testfile in "${TESTS[@]}" ; do
 
 			if [ "$DUMPGEN" == "y" ] && [ "$rc_got" == 0 ] && [ ! -f "${dumpfile}" ]; then
 				mkdir -p "${dumppath}"
-				$NFT list ruleset > "${dumpfile}"
+				cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "${dumpfile}"
 			fi
 		else
 			((failed++))
@@ -335,4 +393,9 @@ check_kmemleak_force
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

