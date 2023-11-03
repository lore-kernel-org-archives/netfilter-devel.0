Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AC8C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjKCLM4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKCLM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA315D48
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlH/2BWKUb0KxrJVIFXIgilkrmuM5puW06UfS2fF7YU=;
        b=OJJZ0x3OD5kyLZ4VNRu9CMDdWyEqvzwuM7zrOKPWPMBOXiy7Cp6J7cs1umlI2N+3/6r884
        xD26jEQiLFwk2pOUrUelmMhN+gc0av97VT9fxiFjkSuLtBmxKTanpTJa8b0pwgFACnV4q3
        KunZlgg83kYDo2PLDidz7tX20hqBgF0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-3c2n5NJMOLKLKyJBLwOqzQ-1; Fri, 03 Nov 2023 07:11:18 -0400
X-MC-Unique: 3c2n5NJMOLKLKyJBLwOqzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34809101A529
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 880701C060BA;
        Fri,  3 Nov 2023 11:11:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 6/6] tests/unit: add unit tests for libnftables
Date:   Fri,  3 Nov 2023 12:05:48 +0100
Message-ID: <20231103111102.2801624-7-thaller@redhat.com>
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We have a lot of tests/shell tests, that use the nft binary.  However,
it's useful to also write unit tests, that can test the internal C code
specifically.

Since no such tests exist yet, it would be cumbersome to add a test. Add
two binaries, that can be used as a place for such tests. Currently
there are no real tests there, it's only to show how it works, and that
those dummy tests pass (including that the linking and execution works).

To access the internals, build an intermediate static library
src/libnftables-static.la, which then makes up the public, dynamic
src/libnftables.la library. There are two tests:

  - tests/unit/test-libnftables-static
  - tests/unit/test-libnftables

The former statically links with src/libnftables-static.la and can test
internal API from headers under "include/*.h". The latter dynamically
links with src/libnftables.la, and can only test the public API from
includes/nftables/libnftables.h.

You can run the unit tests alone with `make check-TESTS`. Calling
'VALGRIND=y make check' works as expected.

Also add a LOG_COMPILER script "tools/test-runner.sh". This wraps the
execution of the tests. Even for manual testing, you likely don't want
to run "tests/unit/test-*" directly, but rather

  $ ./tools/test-runner.sh tests/unit/test-libnftables

This sets up an unshared namespace and honors VALGRIND=y to run the
test under valgrind. Set NFT_TEST_WRAPPER=gdb to start with a debugger.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .gitignore                           |   8 +-
 Makefile.am                          |  69 ++++++--
 tests/unit/nft-test.h                |  14 ++
 tests/unit/test-libnftables-static.c |  16 ++
 tests/unit/test-libnftables.c        |  21 +++
 tools/test-runner.sh                 | 228 +++++++++++++++++++++++++++
 6 files changed, 346 insertions(+), 10 deletions(-)
 create mode 100644 tests/unit/nft-test.h
 create mode 100644 tests/unit/test-libnftables-static.c
 create mode 100644 tests/unit/test-libnftables.c
 create mode 100755 tools/test-runner.sh

diff --git a/.gitignore b/.gitignore
index 51429020ceb6..369678a13987 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,7 +25,13 @@ libtool
 
 # Generated by tests
 *.payload.got
-tests/build/tests.log
+test-suite.log
+tests/**/*.log
+tests/**/*.trs
+tests/**/*.valgrind-log
+
+tests/unit/test-libnftables
+tests/unit/test-libnftables-static
 
 # Debian package build temporary files
 build-stamp
diff --git a/Makefile.am b/Makefile.am
index f06fab8e3b9f..074d2076c53d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,12 +31,18 @@ lib_LTLIBRARIES =
 noinst_LTLIBRARIES =
 sbin_PROGRAMS =
 check_PROGRAMS =
+noinst_PROGRAMS =
 check_LTLIBRARIES =
 dist_man_MANS =
 CLEANFILES =
+TESTS =
+test_programs =
 check_local =
 check_more =
 
+TESTS_ENVIRONMENT = VERBOSE="$(V)" NFT_TEST_MAKE=n
+LOG_COMPILER = "$(srcdir)/tools/test-runner.sh" --srcdir "$(abs_srcdir)" --builddir "$(abs_builddir)" --
+
 ###############################################################################
 
 pkginclude_HEADERS = \
@@ -205,11 +211,9 @@ endif
 
 ###############################################################################
 
-lib_LTLIBRARIES += src/libnftables.la
+noinst_LTLIBRARIES += src/libnftables-static.la
 
-src_libnftables_la_SOURCES = \
-	src/libnftables.map \
-	\
+src_libnftables_static_la_SOURCES = \
 	src/cache.c \
 	src/cmd.c \
 	src/ct.c \
@@ -257,20 +261,36 @@ src_libnftables_la_SOURCES = \
 	$(NULL)
 
 if BUILD_JSON
-src_libnftables_la_SOURCES += \
+src_libnftables_static_la_SOURCES += \
 	src/json.c \
 	src/parser_json.c \
 	$(NULL)
 endif
 
+src_libnftables_static_la_LIBADD = \
+	src/libparser.la \
+	$(LIBMINIGMP_LIBS) \
+	$(LIBMNL_LIBS) \
+	$(LIBNFTNL_LIBS) \
+	$(XTABLES_LIBS) \
+	$(JANSSON_LIBS) \
+	$(NULL)
+
+###############################################################################
+
+lib_LTLIBRARIES += src/libnftables.la
+
+src_libnftables_la_SOURCES = \
+	src/libnftables.map \
+	$(NULL)
+
 src_libnftables_la_LDFLAGS = \
 	-version-info "${libnftables_LIBVERSION}" \
 	-Wl,--version-script="$(srcdir)/src//libnftables.map" \
 	$(NULL)
 
 src_libnftables_la_LIBADD = \
-	src/libparser.la \
-	$(LIBMINIGMP_LIBS) \
+	src/libnftables-static.la \
 	$(LIBMNL_LIBS) \
 	$(LIBNFTNL_LIBS) \
 	$(XTABLES_LIBS) \
@@ -303,6 +323,22 @@ examples_nft_json_file_LDADD = src/libnftables.la
 
 ###############################################################################
 
+EXTRA_DIST += tests/unit/nft-test.h
+
+###############################################################################
+
+test_programs += tests/unit/test-libnftables-static
+
+tests_unit_test_libnftables_static_LDADD = src/libnftables-static.la
+
+###############################################################################
+
+test_programs += tests/unit/test-libnftables
+
+tests_unit_test_libnftables_LDADD = src/libnftables.la
+
+###############################################################################
+
 if BUILD_MAN
 
 dist_man_MANS += \
@@ -390,6 +426,16 @@ dist_pkgsysconf_DATA = \
 
 ###############################################################################
 
+EXTRA_DIST += \
+	tests/build \
+	tests/json_echo \
+	tests/monitor \
+	tests/py \
+	tests/shell \
+	$(NULL)
+
+###############################################################################
+
 EXTRA_DIST += \
 	py/pyproject.toml \
 	py/setup.cfg \
@@ -403,7 +449,6 @@ EXTRA_DIST += \
 
 EXTRA_DIST += \
 	files \
-	tests \
 	tools \
 	$(NULL)
 
@@ -412,7 +457,13 @@ pkgconfig_DATA = libnftables.pc
 
 ###############################################################################
 
-build-all: all $(check_PROGRAMS) $(check_LTLIBRARIES)
+check_PROGRAMS += $(test_programs)
+
+TESTS += $(test_programs)
+
+###############################################################################
+
+build-all: all $(check_PROGRAMS) $(test_programs) $(check_LTLIBRARIES)
 
 .PHONY: build-all
 
diff --git a/tests/unit/nft-test.h b/tests/unit/nft-test.h
new file mode 100644
index 000000000000..cab97b42c669
--- /dev/null
+++ b/tests/unit/nft-test.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __NFT_TEST__H__
+#define __NFT_TEST__H__
+
+#undef NDEBUG
+
+#include <nft.h>
+
+#include <assert.h>
+#include <stdio.h>
+#include <string.h>
+
+#endif /* __NFT_TEST__H__ */
diff --git a/tests/unit/test-libnftables-static.c b/tests/unit/test-libnftables-static.c
new file mode 100644
index 000000000000..e34fcfd77f39
--- /dev/null
+++ b/tests/unit/test-libnftables-static.c
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "nft-test.h"
+
+#include <datatype.h>
+
+static void test_datatype(void)
+{
+	assert(!datatype_lookup(-1));
+}
+
+int main(int argc, char **argv)
+{
+	test_datatype();
+	return 0;
+}
diff --git a/tests/unit/test-libnftables.c b/tests/unit/test-libnftables.c
new file mode 100644
index 000000000000..100558cd5e0f
--- /dev/null
+++ b/tests/unit/test-libnftables.c
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "nft-test.h"
+
+#include <nftables/libnftables.h>
+
+static void test_nft_ctx(void)
+{
+	struct nft_ctx *ctx;
+
+	ctx = nft_ctx_new(0);
+	assert(ctx);
+
+	nft_ctx_free(ctx);
+}
+
+int main(int argc, char **argv)
+{
+	test_nft_ctx();
+	return 0;
+}
diff --git a/tools/test-runner.sh b/tools/test-runner.sh
new file mode 100755
index 000000000000..18658ba4adf1
--- /dev/null
+++ b/tools/test-runner.sh
@@ -0,0 +1,228 @@
+#!/bin/bash
+
+set -e
+
+die() {
+	printf '%s\n' "$*"
+	exit 1
+}
+
+as_bool() {
+	if [ "$#" -eq 0 ] ; then
+		return 1
+	fi
+	case "$1" in
+		y|Y|yes|Yes|YES|1|true|True|TRUE)
+			return 0
+			;;
+		n|N|no|No|NO|0|false|False|FALSE)
+			return 1
+			;;
+		*)
+			# Fallback to the next in the list.
+			shift
+			rc=0
+			as_bool "$@" || rc=$?
+			return "$rc"
+	esac
+}
+
+as_bool_str() {
+	if as_bool "$@" ; then
+		printf y
+	else
+		printf n
+	fi
+}
+
+usage() {
+	echo "  $0 [OPTIONS] TEST"
+	echo
+	echo "Run TEST"
+	echo
+	echo "Options:"
+	echo "  --srcdir dir: Sets SRCDIR=dir."
+	echo "  --builddir dir: Sets BUILDDIR=dir."
+	echo "  -V|--valgrind: Sets VALGRIND=y."
+	echo "  -G|--gdb: Sets NFT_TEST_WRAPPER=gdb."
+	echo "  -m|--make: Sets NFT_TEST_MAKE=y."
+	echo "  --: Separates options from test name."
+	echo "  TEST: the path of the test executable to run."
+	echo
+	echo "Environment variables:"
+	echo "  SRCDIR: set to \$(srcdir) of the project."
+	echo "  BUILDDIR: set to \$(builddir) of the project."
+	echo "  VERBOSE: for verbose output."
+	echo "  VALGRIND: if set to TRUE, run the test under valgrind. NFT_TEST_UNDER_VALGRIND is ignored."
+	echo "  NFT_TEST_UNSHARE_CMD: override the command to unshare the netns."
+	echo "      Set to empty to not unshare."
+	echo "  NFT_TEST_WRAPPER: usually empty. For manual testing, this is prepended to TEST."
+	echo "      Set for example got \"gdb\"."
+	echo "  NFT_TEST_MAKE: if true, call \`make\` on the test first."
+}
+
+usage_and_die() {
+	usage
+	echo
+	die "$@"
+}
+
+TIMESTAMP=$(date '+%Y%m%d-%H%M%S.%3N')
+
+# SRCDIR
+# BUILDDIR
+VERBOSE="$(as_bool_str "$VERBOSE")"
+VALGRIND="$(as_bool_str "$VALGRIND")"
+NFT_TEST_UNSHARE_CMD="${NFT_TEST_UNSHARE_CMD-unshare -m -U --map-root-user -n}"
+NFT_TEST_WRAPPER="${NFT_TEST_WRAPPER}"
+NFT_TEST_MAKE="$(as_bool_str "$NFT_TEST_MAKE")"
+
+unset TEST
+
+while [ $# -gt 0 ] ; do
+	A="$1"
+	shift
+	case "$A" in
+		-h|--help)
+			usage
+			exit 0
+			;;
+		--srcdir)
+			SRCDIR="$1"
+			shift
+			;;
+		--builddir)
+			BUILDDIR="$1"
+			shift
+			;;
+		-V|--valgrind)
+			VALGRIND=y
+			;;
+		-G|--gdb)
+			NFT_TEST_WRAPPER=gdb
+			;;
+		-m|--make)
+			NFT_TEST_MAKE=y
+			;;
+		--)
+			if [ $# -ne 1 ] ; then
+				usage_and_die "Requires a TEST argument after --"
+			fi
+			TEST="$1"
+			shift
+			;;
+		*)
+			if [ -n "${TEST+x}" ] ; then
+				usage_and_die "Unknown argument \"$A\""
+			fi
+			TEST="$A"
+			;;
+	esac
+done
+
+if [ -z "$TEST" ] ; then
+	usage_and_die "Missing test argument. See --help"
+fi
+
+if [ -z "${SRCDIR+x}" ] ; then
+	SRCDIR="$(readlink -f "$(dirname "$0")/..")"
+fi
+if [ ! -d "$SRCDIR" ] ; then
+	die "Invalid \$SRCDIR=\"$SRCDIR\""
+fi
+
+if [ -z "${BUILDDIR+x}" ] ; then
+	re='^(.*/|)(tests/unit/test-[^/]*)$'
+	if [[ "$TEST" =~ $re ]] ; then
+		BUILDDIR="$(readlink -f "${BASH_REMATCH[1]:-.}")" || :
+	else
+		BUILDDIR="$SRCDIR"
+	fi
+fi
+if [ ! -d "$BUILDDIR" ] ; then
+	die "Invalid \$BUILDDIR=\"$BUILDDIR\""
+fi
+
+export TESTDIR="$(dirname "$TEST")"
+export SRCDIR
+export BUILDDIR
+
+if [ "$VALGRIND" = y ] ; then
+	export NFT_TEST_UNDER_VALGRIND=1
+fi
+
+run_unit() {
+	local TEST="$1"
+
+	if [ "$NFT_TEST_MAKE" = y ] ; then
+		local d="$(readlink -f "$BUILDDIR")"
+		local tf="$(readlink -f "$TEST")"
+		local t="${tf#$d/}"
+
+		if [ "$tf" != "$d/$t" ] ; then
+			die "Cannot detect paths for making \"$TEST\" in \"$BUILDDIR\" (\"$d\" and \"$t\")"
+		fi
+		# Don't use "make -C" to avoid the extra "Entering/Leaving directory" messages
+		(cd "$d" && make "$t" ) || die "Making \"$TEST\" failed"
+	fi
+
+	if [ "$VALGRIND" != y ] ; then
+		rc_test=0
+		$NFT_TEST_UNSHARE_CMD \
+			libtool \
+			--mode=execute \
+			$NFT_TEST_WRAPPER \
+			"$TEST" || rc_test=$?
+		if [ "$rc_test" -ne 0 -a "$rc_test" -ne 77 ] ; then
+			die "exec \"$TEST\" failed with exit code $rc_test"
+		fi
+		exit "$rc_test"
+	fi
+
+	LOGFILE="$TEST.valgrind-log"
+
+	rc_test=0
+	$NFT_TEST_UNSHARE_CMD \
+		libtool \
+		--mode=execute \
+		valgrind \
+		--quiet \
+		--error-exitcode=122 \
+		--leak-check=full \
+		--gen-suppressions=all \
+		--num-callers=100 \
+		--log-file="$LOGFILE" \
+		--vgdb-prefix="${TMP:-/tmp}/vgdb-pipe-nft-test-runner-$TIMESTAMP-$$" \
+		$NFT_TEST_VALGRIND_OPTS \
+		"$TEST" \
+		|| rc_test=$?
+
+	if [ -s "$LOGFILE" ] ; then
+		if [ "$rc_test" -eq 0 -o "$rc_test" -eq 122 ] ; then
+			echo "valgrind failed. Logfile at \"$LOGFILE\" :"
+			cat "$LOGFILE"
+			rc_test=122
+		else
+			echo "valgrind also failed. Check logfile at \"$LOGFILE\""
+		fi
+	elif [ ! -f "$LOGFILE" ] ; then
+		echo "valgrind logfile \"$LOGFILE\" missing"
+		if [ "$rc_test" -eq 0 ] ; then
+			rc_test=122
+		fi
+	else
+		rm -rf "$LOGFILE"
+	fi
+
+	exit "$rc_test"
+}
+
+case "$TEST" in
+	tests/unit/test-* | \
+	*/tests/unit/test-* )
+		run_unit "$TEST"
+		;;
+	*)
+		die "Unrecognized test \"$TEST\""
+		;;
+esac
-- 
2.41.0

