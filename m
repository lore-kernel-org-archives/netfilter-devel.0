Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA0DEB8FBD
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbjIFMCz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE5D1731
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jI9JXEcB+5GmzcBzpintljhgkYSk0p3+jo6nIAk4twk=;
        b=Sc1JXwvFZPRi1IROCWBEUil1HsFsR5jFtywEsB5F0L+H/9maAOewL+vwPfmDrncHTHGypJ
        54rXYalHamzLl0VW2GkGCF+TOFwOIcQ5VMjdgVha4c7Fg8c0CmzQQFHqKkVFUoWGZec+RJ
        q4f2ix7O04eUCoaErDz8GGYs5/UBNds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-29yNV0J_PxCwWSy5AfzA0g-1; Wed, 06 Sep 2023 08:01:33 -0400
X-MC-Unique: 29yNV0J_PxCwWSy5AfzA0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2D97805BFB
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03BE6C15BB8;
        Wed,  6 Sep 2023 12:01:31 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 16/19] tests/shell: skip test in rootless that hit socket buffer size limit
Date:   Wed,  6 Sep 2023 13:52:19 +0200
Message-ID: <20230906120109.1773860-17-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The socket buffer limits like /proc/sys/net/core/{rmem_max,wmem_max}
can cause tests to fail, when running rootless. That's because real-root
can override those limits, rootless cannot.

Add an environment variable NFT_TEST_HAS_SOCKET_LIMITS=3D*|n which is
automatically set by "run-tests.sh".

Certain tests will check for [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] and
skip the test.

The user may manually bump those limits (requires root), and set
NFT_TEST_HAS_SOCKET_LIMITS=3Dn to get the tests to pass even as rootless.

For example, the test passes with root:

  sudo ./tests/shell/run-tests.sh -- tests/shell/testcases/sets/automerge_0

Without root, it would fail. Skip it instead:

  ./tests/shell/run-tests.sh -- tests/shell/testcases/sets/automerge_0
  ...
  I: [SKIPPED]    tests/shell/testcases/sets/automerge_0

Or bump the limit:

  $ echo 3000000 | sudo tee /proc/sys/net/core/wmem_max
  $ NFT_TEST_HAS_SOCKET_LIMITS=3Dn ./tests/shell/run-tests.sh -- tests/shel=
l/testcases/sets/automerge_0
  ...
  I: [OK]         tests/shell/testcases/sets/automerge_0

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh                      | 32 +++++++++++++++++++
 tests/shell/testcases/nft-f/0011manydefines_0 | 16 ++++++++++
 .../testcases/sets/0011add_many_elements_0    | 15 +++++++++
 .../sets/0012add_delete_many_elements_0       | 14 ++++++++
 .../sets/0013add_delete_many_elements_0       | 14 ++++++++
 .../sets/0030add_many_elements_interval_0     | 14 ++++++++
 .../sets/0068interval_stack_overflow_0        | 18 ++++++++++-
 tests/shell/testcases/sets/automerge_0        | 24 +++++++++++---
 tests/shell/testcases/transactions/0049huge_0 | 16 ++++++++++
 tests/shell/testcases/transactions/30s-stress |  9 ++++++
 10 files changed, 167 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 97c82991befd..423c5465c4d4 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -28,6 +28,17 @@ msg_info() {
 	_msg I "$@"
 }
=20
+bool_n() {
+	case "$1" in
+		n|N|no|No|NO|0|false|False|FALSE)
+			printf n
+			;;
+		*)
+			printf y
+			;;
+	esac
+}
+
 bool_y() {
 	case "$1" in
 		y|Y|yes|Yes|YES|1|true|True|TRUE)
@@ -78,6 +89,12 @@ usage() {
 	echo "                 e.g. due to limited /proc/sys/net/core/{wmem_max,r=
mem_max}."
 	echo "                 Checks that cannot pass in such environment should=
 check for"
 	echo "                 [ \"\$NFT_TEST_HAS_REALROOT\" !=3D y ] and skip gr=
acefully."
+	echo " NFT_TEST_HAS_SOCKET_LIMITS=3D*|n : some tests will fail if /proc/s=
ys/net/core/{wmem_max,rmem_max} is"
+	echo "                 too small. When running as real root, then test ca=
n override those limits. However,"
+	echo "                 with rootless the test would fail. Tests will chec=
k for [ "\$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ]"
+	echo "                 and skip. You may set NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn if you ensure those limits are"
+	echo "                 suitable to run the test rootless. Otherwise will =
be autodetected."
+	echo "                 Set /proc/sys/net/core/{wmem_max,rmem_max} to at l=
east 2MB to get them to pass automatically."
 	echo " NFT_TEST_UNSHARE_CMD=3Dcmd : when set, this is the command line fo=
r an unshare"
 	echo "                 command, which is used to sandbox each test invoca=
tion. By"
 	echo "                 setting it to empty, no unsharing is done."
@@ -202,6 +219,20 @@ else
 fi
 export NFT_TEST_HAS_REALROOT
=20
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D "" ] ; then
+	if [ "$NFT_TEST_HAS_REALROOT" =3D y ] ; then
+		NFT_TEST_HAS_SOCKET_LIMITS=3Dn
+	elif [ "$(cat /proc/sys/net/core/wmem_max 2>/dev/null)" -ge $((2000*1024)=
) ] 2>/dev/null && \
+	     [ "$(cat /proc/sys/net/core/rmem_max 2>/dev/null)" -ge $((2000*1024)=
) ] 2>/dev/null ; then
+		NFT_TEST_HAS_SOCKET_LIMITS=3Dn
+	else
+		NFT_TEST_HAS_SOCKET_LIMITS=3Dy
+	fi
+else
+	NFT_TEST_HAS_SOCKET_LIMITS=3D"$(bool_n "$NFT_TEST_HAS_SOCKET_LIMITS")"
+fi
+export NFT_TEST_HAS_SOCKET_LIMITS
+
 detect_unshare() {
 	if ! $1 true &>/dev/null ; then
 		return 1
@@ -316,6 +347,7 @@ msg_info "conf: DUMPGEN=3D$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=3D$(printf '%q' "$VALGRIND")"
 msg_info "conf: KMEMLEAK=3D$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=3D$(printf '%q' "$NFT_TEST_HAS_REALR=
OOT")"
+msg_info "conf: NFT_TEST_HAS_SOCKET_LIMITS=3D$(printf '%q' "$NFT_TEST_HAS_=
SOCKET_LIMITS")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=3D$(printf '%q' "$NFT_TEST_UNSHARE_CM=
D")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=3D$(printf '%q' "$NFT_TEST_HAS_UNSHA=
RED")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=3D$(printf '%q' "$NFT_TEST_HAS=
_UNSHARED_MOUNT")"
diff --git a/tests/shell/testcases/nft-f/0011manydefines_0 b/tests/shell/te=
stcases/nft-f/0011manydefines_0
index 84664f46af50..aac0670602f6 100755
--- a/tests/shell/testcases/nft-f/0011manydefines_0
+++ b/tests/shell/testcases/nft-f/0011manydefines_0
@@ -4,6 +4,15 @@
=20
 HOWMANY=3D20000
=20
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D2000
+fi
+
+
 tmpfile=3D$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
@@ -35,3 +44,10 @@ table t {
=20
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" !=3D 20000 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0011add_many_elements_0 b/tests/she=
ll/testcases/sets/0011add_many_elements_0
index ba23f90f2328..c37b2f0dfa2e 100755
--- a/tests/shell/testcases/sets/0011add_many_elements_0
+++ b/tests/shell/testcases/sets/0011add_many_elements_0
@@ -3,6 +3,14 @@
 # test adding many sets elements
=20
 HOWMANY=3D255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D30
+fi
+
=20
 tmpfile=3D$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -30,3 +38,10 @@ add element x y $(generate)" > $tmpfile
=20
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" !=3D 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0012add_delete_many_elements_0 b/te=
sts/shell/testcases/sets/0012add_delete_many_elements_0
index 7e7beebd2073..64451604c3d1 100755
--- a/tests/shell/testcases/sets/0012add_delete_many_elements_0
+++ b/tests/shell/testcases/sets/0012add_delete_many_elements_0
@@ -3,6 +3,13 @@
 # test adding and deleting many sets elements
=20
 HOWMANY=3D255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D30
+fi
=20
 tmpfile=3D$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -31,3 +38,10 @@ delete element x y $(generate)" > $tmpfile
=20
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" !=3D 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0013add_delete_many_elements_0 b/te=
sts/shell/testcases/sets/0013add_delete_many_elements_0
index 5774317b6b63..c0925dd57b47 100755
--- a/tests/shell/testcases/sets/0013add_delete_many_elements_0
+++ b/tests/shell/testcases/sets/0013add_delete_many_elements_0
@@ -3,6 +3,13 @@
 # test adding and deleting many sets elements in two nft -f runs.
=20
 HOWMANY=3D255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D30
+fi
=20
 tmpfile=3D$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -32,3 +39,10 @@ add element x y $(generate)" > $tmpfile
 $NFT -f $tmpfile
 echo "delete element x y $(generate)" > $tmpfile
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" !=3D 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0030add_many_elements_interval_0 b/=
tests/shell/testcases/sets/0030add_many_elements_interval_0
index 059ade9aa30c..32a705bf2c81 100755
--- a/tests/shell/testcases/sets/0030add_many_elements_interval_0
+++ b/tests/shell/testcases/sets/0030add_many_elements_interval_0
@@ -1,6 +1,13 @@
 #!/bin/bash
=20
 HOWMANY=3D255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D30
+fi
=20
 tmpfile=3D$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -28,3 +35,10 @@ add element x y $(generate)" > $tmpfile
=20
 set -e
 $NFT -f $tmpfile
+
+if [ "$HOWMANY" !=3D 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0068interval_stack_overflow_0 b/tes=
ts/shell/testcases/sets/0068interval_stack_overflow_0
index 2cbc98680264..e61010c7e126 100755
--- a/tests/shell/testcases/sets/0068interval_stack_overflow_0
+++ b/tests/shell/testcases/sets/0068interval_stack_overflow_0
@@ -6,9 +6,18 @@ ruleset_file=3D$(mktemp)
=20
 trap 'rm -f "$ruleset_file"' EXIT
=20
+HOWMANY=3D255
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D30
+fi
+
 {
 	echo 'define big_set =3D {'
-	for ((i =3D 1; i < 255; i++)); do
+	for ((i =3D 1; i < $HOWMANY; i++)); do
 		for ((j =3D 1; j < 255; j++)); do
 			echo "10.0.$i.$j,"
 		done
@@ -27,3 +36,10 @@ table inet test68_table {
 EOF
=20
 ( ulimit -s 400 && $NFT -f "$ruleset_file" )
+
+if [ "$HOWMANY" !=3D 255 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/automerge_0 b/tests/shell/testcases=
/sets/automerge_0
index 7530b3db7317..fc34f8865fb3 100755
--- a/tests/shell/testcases/sets/automerge_0
+++ b/tests/shell/testcases/sets/automerge_0
@@ -10,14 +10,23 @@ RULESET=3D"table inet x {
 	}
 }"
=20
+HOWMANY=3D65535
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	HOWMANY=3D5000
+fi
+
 $NFT -f - <<< $RULESET
=20
 tmpfile=3D$(mktemp)
 echo -n "add element inet x y { " > $tmpfile
-for ((i=3D0;i<65535;i+=3D2))
+for ((i=3D0;i<$HOWMANY;i+=3D2))
 do
 	echo -n "$i, " >> $tmpfile
-	if [ $i -eq 65534 ]
+	if [ $i -eq $((HOWMANY-1)) ]
 	then
 		echo -n "$i" >> $tmpfile
 	fi
@@ -27,7 +36,7 @@ echo "}" >> $tmpfile
 $NFT -f $tmpfile
=20
 tmpfile2=3D$(mktemp)
-for ((i=3D1;i<65535;i+=3D2))
+for ((i=3D1;i<$HOWMANY;i+=3D2))
 do
 	echo "$i" >> $tmpfile2
 done
@@ -48,7 +57,7 @@ done
=20
 for ((i=3D0;i<10;i++))
 do
-	from=3D$(($RANDOM%65535))
+	from=3D$(($RANDOM%$HOWMANY))
 	to=3D$(($from+100))
 	$NFT add element inet x y { $from-$to }
 	if [ $? -ne 0 ]
@@ -111,3 +120,10 @@ done
 rm -f $tmpfile
 rm -f $tmpfile2
 rm -f $tmpfile3
+
+if [ "$HOWMANY" !=3D 65535 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/wmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/te=
stcases/transactions/0049huge_0
index 684d27a17b5a..1a3a75c7cdaa 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -7,6 +7,15 @@ $NFT add table inet test
 $NFT add chain inet test c
=20
 RULE_COUNT=3D3000
+
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/rmem_max may be unsuitable for
+	# the test.
+	#
+	# Run only a subset of the test and mark as skipped at the end.
+	RULE_COUNT=3D500
+fi
+
 RULESET=3D$(
 for ((i =3D 0; i < ${RULE_COUNT}; i++)); do
 	echo "add rule inet test c accept comment rule$i"
@@ -39,3 +48,10 @@ RULESET=3D'{"nftables": [{"metainfo": {"json_schema_vers=
ion": 1}}, {"add": {"table
 {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter=
_OUTPUT", "index": 0, "expr": [{"match": {"left": {"payload": {"protocol": =
"ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"set": [{"prefix": {"a=
ddr": "::0.0.0.0", "len": 96}}, {"prefix": {"addr": "::ffff:0.0.0.0", "len"=
: 96}}, {"prefix": {"addr": "2002:0000::", "len": 24}}, {"prefix": {"addr":=
 "2002:0a00::", "len": 24}}, {"prefix": {"addr": "2002:7f00::", "len": 24}}=
, {"prefix": {"addr": "2002:ac10::", "len": 28}}, {"prefix": {"addr": "2002=
:c0a8::", "len": 32}}, {"prefix": {"addr": "2002:a9fe::", "len": 32}}, {"pr=
efix": {"addr": "2002:e000::", "len": 19}}]}}}, {"reject": {"type": "icmpv6=
", "expr": "addr-unreachable"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FORWARD", "index": 2, "expr": [{"match=
": {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=
=3D", "right": {"set": [{"prefix": {"addr": "::0.0.0.0", "len": 96}}, {"pre=
fix": {"addr": "::ffff:0.0.0.0", "len": 96}}, {"prefix": {"addr": "2002:000=
0::", "len": 24}}, {"prefix": {"addr": "2002:0a00::", "len": 24}}, {"prefix=
": {"addr": "2002:7f00::", "len": 24}}, {"prefix": {"addr": "2002:ac10::", =
"len": 28}}, {"prefix": {"addr": "2002:c0a8::", "len": 32}}, {"prefix": {"a=
ddr": "2002:a9fe::", "len": 32}}, {"prefix": {"addr": "2002:e000::", "len":=
 19}}]}}}, {"reject": {"type": "icmpv6", "expr": "addr-unreachable"}}]}}}, =
{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE=
_public"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "raw_PRE_public_pre"}}}, {"add": {"chain": {"family": "inet", "table":=
 "firewalld", "name": "raw_PRE_public_log"}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_public_deny"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_public_al=
low"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name":=
 "raw_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "fi=
rewalld", "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_=
public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_deny"}}]}=
}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw=
_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_allow"}}]}}}, {"=
add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_p=
ublic", "expr": [{"jump": {"target": "raw_PRE_public_post"}}]}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_IN_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "fir=
ewalld", "name": "filter_IN_public_log"}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_IN_public_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_IN_public_post"}}}, {"add": {"rule": {"family": "inet", "table": =
"firewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "fil=
ter_IN_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_=
IN_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_p=
ublic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_public=
_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_IN_public_allow", "expr": [{"match": {"left": {"payload": {"p=
rotocol": "tcp", "field": "dport"}}, "op": "=3D=3D", "right": 22}}, {"match=
": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", =
"untracked"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_IN_public_allow", "expr": [{"match":=
 {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=3D=
", "right": {"prefix": {"addr": "fe80::", "len": 64}}}}, {"match": {"left":=
 {"payload": {"protocol": "udp", "field": "dport"}}, "op": "=3D=3D", "right=
": 546}}, {"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right":=
 {"set": ["new", "untracked"]}}}, {"accept": null}]}}}, {"add": {"chain": {=
"family": "inet", "table": "firewalld", "name": "filter_FWDI_public"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDI_public_log"}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "filter_FWDI_public_deny"}}}, {"add": {"cha=
in": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDI_public_post"}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target":=
 "filter_FWDI_public_allow"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target=
": "filter_FWDI_public_post"}}]}}}, {"add": {"rule": {"family": "inet", "ta=
ble": "firewalld", "chain": "filter_IN_public", "index": 4, "expr": [{"matc=
h": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "right": {"set":=
 ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "=
inet", "table": "firewalld", "chain": "filter_FWDI_public", "index": 4, "ex=
pr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "rig=
ht": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": =
{"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "=
expr": [{"goto": {"target": "raw_PRE_public"}}]}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_public"}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_public_log"}}}, {"add": {"chain": {"family": "inet", "tabl=
e": "firewalld", "name": "mangle_PRE_public_deny"}}}, {"add": {"chain": {"f=
amily": "inet", "table": "firewalld", "name": "mangle_PRE_public_allow"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE=
_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_p=
ublic_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "=
chain": "mangle_PREROUTING_ZONES", "expr": [{"goto": {"target": "mangle_PRE=
_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_PRE_public"}}}, {"add": {"chain": {"family": "ip", "table": "fir=
ewalld", "name": "nat_PRE_public_pre"}}}, {"add": {"chain": {"family": "ip"=
, "table": "firewalld", "name": "nat_PRE_public_log"}}}, {"add": {"chain": =
{"family": "ip", "table": "firewalld", "name": "nat_PRE_public_deny"}}}, {"=
add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_pub=
lic_allow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "na=
me": "nat_PRE_public_post"}}}, {"add": {"rule": {"family": "ip", "table": "=
firewalld", "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PR=
E_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld"=
, "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE=
_public", "expr": [{"jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add"=
: {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_public"=
, "expr": [{"jump": {"target": "nat_PRE_public_post"}}]}}}, {"add": {"chain=
": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public"}}}, {"a=
dd": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "nam=
e": "nat_PRE_public_log"}}}, {"add": {"chain": {"family": "ip6", "table": "=
firewalld", "name": "nat_PRE_public_deny"}}}, {"add": {"chain": {"family": =
"ip6", "table": "firewalld", "name": "nat_PRE_public_allow"}}}, {"add": {"c=
hain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_pre"}}]}}}, {"a=
dd": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_pub=
lic", "expr": [{"jump": {"target": "nat_PRE_public_log"}}]}}}, {"add": {"ru=
le": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "ex=
pr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"=
jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add": {"rule": {"family":=
 "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"jump": =
{"target": "nat_PRE_public_post"}}]}}}, {"add": {"rule": {"family": "ip", "=
table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"t=
arget": "nat_PRE_public"}}]}}}, {"add": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"target":=
 "nat_PRE_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firew=
alld", "name": "nat_POST_public"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"fa=
mily": "ip", "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add"=
: {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_public=
_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name":=
 "nat_POST_public_allow"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "=
ip", "table": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"=
target": "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "f=
irewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_PO=
ST_public_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "c=
hain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_pos=
t"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name":=
 "nat_POST_public"}}}, {"add": {"chain": {"family": "ip6", "table": "firewa=
lld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"family": "ip6",=
 "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add": {"chain": =
{"family": "ip6", "table": "firewalld", "name": "nat_POST_public_deny"}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_public_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld"=
, "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "ip6", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "=
firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_P=
OST_public_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "=
chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_al=
low"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain=
": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_post"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_POSTROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, =
{"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST=
ROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, {"add=
": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT=
_ZONES", "expr": [{"goto": {"target": "filter_IN_public"}}]}}}, {"add": {"r=
ule": {"family": "inet", "table": "firewalld", "chain": "filter_FORWARD_IN_=
ZONES", "expr": [{"goto": {"target": "filter_FWDI_public"}}]}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_publi=
c"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "=
filter_FWDO_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDO_public_log"}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_FWDO_public_deny"}}}, {"ad=
d": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO=
_public_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDO_public_post"}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_pre"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_log"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_deny"}}]}}}, {"add": {"rule": {"family": "inet=
", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {=
"target": "filter_FWDO_public_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump":=
 {"target": "filter_FWDO_public_post"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{=
"goto": {"target": "filter_FWDO_public"}}]}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_trusted"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_pre"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw=
_PRE_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "raw_PRE_trusted_allow"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "ra=
w_PRE_trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_pre"}}]}}}, {=
"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_=
trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_log"}}]}}}, {"add":=
 {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_truste=
d", "expr": [{"jump": {"target": "raw_PRE_trusted_deny"}}]}}}, {"add": {"ru=
le": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "=
expr": [{"jump": {"target": "raw_PRE_trusted_allow"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "expr=
": [{"jump": {"target": "raw_PRE_trusted_post"}}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "e=
xpr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "ri=
ght": "perm_dummy2"}}, {"goto": {"target": "raw_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_tru=
sted"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "mangle_PRE_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table"=
: "firewalld", "name": "mangle_PRE_trusted_log"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_trusted_deny"}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_P=
RE_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "mangle_PRE_trusted_post"}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_pre"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_log"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_deny"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump"=
: {"target": "mangle_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jum=
p": {"target": "mangle_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"famil=
y": "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr=
": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right=
": "perm_dummy2"}}, {"goto": {"target": "mangle_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trusted"=
}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_=
PRE_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"f=
amily": "ip", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"a=
dd": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trus=
ted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"=
add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_tru=
sted", "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {=
"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", =
"expr": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule"=
: {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", "expr"=
: [{"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"add": {"chain": {"fa=
mily": "ip6", "table": "firewalld", "name": "nat_PRE_trusted"}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_p=
re"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip6", "table": "fire=
walld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "ip=
6", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"add": {"cha=
in": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}]}}}, {"=
add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_tr=
usted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"add": {=
"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted",=
 "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {"rule"=
: {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr=
": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr": [{=
"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "ip", "table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {"insert": {"r=
ule": {"family": "ip6", "table": "firewalld", "chain": "nat_PREROUTING_ZONE=
S", "expr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D=
", "right": "perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {=
"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_t=
rusted"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name"=
: "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"family": =
"ip", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add": {"c=
hain": {"family": "ip", "table": "firewalld", "name": "nat_POST_trusted_all=
ow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_=
trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_deny=
"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "=
nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_allow"}}]=
}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_=
POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_post"}}]}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_trusted"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"famil=
y": "ip6", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add"=
: {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_trust=
ed_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "n=
at_POST_trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "fi=
rewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_PO=
ST_trusted_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_tr=
usted_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "c=
hain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_p=
ost"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewalld", "cha=
in": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"meta": {"key": =
"oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": {"target": =
"nat_POST_trusted"}}]}}}, {"insert": {"rule": {"family": "ip6", "table": "f=
irewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"=
meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"got=
o": {"target": "nat_POST_trusted"}}]}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_IN_trusted"}}}, {"add": {"chain": =
{"family": "inet", "table": "firewalld", "name": "filter_IN_trusted_pre"}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_IN_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_IN_trusted_deny"}}}, {"add": {"chain": {"family": "in=
et", "table": "firewalld", "name": "filter_IN_trusted_allow"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_trusted=
_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_pre=
"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain":=
 "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_log"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_deny"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_allow"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_post"}}]=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "fi=
lter_IN_trusted", "expr": [{"accept": null}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "filter_IN_trusted"}}]}}}, {"add": {"ch=
ain": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_trusted=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_FWDI_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDI_trusted_log"}}}, {"add": {"chain": {"famil=
y": "inet", "table": "firewalld", "name": "filter_FWDI_trusted_deny"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_FWDI_trusted_post"}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"jump=
": {"target": "filter_FWDI_trusted_pre"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"ju=
mp": {"target": "filter_FWDI_trusted_log"}}]}}}, {"add": {"rule": {"family"=
: "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"=
jump": {"target": "filter_FWDI_trusted_deny"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": =
[{"jump": {"target": "filter_FWDI_trusted_allow"}}]}}}, {"add": {"rule": {"=
family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "exp=
r": [{"jump": {"target": "filter_FWDI_trusted_post"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "=
expr": [{"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"le=
ft": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}=
, {"goto": {"target": "filter_FWDI_trusted"}}]}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "filter_FWDO_trusted"}}}, {"add"=
: {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_t=
rusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", =
"name": "filter_FWDO_trusted_log"}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "filter_FWDO_trusted_deny"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_trusted_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDO_trusted_post"}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"target"=
: "filter_FWDO_trusted_pre"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"targe=
t": "filter_FWDO_trusted_log"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"tar=
get": "filter_FWDO_trusted_deny"}}]}}}, {"add": {"rule": {"family": "inet",=
 "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"=
target": "filter_FWDO_trusted_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump"=
: {"target": "filter_FWDO_trusted_post"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"ac=
cept": null}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{"match": {"left": {"meta=
": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": =
{"target": "filter_FWDO_trusted"}}]}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "raw_PRE_work"}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "raw_PRE_work_pre"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_work_log=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "r=
aw_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_work_allow"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "raw_PRE_work_post"}}}, {"add": {"rule": {"f=
amily": "inet", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"j=
ump": {"target": "raw_PRE_work_pre"}}]}}}, {"add": {"rule": {"family": "ine=
t", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"targ=
et": "raw_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PR=
E_work_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_allo=
w"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_post"}}]}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_I=
N_work"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "nam=
e": "filter_IN_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": =
"firewalld", "name": "filter_IN_work_log"}}}, {"add": {"chain": {"family": =
"inet", "table": "firewalld", "name": "filter_IN_work_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_work_all=
ow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": =
"filter_IN_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN=
_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_lo=
g"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_deny"}}]}}=
}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filt=
er_IN_work", "expr": [{"jump": {"target": "filter_IN_work_allow"}}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_=
work", "expr": [{"jump": {"target": "filter_IN_work_post"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work_al=
low", "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": =
"dport"}}, "op": "=3D=3D", "right": 22}}, {"match": {"left": {"ct": {"key":=
 "state"}}, "op": "in", "right": {"set": ["new", "untracked"]}}}, {"accept"=
: null}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "cha=
in": "filter_IN_work_allow", "expr": [{"match": {"left": {"payload": {"prot=
ocol": "ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"prefix": {"add=
r": "fe80::", "len": 64}}}}, {"match": {"left": {"payload": {"protocol": "u=
dp", "field": "dport"}}, "op": "=3D=3D", "right": 546}}, {"match": {"left":=
 {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", "untracked"=
]}}}, {"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "raw_PRE_work"}}]}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "mangle_PRE_work"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_pre"}}}, {"add=
": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_w=
ork_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table=
": "firewalld", "name": "mangle_PRE_work_allow"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_post"}}}, {"ad=
d": {"rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_=
work", "expr": [{"jump": {"target": "mangle_PRE_work_pre"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work",=
 "expr": [{"jump": {"target": "mangle_PRE_work_log"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr=
": [{"jump": {"target": "mangle_PRE_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{=
"jump": {"target": "mangle_PRE_work_allow"}}]}}}, {"add": {"rule": {"family=
": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{"jum=
p": {"target": "mangle_PRE_work_post"}}]}}}, {"insert": {"rule": {"family":=
 "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr": =
[{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": =
"perm_dummy"}}, {"goto": {"target": "mangle_PRE_work"}}]}}}, {"add": {"chai=
n": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work"}}}, {"add=
": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work_p=
re"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_PRE_work_log"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"family": "ip", "tabl=
e": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": {"chain": {"famil=
y": "ip", "table": "firewalld", "name": "nat_PRE_work_post"}}}, {"add": {"r=
ule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr=
": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add": {"rule": {"family=
": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {=
"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "tabl=
e": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat=
_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_all=
ow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_post"}}]}}}, {"=
add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_wo=
rk"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewal=
ld", "name": "nat_PRE_work_log"}}}, {"add": {"chain": {"family": "ip6", "ta=
ble": "firewalld", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"fami=
ly": "ip6", "table": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": =
{"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_work_pos=
t"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "n=
at_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add"=
: {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_work",=
 "expr": [{"jump": {"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"=
family": "ip6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"j=
ump": {"target": "nat_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip=
6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"targ=
et": "nat_PRE_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_P=
RE_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": {"meta": =
{"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"ta=
rget": "nat_PRE_work"}}]}}}, {"insert": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "nat_PRE_work"}}]}}}, {"add": {"chain": {"family": "ip", "t=
able": "firewalld", "name": "nat_POST_work"}}}, {"add": {"chain": {"family"=
: "ip", "table": "firewalld", "name": "nat_POST_work_pre"}}}, {"add": {"cha=
in": {"family": "ip", "table": "firewalld", "name": "nat_POST_work_log"}}},=
 {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST=
_work_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_POST_work_allow"}}}, {"add": {"chain": {"family": "ip", "table":=
 "firewalld", "name": "nat_POST_work_post"}}}, {"add": {"rule": {"family": =
"ip", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"t=
arget": "nat_POST_work_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table=
": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat=
_POST_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_d=
eny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain"=
: "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_allow"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_POS=
T_work", "expr": [{"jump": {"target": "nat_POST_work_post"}}]}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work"}}}=
, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PO=
ST_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", =
"name": "nat_POST_work_log"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_work_deny"}}}, {"add": {"chain": {"family"=
: "ip6", "table": "firewalld", "name": "nat_POST_work_allow"}}}, {"add": {"=
chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_POST_work", "expr": [{"jump": {"target": "nat_POST_work_pre"}}]}}}, {"add=
": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work=
", "expr": [{"jump": {"target": "nat_POST_work_log"}}]}}}, {"add": {"rule":=
 {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": =
[{"jump": {"target": "nat_POST_work_deny"}}]}}}, {"add": {"rule": {"family"=
: "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": =
{"target": "nat_POST_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", =
"table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target"=
: "nat_POST_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table":=
 "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left":=
 {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"g=
oto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"family": "ip6=
", "table": "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match=
": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_du=
mmy"}}, {"goto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr":=
 [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right":=
 "perm_dummy"}}, {"goto": {"target": "filter_IN_work"}}]}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter=
_FWDI_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewall=
d", "name": "filter_FWDI_work_log"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "filter_FWDI_work_deny"}}}, {"add": {"chain"=
: {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work_allow"=
}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fi=
lter_FWDI_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fire=
walld", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_F=
WDI_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_=
work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work=
_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_al=
low"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_post=
"}}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"left": {"meta": {"key":=
 "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"target": =
"filter_FWDI_work"}}]}}}, {"add": {"chain": {"family": "inet", "table": "fi=
rewalld", "name": "filter_FWDO_work"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_FWDO_work_pre"}}}, {"add": {"chain=
": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_work_log"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fil=
ter_FWDO_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "fire=
walld", "name": "filter_FWDO_work_allow"}}}, {"add": {"chain": {"family": "=
inet", "table": "firewalld", "name": "filter_FWDO_work_post"}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work"=
, "expr": [{"jump": {"target": "filter_FWDO_work_pre"}}]}}}, {"add": {"rule=
": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "e=
xpr": [{"jump": {"target": "filter_FWDO_work_log"}}]}}}, {"add": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr"=
: [{"jump": {"target": "filter_FWDO_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [=
{"jump": {"target": "filter_FWDO_work_allow"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [{"=
jump": {"target": "filter_FWDO_work_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "ex=
pr": [{"match": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "rig=
ht": "perm_dummy"}}, {"goto": {"target": "filter_FWDO_work"}}]}}}, {"add": =
{"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work"=
, "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op=
": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FWDI_work", "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4pro=
to"}}, "op": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": n=
ull}]}}}]}'
=20
 test -z "$($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\|{"insert":=
\)/\n\1/g' |grep '\({"add":\|{"insert":\)' | grep -v '"handle"')"
+
+if [ "$RULE_COUNT" !=3D 3000 ] ; then
+	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
+	echo "/proc/sys/net/core/rmem_max is too small for this test. Mark as SKI=
PPED"
+	echo "You may bump the limit and rerun with \`NFT_TEST_HAS_SOCKET_LIMITS=
=3Dn\`."
+	exit 77
+fi
diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/te=
stcases/transactions/30s-stress
index 4d3317e22b0c..757e7639b5e9 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -16,6 +16,15 @@ if [ x =3D x"$NFT" ] ; then
 	NFT=3Dnft
 fi
=20
+if [ "$NFT_TEST_HAS_SOCKET_LIMITS" =3D y ] ; then
+	# The socket limit /proc/sys/net/core/wmem_max may be unsuitable for
+	# the test.
+	#
+	# Skip it. You may ensure that the limits are suitable and rerun
+	# with NFT_TEST_HAS_SOCKET_LIMITS=3Dn.
+	exit 77
+fi
+
 testns=3Dtestns-$(mktemp -u "XXXXXXXX")
 tmp=3D""
=20
--=20
2.41.0

