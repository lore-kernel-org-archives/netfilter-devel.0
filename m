From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 2/2] tests: shell: add maps tests
Date: Fri, 6 Jan 2017 19:44:57 -0200
Message-ID: <20170106214457.GA4739@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34682 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753506AbdAFVpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2017 16:45:02 -0500
Received: by mail-yw0-f194.google.com with SMTP id a10so3805499ywa.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jan 2017 13:45:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test adding elements to simple and interval maps.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 .../testcases/maps/0003map_add_many_elements_0     | 61 ++++++++++++++++++++
 .../testcases/maps/0004interval_map_create_once_0  | 60 ++++++++++++++++++++
 .../maps/0005interval_map_add_many_elements_0      | 66 ++++++++++++++++++++++
 .../testcases/maps/0006interval_map_overlap_0      | 41 ++++++++++++++
 4 files changed, 228 insertions(+)
 create mode 100755 tests/shell/testcases/maps/0003map_add_many_elements_0
 create mode 100755 tests/shell/testcases/maps/0004interval_map_create_once_0
 create mode 100755 tests/shell/testcases/maps/0005interval_map_add_many_elements_0
 create mode 100755 tests/shell/testcases/maps/0006interval_map_overlap_0

diff --git a/tests/shell/testcases/maps/0003map_add_many_elements_0 b/tests/shell/testcases/maps/0003map_add_many_elements_0
new file mode 100755
index 0000000..a2233e3
--- /dev/null
+++ b/tests/shell/testcases/maps/0003map_add_many_elements_0
@@ -0,0 +1,61 @@
+#!/bin/bash
+
+# test adding many map elements
+
+HOWMANY=31
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+generate_add() {
+	echo -n "{"
+	for ((i=HOWMANY; i>=1; i--)) ; do
+		for ((j=HOWMANY; j>=1; j--)) ; do
+			[ "$i" == 1 ] && [ "$j" == 1 ] && break
+			echo -n "10.0.${i}.${j} : 10.0.${i}.${j}, "
+		done
+	done
+	echo -n "}"
+}
+
+generate_test() {
+	elements=""
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			elements="$elements 10.0.${i}.${j} : 10.0.${i}.${j}"
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			elements="${elements}, "
+		done
+	done
+	echo $elements
+}
+
+echo "add table x
+add map x y { type ipv4_addr : ipv4_addr; }
+add element x y $(generate_add)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+n=$HOWMANY
+echo "add element x y { 10.0.1.1 : 10.0.1.1 }" > $tmpfile
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		elements = { $(generate_test)}
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
new file mode 100755
index 0000000..7d4877e
--- /dev/null
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -0,0 +1,60 @@
+#!/bin/bash
+
+# test adding many elements to an interval map
+# this always works because nft is only called once
+
+HOWMANY=63
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+generate_add() {
+	echo -n "{"
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			echo -n "10.${i}.${j}.0/24 : 10.0.${i}.${j}"
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			echo -n ", "
+		done
+	done
+	echo -n "}"
+}
+
+generate_test() {
+	elements=""
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			elements="$elements 10.${i}.${j}.0/24 : 10.0.${i}.${j}"
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			elements="${elements}, "
+		done
+	done
+	echo $elements
+}
+
+echo "add table x
+add map x y { type ipv4_addr : ipv4_addr; flags interval; }
+add element x y $(generate_add)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { $(generate_test)}
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/maps/0005interval_map_add_many_elements_0 b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
new file mode 100755
index 0000000..824f2c8
--- /dev/null
+++ b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
@@ -0,0 +1,66 @@
+#!/bin/bash
+
+# test adding many elements to an interval map
+# even with HOWMANY=2 there are memory allocation failures in the current
+# master - the patch fixes that
+# NOTE this is only an issue with two separate nft calls
+
+HOWMANY=2
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+generate_add() {
+	echo -n "{"
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			echo -n "10.${i}.${j}.0/24 : 10.0.${i}.${j}, "
+		done
+	done
+	echo -n "}"
+}
+
+generate_test() {
+	elements=""
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			elements="$elements 10.${i}.${j}.0/24 : 10.0.${i}.${j}"
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			elements="${elements}, "
+		done
+	done
+	echo $elements
+}
+
+echo "add table x
+add map x y { type ipv4_addr : ipv4_addr; flags interval; }
+add element x y $(generate_add)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+n=$HOWMANY
+echo "add element x y { 10.${n}.${n}.0/24 : 10.0.${n}.${n} }" > $tmpfile
+
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { $(generate_test)}
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/maps/0006interval_map_overlap_0 b/tests/shell/testcases/maps/0006interval_map_overlap_0
new file mode 100755
index 0000000..c1bf3de
--- /dev/null
+++ b/tests/shell/testcases/maps/0006interval_map_overlap_0
@@ -0,0 +1,41 @@
+#!/bin/bash
+
+# test adding elements to an interval map
+# shows how disjoint intervals are seen as overlaps
+# NOTE this is only an issue with two separate nft calls
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+n=1
+echo "add table x
+add map x y { type ipv4_addr : ipv4_addr; flags interval; }
+add element x y { 10.0.${n}.0/24 : 10.0.0.${n} }" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+n=2
+echo "add element x y { 10.0.${n}.0/24 : 10.0.0.${n} }" > $tmpfile
+
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.0.1.0/24 : 10.0.0.1, 10.0.2.0/24 : 10.0.0.2}
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
-- 
2.7.4

