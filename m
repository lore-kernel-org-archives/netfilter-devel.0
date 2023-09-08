Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9245EEE8014
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 15:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbjIHPOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 11:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244381AbjIHPOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 11:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA491BF9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 08:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694186020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=osOmKtKEC/Mi81cX54JRbdQf5uTi8WxzwgWrkDcd5g0=;
        b=AGFrAGsmIrJbfDuYGKZdRwVWGY0x8KpPuOA9GvR1i4bnGbEHw5s17BmD8ZJ1aQq9G9C4go
        d7rH/0psks0ulmPvZP4TvQy+Am5nAfZ+Y60WV0ucDKkJSNVCslqead9NUJmw/iMJeqhJYy
        MjILrMWZyA7R8s84lklpXxp/0d1aGMQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-dFu8RdOSPrKHpMH3c61yeA-1; Fri, 08 Sep 2023 11:13:37 -0400
X-MC-Unique: dFu8RdOSPrKHpMH3c61yeA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14FE2181C288;
        Fri,  8 Sep 2023 15:13:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 612E1493110;
        Fri,  8 Sep 2023 15:13:36 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: add "--quick" option to skip slow tests (via NFT_TEST_SKIP_slow=y)
Date:   Fri,  8 Sep 2023 17:07:25 +0200
Message-ID: <20230908151323.1161159-3-thaller@redhat.com>
In-Reply-To: <20230908151323.1161159-1-thaller@redhat.com>
References: <20230908151323.1161159-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's important to run (a part) of the tests in a timely manner.
Add an option to skip long running tests.

Thereby, add a more general NFT_TEST_SKIP_* mechanism.

This is related and inverse from "NFT_TEST_HAVE_json", where a test
can require [ "$NFT_TEST_HAVE_json" != n ] to run, but is skipped when
[ "$NFT_TEST_SKIP_slow" = y ].

Currently only NFT_TEST_SKIP_slow is supported. The user can set such
environment variables (or use the -Q|--quick command line option). The
configuration is printed in the test info.

Tests should check for [ "$NFT_TEST_SKIP_slow" = y ] so that the
variable has to be explicitly set to opt-out. For convenience, tests can
also add a

    # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)

tag, which is evaluated by test-wrapper.sh. Or they can run a quick, reduced
part of the test, but then should still indicate to be skipped.

Mark 8 tests are as slow, that take longer than 5 seconds on my machine.
With this, a parallel wall time for the non-slow tests is only 7 seconds
(on my machine).

The ultimate point is to integrate a call to "tests/shell/run-tests.sh"
in a `make check` target. For development, you can then export
NFT_TEST_SKIP_slow=y and have a fast `make check`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh           | 40 +++++++++++++------
 tests/shell/run-tests.sh                      | 18 +++++++++
 .../maps/0004interval_map_create_once_0       |  8 ++++
 .../testcases/maps/0018map_leak_timeout_0     |  2 +
 tests/shell/testcases/maps/vmap_timeout       |  2 +
 .../testcases/sets/0043concatenated_ranges_0  |  2 +
 .../testcases/sets/0044interval_overlap_0     |  2 +
 .../testcases/sets/0044interval_overlap_1     |  2 +
 tests/shell/testcases/sets/automerge_0        |  2 +
 tests/shell/testcases/transactions/30s-stress |  2 +
 10 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index a91baf743d9a..778c537e0ce2 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -54,23 +54,39 @@ TEST_TAGS_PARSED=0
 ensure_TEST_TAGS() {
 	if [ "$TEST_TAGS_PARSED" = 0 ] ; then
 		TEST_TAGS_PARSED=1
-		TEST_TAGS=( $(sed -n '1,10 { s/^.*\<\(NFT_TEST_REQUIRES\)\>\s*(\s*\(NFT_TEST_HAVE_[a-zA-Z0-9_]\+\)\s*).*$/\1(\2)/p }' "$1" 2>/dev/null || : ) )
+		TEST_TAGS=( $(sed -n '1,10 { s/^.*\<\(NFT_TEST_REQUIRES\|NFT_TEST_SKIP\)\>\s*(\s*\(NFT_TEST_SKIP_[a-zA-Z0-9_]\+\|NFT_TEST_HAVE_[a-zA-Z0-9_]\+\)\s*).*$/\1(\2)/p }' "$1" 2>/dev/null || : ) )
 	fi
 }
 
 rc_test=0
 
-for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_') ; do
-	if [ "${!KEY}" != n ]; then
-		continue
-	fi
-	ensure_TEST_TAGS "$TEST"
-	if array_contains "NFT_TEST_REQUIRES($KEY)" "${TEST_TAGS[@]}" ; then
-		echo "Test skipped due to $KEY=n (test has \"NFT_TEST_REQUIRES($KEY)\" tag)" >> "$NFT_TEST_TESTTMPDIR/testout.log"
-		rc_test=77
-		break
-	fi
-done
+if [ "$rc_test" -eq 0 ] ; then
+	for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_') ; do
+		if [ "${!KEY}" != n ]; then
+			continue
+		fi
+		ensure_TEST_TAGS "$TEST"
+		if array_contains "NFT_TEST_REQUIRES($KEY)" "${TEST_TAGS[@]}" ; then
+			echo "Test skipped due to $KEY=n (test has \"NFT_TEST_REQUIRES($KEY)\" tag)" >> "$NFT_TEST_TESTTMPDIR/testout.log"
+			rc_test=77
+			break
+		fi
+	done
+fi
+
+if [ "$rc_test" -eq 0 ] ; then
+	for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_') ; do
+		if [ "${!KEY}" != y ]; then
+			continue
+		fi
+		ensure_TEST_TAGS "$TEST"
+		if array_contains "NFT_TEST_SKIP($KEY)" "${TEST_TAGS[@]}" ; then
+			echo "Test skipped due to $KEY=y (test has \"NFT_TEST_SKIP($KEY)\" tag)" >> "$NFT_TEST_TESTTMPDIR/testout.log"
+			rc_test=77
+			break
+		fi
+	done
+fi
 
 if [ "$rc_test" -eq 0 ] ; then
 	"$TEST" &>> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index e3ab9e744fe4..4f1938628937 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -118,6 +118,7 @@ usage() {
 	echo " -U|--no-unshare : Sets NFT_TEST_UNSHARE_CMD=\"\"."
 	echo " -k|--keep-logs  : Sets NFT_TEST_KEEP_LOGS=y."
 	echo " -s|--sequential : Sets NFT_TEST_JOBS=0, which also enables global cleanups."
+	echo " -Q|--quick      : Sets NFT_TEST_SKIP_slow=y."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
 	echo "                   that is, executables that are run by the runner."
@@ -174,6 +175,8 @@ usage() {
 	echo " NFT_TEST_HAVE_<FEATURE>=*|y: Some tests requires certain features or will be skipped."
 	echo "                 The features are autodetected, but you can force it by setting the variable."
 	echo "                 Supported <FEATURE>s are: ${_HAVE_OPTS[@]}."
+	echo " NFT_TEST_SKIP_<OPTION>=*|y: if set, certain tests are skipped."
+	echo "                 Supported <OPTION>s are: ${_SKIP_OPTS[@]}."
 }
 
 NFT_TEST_BASEDIR="$(dirname "$0")"
@@ -188,6 +191,13 @@ for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
 	fi
 done
 
+_SKIP_OPTS=( slow )
+for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
+	if ! array_contains "${KEY#NFT_TEST_SKIP_}" "${_SKIP_OPTS[@]}" ; then
+		unset "$KEY"
+	fi
+done
+
 _NFT_TEST_JOBS_DEFAULT="$(nproc)"
 [ "$_NFT_TEST_JOBS_DEFAULT" -gt 0 ] 2>/dev/null || _NFT_TEST_JOBS_DEFAULT=1
 _NFT_TEST_JOBS_DEFAULT="$(( _NFT_TEST_JOBS_DEFAULT + (_NFT_TEST_JOBS_DEFAULT + 1) / 2 ))"
@@ -199,6 +209,7 @@ KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_JOBS="${NFT_TEST_JOBS:-$_NFT_TEST_JOBS_DEFAULT}"
+NFT_TEST_SKIP_slow="$(bool_y "$NFT_TEST_SKIP_slow")"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -238,6 +249,9 @@ while [ $# -gt 0 ] ; do
 		-s|--sequential)
 			NFT_TEST_JOBS=0
 			;;
+		-Q|--quick)
+			NFT_TEST_SKIP_slow=y
+			;;
 		--)
 			TESTS+=( "$@" )
 			shift $#
@@ -433,6 +447,10 @@ msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 echo
+for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
+	msg_info "conf: $KEY=$(printf '%q' "${!KEY}")"
+	export "$KEY"
+done
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
 	msg_info "conf: $KEY=$(printf '%q' "${!KEY}")"
 	export "$KEY"
diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
index 3de0c9de4f93..64f434ad6b00 100755
--- a/tests/shell/testcases/maps/0004interval_map_create_once_0
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -5,6 +5,10 @@
 
 HOWMANY=63
 
+if [ "$NFT_TEST_SKIP_slow" = y ] ; then
+	HOWMANY=5
+fi
+
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
@@ -64,3 +68,7 @@ if [ "$EXPECTED" != "$GET" ] ; then
 	exit 1
 fi
 
+if [ "$HOWMANY" != 63 ] ; then
+	echo "Run a partial test due to NFT_TEST_SKIP_slow=y. Skip"
+	exit 77
+fi
diff --git a/tests/shell/testcases/maps/0018map_leak_timeout_0 b/tests/shell/testcases/maps/0018map_leak_timeout_0
index 5a07ec7477d9..09db315a8855 100755
--- a/tests/shell/testcases/maps/0018map_leak_timeout_0
+++ b/tests/shell/testcases/maps/0018map_leak_timeout_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+
 set -e
 
 RULESET="table ip t {
diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index e59d37ab4048..43d031979cb3 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+
 set -e
 
 dumpfile=$(dirname $0)/dumps/$(basename $0).nft
diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 90ee6a82dbed..4165b2f5f711 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 #
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+#
 # 0043concatenated_ranges_0 - Add, get, list, timeout for concatenated ranges
 #
 # Cycle over supported data types, forming concatenations of three fields, for
diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
index face90f2e9ae..19aa6f5ed081 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_0
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 #
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+#
 # 0044interval_overlap_0 - Add overlapping and non-overlapping intervals
 #
 # Check that adding overlapping intervals to a set returns an error, unless:
diff --git a/tests/shell/testcases/sets/0044interval_overlap_1 b/tests/shell/testcases/sets/0044interval_overlap_1
index eeea1943ee55..905e6d5a0348 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_1
+++ b/tests/shell/testcases/sets/0044interval_overlap_1
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 #
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+#
 # 0044interval_overlap_1 - Single-sized intervals can never overlap partially
 #
 # Check that inserting, deleting, and inserting single-sized intervals again
diff --git a/tests/shell/testcases/sets/automerge_0 b/tests/shell/testcases/sets/automerge_0
index fc34f8865fb3..170c38651de0 100755
--- a/tests/shell/testcases/sets/automerge_0
+++ b/tests/shell/testcases/sets/automerge_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+
 set -e
 
 RULESET="table inet x {
diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index 757e7639b5e9..4d5d1d8bface 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+
 runtime=30
 
 # allow stand-alone execution as well, e.g. '$0 3600'
-- 
2.41.0

