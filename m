From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add some tests for network namespaces
Date: Wed, 06 Apr 2016 13:00:10 +0200
Message-ID: <145994041032.27922.11144705527173452584.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55064 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbcDFLAW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 07:00:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A basic tests to check we can perform operations in different network
namespaces.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/netns/0001nft-f_0         |  116 +++++++++++++++++++++
 tests/shell/testcases/netns/0002loosecommands_0 |   63 +++++++++++
 tests/shell/testcases/netns/0003many_0          |  130 +++++++++++++++++++++++
 3 files changed, 309 insertions(+)
 create mode 100755 tests/shell/testcases/netns/0001nft-f_0
 create mode 100755 tests/shell/testcases/netns/0002loosecommands_0
 create mode 100755 tests/shell/testcases/netns/0003many_0

diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
new file mode 100755
index 0000000..f22f592
--- /dev/null
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -0,0 +1,116 @@
+#!/bin/bash
+
+# test a kernel netns loading a simple ruleset
+
+IP=$(which ip)
+if [ ! -x "$IP" ] ; then
+	echo "E: no ip binary" >&2
+	exit 1
+fi
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="table ip t {
+	set s {
+		type ipv4_addr
+		elements = { 1.1.0.0}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table ip6 t {
+	set s {
+		type ipv6_addr
+		elements = { fe00::1}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip6 saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table inet t {
+	set s {
+		type ipv6_addr
+		elements = { fe00::1}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip6 saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table bridge t {
+	chain c {
+		jump other
+	}
+
+	chain other {
+		accept
+	}
+}
+table arp t {
+	chain c {
+		jump other
+	}
+
+	chain other {
+		accept
+	}
+}"
+
+# netns
+NETNS_NAME=$(basename "$0")
+$IP netns add $NETNS_NAME
+if [ $? -ne 0 ] ; then
+	echo "E: unable to create netns" >&2
+	exit 1
+fi
+
+echo "$RULESET" > $tmpfile
+$IP netns exec $NETNS_NAME $NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load ruleset in netns" >&2
+	$IP netns del $NETNS_NAME
+	exit 1
+fi
+
+KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+$IP netns del $NETNS_NAME
+if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+exit 0
+
diff --git a/tests/shell/testcases/netns/0002loosecommands_0 b/tests/shell/testcases/netns/0002loosecommands_0
new file mode 100755
index 0000000..ac07f01
--- /dev/null
+++ b/tests/shell/testcases/netns/0002loosecommands_0
@@ -0,0 +1,63 @@
+#!/bin/bash
+
+# test a kernel netns loading a simple ruleset
+
+IP=$(which ip)
+if [ ! -x "$IP" ] ; then
+	echo "E: no ip binary" >&2
+	exit 1
+fi
+
+function netns_exec()
+{
+	# $1: netns_name $2: command
+	$IP netns exec $1 $2
+	if [ $? -ne 0 ] ; then
+		echo "E: failed to execute command in netns $1: $2" >&2
+		$IP netns del $1
+		exit 1
+	fi
+}
+
+NETNS_NAME=$(basename "$0")
+$IP netns add $NETNS_NAME
+if [ $? -ne 0 ] ; then
+	echo "E: unable to create netns" >&2
+	exit 1
+fi
+
+netns_exec $NETNS_NAME "$NFT add table ip t"
+netns_exec $NETNS_NAME "$NFT add chain ip t c"
+netns_exec $NETNS_NAME "$NFT add chain ip t other"
+netns_exec $NETNS_NAME "$NFT add set ip t s { type ipv4_addr; }"
+netns_exec $NETNS_NAME "$NFT add element ip t s {1.1.0.0 }"
+netns_exec $NETNS_NAME "$NFT add rule ip t c ct state new"
+netns_exec $NETNS_NAME "$NFT add rule ip t c udp dport { 12345 }"
+netns_exec $NETNS_NAME "$NFT add rule ip t c ip saddr @s drop"
+netns_exec $NETNS_NAME "$NFT add rule ip t c jump other"
+
+RULESET="table ip t {
+	set s {
+		type ipv4_addr
+		elements = { 1.1.0.0}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}"
+
+KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+$IP netns del $NETNS_NAME
+if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+exit 0
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
new file mode 100755
index 0000000..4160942
--- /dev/null
+++ b/tests/shell/testcases/netns/0003many_0
@@ -0,0 +1,130 @@
+#!/bin/bash
+
+# test using many netns
+
+# arbitry value of 'many'
+HOWMANY=20
+
+IP=$(which ip)
+if [ ! -x "$IP" ] ; then
+	echo "E: no ip binary" >&2
+	exit 1
+fi
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="table ip t {
+	set s {
+		type ipv4_addr
+		elements = { 1.1.0.0}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table ip6 t {
+	set s {
+		type ipv6_addr
+		elements = { fe00::1}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip6 saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table inet t {
+	set s {
+		type ipv6_addr
+		elements = { fe00::1}
+	}
+
+	chain c {
+		ct state new
+		udp dport { 12345}
+		ip6 saddr @s drop
+		jump other
+	}
+
+	chain other {
+	}
+}
+table bridge t {
+	chain c {
+		jump other
+	}
+
+	chain other {
+		accept
+	}
+}
+table arp t {
+	chain c {
+		jump other
+	}
+
+	chain other {
+		accept
+	}
+}"
+
+echo "$RULESET" > $tmpfile
+
+function test_netns()
+{
+	local NETNS_NAME=$1
+	$IP netns add $NETNS_NAME
+	if [ $? -ne 0 ] ; then
+		echo "E: unable to create netns" >&2
+		exit 1
+	fi
+
+	$IP netns exec $NETNS_NAME $NFT -f $tmpfile
+	if [ $? -ne 0 ] ; then
+		echo "E: unable to load ruleset in netns" >&2
+		$IP netns del $NETNS_NAME
+		exit 1
+	fi
+
+	KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+	if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
+		echo "E: ruleset in netns $NETNS_NAME differs from the loaded" >&2
+	        DIFF="$(which diff)"
+	        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+	        exit 1
+	fi
+
+	$IP netns del $NETNS_NAME
+}
+
+for i in $(seq 1 $HOWMANY) ; do
+	NETNS_NAME="$netns${i}_$(basename "$0")"
+	test_netns $NETNS_NAME
+done
+
+exit 0
+

