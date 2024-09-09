Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78833158D7F
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725899470; cv=none; b=SNw702pua0mRnlai0PGyU59+ZY2AABamUxQ4UsbJTsHtspWvlVjqsfleUh7j99N2/ZbTQzWuA5RjaI80CTR8L4aQl1au8GkeYGU753Ibf7GBMLcpkzAMLsoJaoz0O3vDK4veoHPh5AZjYBB6lCMJXDG+M7YLYThDcfHTi1z+SPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725899470; c=relaxed/simple;
	bh=NK8qKQeTrQRO8ogmo5WfenCxErmCM9y5+MzsaQwkBh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLQKKohrFWmxC/G5KHb//ymY1Q2ASvwIVWhs0IZF12tCOwMpFqVPSmy0Rj5g7NrMSTKtWI88zOe4tuEebPwNjjkh3kTOFXWjU5dVLmunOs907SKPjbQTNcXlUlXGj1Xf+O5awLMUZwSg+6QhY2uWs3e9+9siqYNoMAv/EKmnnkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1snhIA-0000Ct-Kn; Mon, 09 Sep 2024 18:31:06 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add test case for timeout updates
Date: Mon,  9 Sep 2024 18:16:42 +0200
Message-ID: <20240909161733.4360-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needs a feature check file, so add one:
Add element with 1m timeout, then update expiry to 1ms.
If element still exists after 1ms, update request was ignored.

Test case checks timeouts can both be incremented and decremented,
checks error recovery (update request but transaction fails) and
that expiry is restored in addion to timeout.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/elem_timeout_update.sh   |  22 ++++
 .../set_element_timeout_updates.json-nft      |  43 +++++++
 .../dumps/set_element_timeout_updates.nft     |  10 ++
 .../sets/set_element_timeout_updates          | 120 ++++++++++++++++++
 4 files changed, 195 insertions(+)
 create mode 100755 tests/shell/features/elem_timeout_update.sh
 create mode 100644 tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/set_element_timeout_updates.nft
 create mode 100755 tests/shell/testcases/sets/set_element_timeout_updates

diff --git a/tests/shell/features/elem_timeout_update.sh b/tests/shell/features/elem_timeout_update.sh
new file mode 100755
index 000000000000..6243170a6023
--- /dev/null
+++ b/tests/shell/features/elem_timeout_update.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# 4201f3938914 ("netfilter: nf_tables: set element timeout update support")
+
+$NFT -f - <<EOF
+table ip t {
+	set s {
+		typeof ip saddr
+		timeout 1m
+		elements = { 1.2.3.4 }
+	}
+}
+EOF
+
+$NFT add element t s { 1.2.3.4 expires 1ms }
+
+sleep 0.001
+$NFT get element t s { 1.2.3.4 }
+
+[ $? -eq 0 ] && exit 111
+
+exit 0
diff --git a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
new file mode 100644
index 000000000000..aa908297e49e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
@@ -0,0 +1,43 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "base",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "flags": [
+          "timeout"
+        ],
+        "timeout": 60
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.nft b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.nft
new file mode 100644
index 000000000000..1edd2ec72f8e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.nft
@@ -0,0 +1,10 @@
+table ip t {
+	set s {
+		typeof ip saddr
+		timeout 1m
+	}
+
+	chain base {
+		type filter hook input priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/sets/set_element_timeout_updates b/tests/shell/testcases/sets/set_element_timeout_updates
new file mode 100755
index 000000000000..4bf6c7c39a86
--- /dev/null
+++ b/tests/shell/testcases/sets/set_element_timeout_updates
@@ -0,0 +1,120 @@
+#!/bin/bash
+#
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_elem_timeout_update)
+#
+
+assert_fail()
+{
+	ret=$1
+
+	if [ $ret -eq 0 ];then
+		echo "subtest should have failed: $2"
+		exit 111
+	fi
+}
+
+assert_ok()
+{
+	ret=$1
+
+	if [ $ret -ne 0 ];then
+		echo "subtest should have passed: $2"
+		exit 111
+	fi
+}
+
+
+$NFT -f - <<EOF
+table t {
+	set s {
+		typeof ip saddr
+		timeout 1m
+		elements = { 10.0.0.1, 10.0.0.2, 10.0.0.3 }
+	}
+
+	chain base {
+		type filter hook input priority 0
+	}
+}
+EOF
+
+for i in 1 2 3;do
+	$NFT get element t s "{ 10.0.0.$i }"
+	assert_ok $? "get element $i"
+done
+
+# first, bogus updates to trigger abort path with updates.
+$NFT -f - <<EOF
+add element t s { 10.0.0.2 timeout 2m }
+create element t s { 10.0.0.1 }
+add element t s { 10.0.0.3 timeout 3m }
+EOF
+assert_fail $? "abort due to existing element"
+
+$NFT -f - <<EOF
+add chain t a
+add element t s { 10.0.0.1 timeout 1m }
+add element t s { 10.0.0.2 timeout 2m }
+add element t s { 10.0.0.3 timeout 3m }
+add chain t b
+add rule t a jump b
+add rule t b jump a
+add rule t base jump a
+EOF
+assert_fail $? "abort due to chainloop"
+
+$NFT -f - <<EOF
+add element t s { 10.0.0.1 expires 2m }
+EOF
+assert_fail $? "expire larger than timeout"
+
+$NFT -f - <<EOF
+add element t s { 10.0.0.1 timeout 1s }
+add element t s { 10.0.0.2 timeout 1s }
+add element t s { 10.0.0.3 timeout 1s }
+add element t s { 10.0.0.4 expires 2m }
+EOF
+assert_fail $? "abort because expire too large"
+
+# check timeout update had no effect
+sleep 1
+for i in 1 2 3;do
+	$NFT get element t s "{ 10.0.0.$i }"
+	assert_ok $? "get element $i after aborted update"
+done
+
+# adjust timeouts upwards.
+$NFT -f - <<EOF
+add element t s { 10.0.0.1 timeout 1m }
+add element t s { 10.0.0.2 timeout 2m }
+add element t s { 10.0.0.3 timeout 3m }
+EOF
+assert_ok $? "upwards adjust"
+
+for i in 1 2 3;do
+	$NFT get element t s "{ 10.0.0.$i }"
+	assert_ok $? "get element $i"
+done
+
+# insert 4th element with timeout larger than set default
+$NFT -f - <<EOF
+add element t s { 10.0.0.4 timeout 2m expires 2m }
+EOF
+$NFT get element t s "{ 10.0.0.4 }"
+assert_ok $? "get element 4"
+
+# adjust timeouts downwards
+$NFT -f - <<EOF
+add element t s { 10.0.0.1 timeout 1s }
+add element t s { 10.0.0.2 timeout 2s expires 1s }
+add element t s { 10.0.0.3 expires 1s }
+add element t s { 10.0.0.4 timeout 4m expires 1s }
+EOF
+assert_ok $?
+
+sleep 1
+
+for i in 1 2 3;do
+	$NFT get element t s "{ 10.0.0.$i }"
+	assert_fail $?
+done
-- 
2.44.2

