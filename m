From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add chain validations tests
Date: Tue, 22 Mar 2016 14:06:09 +0100
Message-ID: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33676 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032AbcCVNGY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 09:06:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some basic test regarding chains: jumps and validations.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
NOTE: the testcases/chains/0009masquerade_jump_1 file fails, seems like a bug
in the kernel validation. Needs more investigation.

 tests/shell/testcases/chains/0001jumps_0           |   17 +++++++++++++++
 tests/shell/testcases/chains/0002jumps_1           |   22 ++++++++++++++++++++
 tests/shell/testcases/chains/0003jump_loop_1       |   21 +++++++++++++++++++
 tests/shell/testcases/chains/0004busy_1            |   11 ++++++++++
 tests/shell/testcases/chains/0005busy_map_1        |   11 ++++++++++
 tests/shell/testcases/chains/0006masquerade_0      |    7 ++++++
 tests/shell/testcases/chains/0007masquerade_1      |    9 ++++++++
 tests/shell/testcases/chains/0008masquerade_jump_1 |   11 ++++++++++
 tests/shell/testcases/chains/0009masquerade_jump_1 |   11 ++++++++++
 9 files changed, 120 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0001jumps_0
 create mode 100755 tests/shell/testcases/chains/0002jumps_1
 create mode 100755 tests/shell/testcases/chains/0003jump_loop_1
 create mode 100755 tests/shell/testcases/chains/0004busy_1
 create mode 100755 tests/shell/testcases/chains/0005busy_map_1
 create mode 100755 tests/shell/testcases/chains/0006masquerade_0
 create mode 100755 tests/shell/testcases/chains/0007masquerade_1
 create mode 100755 tests/shell/testcases/chains/0008masquerade_jump_1
 create mode 100755 tests/shell/testcases/chains/0009masquerade_jump_1

diff --git a/tests/shell/testcases/chains/0001jumps_0 b/tests/shell/testcases/chains/0001jumps_0
new file mode 100755
index 0000000..b39df38
--- /dev/null
+++ b/tests/shell/testcases/chains/0001jumps_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+set -e
+
+MAX_JUMPS=16
+
+$NFT add table t
+
+for i in $(seq 1 $MAX_JUMPS)
+do
+	$NFT add chain t c${i}
+done
+
+for i in $(seq 1 $((MAX_JUMPS - 1)))
+do
+	$NFT add rule t c${i} jump c$((i + 1))
+done
diff --git a/tests/shell/testcases/chains/0002jumps_1 b/tests/shell/testcases/chains/0002jumps_1
new file mode 100755
index 0000000..0cc8928
--- /dev/null
+++ b/tests/shell/testcases/chains/0002jumps_1
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+set -e
+
+MAX_JUMPS=16
+
+$NFT add table t
+
+for i in $(seq 1 $MAX_JUMPS)
+do
+	$NFT add chain t c${i}
+done
+
+for i in $(seq 1 $((MAX_JUMPS - 1)))
+do
+	$NFT add rule t c${i} jump c$((i + 1))
+done
+
+# this last jump should fail: too many links
+$NFT add chain t c$((MAX_JUMPS + 1))
+$NFT add rule t c${MAX_JUMPS} jump c$((MAX_JUMPS + 1)) 2>/dev/null
+echo "E: max jumps ignored?" >&2
diff --git a/tests/shell/testcases/chains/0003jump_loop_1 b/tests/shell/testcases/chains/0003jump_loop_1
new file mode 100755
index 0000000..f74361f
--- /dev/null
+++ b/tests/shell/testcases/chains/0003jump_loop_1
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+set -e
+
+MAX_JUMPS=16
+
+$NFT add table t
+
+for i in $(seq 1 $MAX_JUMPS)
+do
+	$NFT add chain t c${i}
+done
+
+for i in $(seq 1 $((MAX_JUMPS - 1)))
+do
+	$NFT add rule t c${i} jump c$((i + 1))
+done
+
+# this last jump should fail: loop
+$NFT add rule t c${MAX_JUMPS} jump c1 2>/dev/null
+echo "E: loop of jumps ignored?" >&2
diff --git a/tests/shell/testcases/chains/0004busy_1 b/tests/shell/testcases/chains/0004busy_1
new file mode 100755
index 0000000..cc9a0da
--- /dev/null
+++ b/tests/shell/testcases/chains/0004busy_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+$NFT add chain t c2
+$NFT add rule t c1 jump c2
+# kernel should return EBUSY
+$NFT delete chain t c2 2>/dev/null
+echo "E: deleted a busy chain?" >&2
diff --git a/tests/shell/testcases/chains/0005busy_map_1 b/tests/shell/testcases/chains/0005busy_map_1
new file mode 100755
index 0000000..93eca82
--- /dev/null
+++ b/tests/shell/testcases/chains/0005busy_map_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+$NFT add chain t c2
+$NFT add rule t c1 tcp dport vmap { 1 : jump c2 }
+# kernel should return EBUSY
+$NFT delete chain t c2 2>/dev/null
+echo "E: deleted a busy chain?" >&2
diff --git a/tests/shell/testcases/chains/0006masquerade_0 b/tests/shell/testcases/chains/0006masquerade_0
new file mode 100755
index 0000000..7934998
--- /dev/null
+++ b/tests/shell/testcases/chains/0006masquerade_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1 {type nat hook postrouting priority 0 \; }
+$NFT add rule t c1 masquerade
diff --git a/tests/shell/testcases/chains/0007masquerade_1 b/tests/shell/testcases/chains/0007masquerade_1
new file mode 100755
index 0000000..4e98d10
--- /dev/null
+++ b/tests/shell/testcases/chains/0007masquerade_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1 {type filter hook output priority 0 \; }
+# wrong hook output, only postrouting is valid
+$NFT add rule t c1 masquerade 2>/dev/null
+echo "E: accepted masquerade in output hook" >&2
diff --git a/tests/shell/testcases/chains/0008masquerade_jump_1 b/tests/shell/testcases/chains/0008masquerade_jump_1
new file mode 100755
index 0000000..7754ed0
--- /dev/null
+++ b/tests/shell/testcases/chains/0008masquerade_jump_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t output {type nat hook output priority 0 \; }
+$NFT add chain t c1
+$NFT add rule t c1 masquerade
+# kernel should return EOPNOTSUPP
+$NFT add rule t output jump c1 2>/dev/null
+echo "E: accepted masquerade in output hook" >&2
diff --git a/tests/shell/testcases/chains/0009masquerade_jump_1 b/tests/shell/testcases/chains/0009masquerade_jump_1
new file mode 100755
index 0000000..684d441
--- /dev/null
+++ b/tests/shell/testcases/chains/0009masquerade_jump_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t output {type nat hook output priority 0 \; }
+$NFT add chain t c1
+$NFT add rule t c1 masquerade
+# kernel should return EOPNOTSUPP
+$NFT add rule t output tcp dport vmap {1 :jump c1 } 2>/dev/null
+echo "E: accepted masquerade in output hook in a vmap" >&2

