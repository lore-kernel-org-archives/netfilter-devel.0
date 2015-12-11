From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 2/5] tests/: add shell test-suite
Date: Fri, 11 Dec 2015 11:10:19 +0100
Message-ID: <144982861947.31246.10068876582616840356.stgit@r2d2.cica.es>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36355 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754573AbbLKKKW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:22 -0500
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new test-suite is intended to perform tests of higher level than
the other reggresion test-suite.

It can run arbitrary executables which can perform any test apart of testing
the nft syntax or netlink code (which is what the regression tests does).

To run the test suite (as root):
 % cd tests/shell
 % ./run-tests.sh

Test files are executables files with the pattern <<name_N>>, where N is the
expected return code of the executable. Since they are located with `find',
test-files can be spreaded in any sub-directories.

You can turn on a verbose execution by calling:
 % ./run-tests.sh -v

Before each call to the test-files, `nft flush ruleset' will be called.
Also, test-files will receive the environment variable $NFT which contains the
path to the nftables binary being tested.

You can pass an arbitrary $NFT value as well:
 % NFT=../../src/nft ./run-tests.sh

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/README       |   23 +++++++++++++++
 tests/shell/run-tests.sh |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)
 create mode 100644 tests/shell/README
 create mode 100755 tests/shell/run-tests.sh

diff --git a/tests/shell/README b/tests/shell/README
new file mode 100644
index 0000000..2ce4120
--- /dev/null
+++ b/tests/shell/README
@@ -0,0 +1,23 @@
+This test-suite is intended to perform tests of higher level than
+the other reggresion test-suite.
+
+It can run arbitrary executables which can perform any test apart of testing
+the nft syntax or netlink code (which is what the regression tests does).
+
+To run the test suite (as root):
+ % cd tests/shell
+ % ./run-tests.sh
+
+Test files are executables files with the pattern <<name_N>>, where N is the
+expected return code of the executable. Since they are located with `find',
+test-files can be spreaded in any sub-directories.
+
+You can turn on a verbose execution by calling:
+ % ./run-tests.sh -v
+
+Before each call to the test-files, `nft flush ruleset' will be called.
+Also, test-files will receive the environment variable $NFT which contains the
+path to the nftables binary being tested.
+
+You can pass an arbitrary $NFT value as well:
+ % NFT=../../src/nft ./run-tests.sh
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
new file mode 100755
index 0000000..df2670b
--- /dev/null
+++ b/tests/shell/run-tests.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+
+# Configuration
+TESTDIR="./"
+RETURNCODE_SEPARATOR="_"
+
+msg_error() {
+	echo "E: $1 ..." >&2
+	exit 1
+}
+
+msg_warn() {
+	echo "W: $1" >&2
+}
+
+msg_info() {
+	echo "I: $1"
+}
+
+if [ "$(id -u)" != "0" ] ; then
+	msg_error "this requires root!"
+fi
+
+[ -z "$NFT" ] && NFT="$(which nft)"
+if [ ! -x "$NFT" ] ; then
+	msg_error "no nft binary!"
+else
+	msg_info "using nft binary $NFT"
+fi
+
+if [ ! -d "$TESTDIR" ] ; then
+	msg_error "missing testdir $TESTDIR"
+fi
+
+FIND="$(which find)"
+if [ ! -x "$FIND" ] ; then
+	msg_error "no find binary found"
+fi
+
+if [ "$1" == "-v" ] ; then
+	VERBOSE=y
+fi
+
+echo ""
+ok=0
+failed=0
+for testfile in $(${FIND} ${TESTDIR} -executable -regex .*${RETURNCODE_SEPARATOR}[0-9]+)
+do
+	$NFT flush ruleset
+
+	rc_spec=$(awk -F${RETURNCODE_SEPARATOR} '{print $NF}' <<< $testfile)
+	test_output=$(NFT=$NFT ${testfile} ${TESTS_OUTPUT} 2>&1)
+	rc_got=$?
+	if [ "$rc_got" == "$rc_spec" ] ; then
+		msg_info "[OK]		$testfile"
+		[ "$VERBOSE" == "y" ] && [ ! -z "$test_output" ] && echo "$test_output"
+		((ok++))
+	else
+		((failed++))
+		if [ "$VERBOSE" == "y" ] ; then
+			msg_warn "[FAILED]	$testfile: expected $rc_spec but got $rc_got"
+			[ ! -z "$test_output" ] && echo "$test_output"
+		else
+			msg_warn "[FAILED]	$testfile"
+		fi
+	fi
+done
+
+echo ""
+msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+
+$NFT flush ruleset

