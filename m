Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39936C83F3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350745AbjIEQ1Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354500AbjIEMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD55CDE
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 05:00:01 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-cIuazjV0NdadyRPYn3g1AA-1; Tue, 05 Sep 2023 07:59:59 -0400
X-MC-Unique: cIuazjV0NdadyRPYn3g1AA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B792E928A41
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18E0F1121314;
        Tue,  5 Sep 2023 11:59:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 15/17] tests/shell: skip test in rootless that hit socket buffer size limit
Date:   Tue,  5 Sep 2023 13:58:44 +0200
Message-ID: <20230905115936.607599-16-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The socket buffer limits like /proc/sys/net/core/{rmem_max,wmem_max}
can cause tests to fail, when running rootless. That's because real-root
can override those limits, rootless cannot.

Add an environment variable NFT_TEST_HAS_SOCKET_LIMITS=*|n which is
automatically set by "run-tests.sh".

Certain tests will check for [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] and
skip the test.

The user may manually bump those limits (requires root), and set
NFT_TEST_HAS_SOCKET_LIMITS=n to get the tests to pass even as rootless.

For example, the test passes with root:

  sudo ./tests/shell/run-tests.sh -- tests/shell/testcases/sets/automerge_0

Without root, it would fail. Skip it instead:

  ./tests/shell/run-tests.sh -- tests/shell/testcases/sets/automerge_0
  ...
  I: [SKIPPED]    tests/shell/testcases/sets/automerge_0

Or bump the limit:

  $ echo 3000000 | sudo tee /proc/sys/net/core/wmem_max
  $ NFT_TEST_HAS_SOCKET_LIMITS=n ./tests/shell/run-tests.sh -- tests/shell/testcases/sets/automerge_0
  ...
  I: [OK]         tests/shell/testcases/sets/automerge_0

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh                      | 35 +++++++++++++++++++
 tests/shell/testcases/nft-f/0011manydefines_0 | 16 +++++++++
 .../testcases/sets/0011add_many_elements_0    | 15 ++++++++
 .../sets/0012add_delete_many_elements_0       | 14 ++++++++
 .../sets/0013add_delete_many_elements_0       | 14 ++++++++
 tests/shell/testcases/sets/automerge_0        | 24 ++++++++++---
 tests/shell/testcases/transactions/30s-stress |  9 +++++
 7 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 8564d9a08bcb..d2ed1886c3fe 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -28,6 +28,24 @@ msg_info() {
 	_msg I "$@"
 }
 
+bool_n() {
+	case "$1" in
+		n|N|no|No|NO|0|false)
+			printf n
+			;;
+		'')
+			if [ $# -ge 2 ] ; then
+				printf "%s" "$2"
+			else
+				printf n
+			fi
+			;;
+		*)
+			printf y
+			;;
+	esac
+}
+
 bool_y() {
 	case "$1" in
 		y|Y|yes|Yes|YES|1|true)
@@ -77,6 +95,11 @@ usage() {
 	echo "                 e.g. due to limited /proc/sys/net/core/{wmem_max,rmem_max}."
 	echo "                 Checks that cannot pass in such environment should check for"
 	echo "                 [ \"\$NFT_TEST_HAS_REALROOT\" != y ] and skip gracefully."
+	echo " NFT_TEST_HAS_SOCKET_LIMITS=*|n : some tests will fail if /proc/sys/net/core/{wmem_max,rmem_max} is"
+	echo "                 too small. When running as real root, then those limits can be overridden but"
+	echo "                 rootless, the test would fail. Tests will check for [ "\$NFT_TEST_HAS_SOCKET_LIMITS" = y ]"
+	echo "                 and skip. You may set NFT_TEST_HAS_SOCKET_LIMITS=n if you ensure those limits are"
+	echo "                 suitable to run the test rootless."
 	echo " NFT_TEST_UNSHARE_CMD=cmd : when set, this is the command line for an unshare"
 	echo "                 command, which is used to sandbox each test invocation. By"
 	echo "                 setting it to empty, no unsharing is done."
@@ -202,6 +225,17 @@ else
 fi
 export NFT_TEST_HAS_REALROOT
 
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = "" ] ; then
+	if [ "$NFT_TEST_HAS_REALROOT" = y ] ; then
+		NFT_TEST_HAS_SOCKET_LIMITS=n
+	else
+		NFT_TEST_HAS_SOCKET_LIMITS=y
+	fi
+else
+	NFT_TEST_HAS_SOCKET_LIMITS="$(bool_n "$NFT_TEST_HAS_SOCKET_LIMITS")"
+fi
+export NFT_TEST_HAS_SOCKET_LIMITS
+
 detect_unshare() {
 	if ! $1 true &>/dev/null ; then
 		return 1
@@ -295,6 +329,7 @@ msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
 msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
+msg_info "conf: NFT_TEST_HAS_SOCKET_LIMITS=$(printf '%q' "$NFT_TEST_HAS_SOCKET_LIMITS")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
diff --git a/tests/shell/testcases/nft-f/0011manydefines_0 b/tests/shell/testcases/nft-f/0011manydefines_0
index 84664f46af50..aac0670602f6 100755
--- a/tests/shell/testcases/nft-f/0011manydefines_0
+++ b/tests/shell/testcases/nft-f/0011manydefines_0
@@ -4,6 +4,15 @@
 
 HOWMANY=20000
 
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=2000
+fi
+
+
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
@@ -35,3 +44,10 @@ table t {
 
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" != 20000 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKIPPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=n\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0011add_many_elements_0 b/tests/shell/testcases/sets/0011add_many_elements_0
index ba23f90f2328..c37b2f0dfa2e 100755
--- a/tests/shell/testcases/sets/0011add_many_elements_0
+++ b/tests/shell/testcases/sets/0011add_many_elements_0
@@ -3,6 +3,14 @@
 # test adding many sets elements
 
 HOWMANY=255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=30
+fi
+
 
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -30,3 +38,10 @@ add element x y $(generate)" > $tmpfile
 
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" != 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKIPPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=n\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0012add_delete_many_elements_0 b/tests/shell/testcases/sets/0012add_delete_many_elements_0
index 7e7beebd2073..64451604c3d1 100755
--- a/tests/shell/testcases/sets/0012add_delete_many_elements_0
+++ b/tests/shell/testcases/sets/0012add_delete_many_elements_0
@@ -3,6 +3,13 @@
 # test adding and deleting many sets elements
 
 HOWMANY=255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=30
+fi
 
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -31,3 +38,10 @@ delete element x y $(generate)" > $tmpfile
 
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" != 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKIPPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=n\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0013add_delete_many_elements_0 b/tests/shell/testcases/sets/0013add_delete_many_elements_0
index 5774317b6b63..c0925dd57b47 100755
--- a/tests/shell/testcases/sets/0013add_delete_many_elements_0
+++ b/tests/shell/testcases/sets/0013add_delete_many_elements_0
@@ -3,6 +3,13 @@
 # test adding and deleting many sets elements in two nft -f runs.
 
 HOWMANY=255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=30
+fi
 
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -32,3 +39,10 @@ add element x y $(generate)" > $tmpfile
 $NFT -f $tmpfile
 echo "delete element x y $(generate)" > $tmpfile
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" != 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKIPPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=n\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/automerge_0 b/tests/shell/testcases/sets/automerge_0
index 7530b3db7317..fc34f8865fb3 100755
--- a/tests/shell/testcases/sets/automerge_0
+++ b/tests/shell/testcases/sets/automerge_0
@@ -10,14 +10,23 @@ RULESET="table inet x {
 	}
 }"
 
+HOWMANY=65535
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=5000
+fi
+
 $NFT -f - <<< $RULESET
 
 tmpfile=$(mktemp)
 echo -n "add element inet x y { " > $tmpfile
-for ((i=0;i<65535;i+=2))
+for ((i=0;i<$HOWMANY;i+=2))
 do
 	echo -n "$i, " >> $tmpfile
-	if [ $i -eq 65534 ]
+	if [ $i -eq $((HOWMANY-1)) ]
 	then
 		echo -n "$i" >> $tmpfile
 	fi
@@ -27,7 +36,7 @@ echo "}" >> $tmpfile
 $NFT -f $tmpfile
 
 tmpfile2=$(mktemp)
-for ((i=1;i<65535;i+=2))
+for ((i=1;i<$HOWMANY;i+=2))
 do
 	echo "$i" >> $tmpfile2
 done
@@ -48,7 +57,7 @@ done
 
 for ((i=0;i<10;i++))
 do
-	from=$(($RANDOM%65535))
+	from=$(($RANDOM%$HOWMANY))
 	to=$(($from+100))
 	$NFT add element inet x y { $from-$to }
 	if [ $? -ne 0 ]
@@ -111,3 +120,10 @@ done
 rm -f $tmpfile
 rm -f $tmpfile2
 rm -f $tmpfile3
+
+if [ "$HOWMANY" != 65535 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKIPPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=n\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index 4d3317e22b0c..757e7639b5e9 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -16,6 +16,15 @@ if [ x = x"$NFT" ] ; then
 	NFT=nft
 fi
 
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Skip it. You may ensure that the limits are suitable and rerun
+	# with NFT_TEST_HAS_SOCKET_LIMITS=n.
+	exit 77
+fi
+
 testns=testns-$(mktemp -u "XXXXXXXX")
 tmp=""
 
-- 
2.41.0

