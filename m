From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Adding element to interval map consumes entire memory
Date: Thu, 15 Dec 2016 23:47:30 +0100
Message-ID: <20161215224730.GA3663@salvia>
References: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
 <20161211192807.GA31470@salvia>
 <3acabb81-c5b5-2004-18ce-8b5242f07921@tu-dresden.de>
 <20161213004849.GA15100@salvia>
 <8fa4cbd2-5fb8-1189-302a-cf8be3c858be@tu-dresden.de>
 <20161215220238.GA25865@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Richard =?iso-8859-1?Q?M=F6rbitz?=
        <richard.moerbitz@tu-dresden.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbcLOWrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2016 17:47:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 95AD3764F
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:47:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7290DDA862
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:47:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9A10DA863
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:47:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161215220238.GA25865@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 15, 2016 at 11:02:38PM +0100, Pablo Neira Ayuso wrote:
> Hi Richard,
> 
> On Thu, Dec 15, 2016 at 12:52:01AM +0100, Richard Mörbitz wrote:
> [...]
> > I don't know how to contribute them properly, so I have attached four
> > tests to this mail. They are based on
> > sets/0013add_delete_many_elements_0, as
> > sets/0012add_delete_many_elements_0 fails (it seems like adding and
> > deleting elements simultaneously causes the whole ruleset to be empty).
> 
> We usually get patches, in the form of git-format-patch, but no
> problem I have created a patch based on this tarball. You can now find
> it at git.netfilter.org.

This is the patch I made. I'm going to keep it back until I solve a
couple of problems that I'm hitting here, will have a look tomorrow
with fresher mind.

--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-tests-shell-cover-maps.patch"
Content-Transfer-Encoding: 8bit

>From 22e4f41dd6938a026ce87c2195a21d0067ed6454 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Richard=20M=C3=B6rbitz?= <richard.moerbitz@tu-dresden.de>
Date: Thu, 15 Dec 2016 00:52:01 +0100
Subject: [PATCH] tests: shell: cover maps
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch adds four new tests to cover maps and interval maps.

Signed-off-by: Richard Mörbitz <richard.moerbitz@tu-dresden.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 000000000000..278d1978eb33
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
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			echo -n "10.0.${i}.${j} : 10.0.${i}.${j}, "
+		done
+	done
+	echo -n "}"
+}
+
+generate_test() {
+	elements=""
+	for ((i=HOWMANY; i>=1; i--)) ; do
+		for ((j=HOWMANY; j>=1; j--)) ; do
+			elements="$elements 10.0.${i}.${j} : 10.0.${i}.${j}"
+			[ "$i" == 1 ] && [ "$j" == 1 ] && break
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
+echo "add element x y { 10.0.${n}.${n} : 10.0.${n}.${n} }" > $tmpfile
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
index 000000000000..7d4877eb6e96
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
index 000000000000..824f2c85fb70
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
index 000000000000..c1bf3de111ac
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
2.1.4


--qDbXVdCdHGoSgWSk--
