From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: shell: add testcases for named sets with
 intervals
Date: Mon, 25 Apr 2016 12:20:57 +0200
Message-ID: <146157965718.18051.10385957941244104731.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52582 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754153AbcDYKVg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 06:21:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add some testcases for named sets with intervals and ranges.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/sets/0001named_interval_0    |   47 ++++++++++++++++++++
 .../sets/0002named_interval_automerging_0          |   12 +++++
 .../sets/0003named_interval_missing_flag_0         |   12 +++++
 .../testcases/sets/0004named_interval_shadow_0     |   13 ++++++
 .../testcases/sets/0005named_interval_shadow_0     |   13 ++++++
 5 files changed, 97 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0001named_interval_0
 create mode 100755 tests/shell/testcases/sets/0002named_interval_automerging_0
 create mode 100755 tests/shell/testcases/sets/0003named_interval_missing_flag_0
 create mode 100755 tests/shell/testcases/sets/0004named_interval_shadow_0
 create mode 100755 tests/shell/testcases/sets/0005named_interval_shadow_0

diff --git a/tests/shell/testcases/sets/0001named_interval_0 b/tests/shell/testcases/sets/0001named_interval_0
new file mode 100755
index 0000000..8d08b75
--- /dev/null
+++ b/tests/shell/testcases/sets/0001named_interval_0
@@ -0,0 +1,47 @@
+#!/bin/bash
+
+# This is the most basic testscase:
+# * creating a valid interval set
+# * referencing it from a valid rule
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+table inet t {
+	set s1 {
+		type ipv4_addr
+		flags interval
+		elements = { 10.0.0.0-11.0.0.0, 172.16.0.0/16 }
+	}
+	set s2 {
+		type ipv6_addr
+		flags interval
+		elements = { fe00::/64, fe11::-fe22::}
+	}
+	set s3 {
+		type inet_proto
+		flags interval
+		elements = { 10-20, 50-60}
+	}
+	set s4 {
+		type inet_service
+		flags interval
+		elements = {8080-8082, 0-1024, 10000-40000}
+	}
+	chain c {
+		ip saddr @s1 accept
+		ip6 daddr @s2 accept
+		ip protocol @s3 accept
+		ip6 nexthdr @s3 accept
+		tcp dport @s4 accept
+	}
+}" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
diff --git a/tests/shell/testcases/sets/0002named_interval_automerging_0 b/tests/shell/testcases/sets/0002named_interval_automerging_0
new file mode 100755
index 0000000..b07e0b0
--- /dev/null
+++ b/tests/shell/testcases/sets/0002named_interval_automerging_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This testscase checks the automerging of adjacent intervals
+
+set -e
+
+$NFT add table t
+$NFT add set t s { type ipv4_addr \; flags interval \; }
+$NFT add element t s { 192.168.0.0/24, 192.168.1.0/24 }
+$NFT list ruleset | grep "192.168.0.0/23" >/dev/null && exit 0
+echo "E: automerging of adjavect intervals failed in named set" >&2
+exit 1
diff --git a/tests/shell/testcases/sets/0003named_interval_missing_flag_0 b/tests/shell/testcases/sets/0003named_interval_missing_flag_0
new file mode 100755
index 0000000..e0b7f74
--- /dev/null
+++ b/tests/shell/testcases/sets/0003named_interval_missing_flag_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This testscase checks the nft checking of flags in named intervals
+
+set -e
+$NFT add table t
+$NFT add set t s { type ipv4_addr \; }
+if $NFT add element t s { 192.168.0.0/24, 192.168.1.0/24 } 2>/dev/null ; then
+	echo "E: accepted interval in named set without proper flags" >&2
+	exit 1
+fi
+exit 0
diff --git a/tests/shell/testcases/sets/0004named_interval_shadow_0 b/tests/shell/testcases/sets/0004named_interval_shadow_0
new file mode 100755
index 0000000..827423d
--- /dev/null
+++ b/tests/shell/testcases/sets/0004named_interval_shadow_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+# This testscase checks the nft checking of shadowed elements
+
+set -e
+$NFT add table inet t
+$NFT add set inet t s { type ipv6_addr \; flags interval \; }
+$NFT add element inet t s { fe00::/64 }
+if $NFT add element inet t s { fe00::/48 } 2>/dev/null ; then
+	echo "E: accepted shadowed element in named set" >&2
+	exit 1
+fi
+exit 0
diff --git a/tests/shell/testcases/sets/0005named_interval_shadow_0 b/tests/shell/testcases/sets/0005named_interval_shadow_0
new file mode 100755
index 0000000..14fcbdc
--- /dev/null
+++ b/tests/shell/testcases/sets/0005named_interval_shadow_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+# This testscase checks the nft checking of shadowed elements
+
+set -e
+$NFT add table inet t
+$NFT add set inet t s { type ipv6_addr \; flags interval \; }
+$NFT add element inet t s { fe00::/48 }
+if $NFT add element inet t s { fe00::/64 } 2>/dev/null ; then
+	echo "E: accepted shadowed element in named set" >&2
+	exit 1
+fi
+exit 0

