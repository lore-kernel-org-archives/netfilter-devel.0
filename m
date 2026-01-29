Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE026B764
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704398; cv=none; b=sl1PpzcwNZfajsKsWrA4cvxyYNc1GChTEfFsSklXOwZSlQEcMGkv8OpJwUPwqpOVDs4239fDiyi37J24kdrZmEAdqi6fQ/4WTuaHkD0jPtfFJYQjyug23/a30UH+hXfcLjHNMQjmg4LyGBrvKW5UR3a5dOVqlStJR1vK0YZW2jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704398; c=relaxed/simple;
	bh=RP+bwv9CKPsF86tQi1qjATN4bHVds5mjIWwqpOaqdfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VEsIiKneNfYt1ujWq50Xk6QzSAY2wG64U5YBsk9P5ZhxegUVAMB70yZmGO4B+IgYbBC12esgETh0r/Gdazn+U46CQ2Bv0b6PkO1bVH5Hq2ubHMMvp20FWRTr5X0xvb24UBCDiaU4XBAf3TC8szG9tHEi7JG0GlsLGNmP4waZoVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BC8D560516; Thu, 29 Jan 2026 17:33:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add test case for interval set with timeout and aborted transaction
Date: Thu, 29 Jan 2026 17:33:06 +0100
Message-ID: <20260129163309.6512-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a regression test for rbtree+bsearch getting out-of-sync in
nf-next kernel.

This covers the syzkaller reproducer from
https://syzkaller.appspot.com/bug?extid=d417922a3e7935517ef6
which triggers abort with earlier gc at insert time and
additional corner cases where transaction passes without
recording a relevant change in the set (and thus no call to
either abort or commit).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../dumps/rbtree_timeout_no_commit.json-nft   | 34 ++++++++++
 .../sets/dumps/rbtree_timeout_no_commit.nft   |  7 +++
 .../testcases/sets/rbtree_timeout_no_commit   | 63 +++++++++++++++++++
 3 files changed, 104 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.nft
 create mode 100755 tests/shell/testcases/sets/rbtree_timeout_no_commit

diff --git a/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.json-nft b/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.json-nft
new file mode 100644
index 000000000000..3cf22678e179
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.json-nft
@@ -0,0 +1,34 @@
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
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "flags": [
+          "interval",
+          "timeout"
+        ],
+        "elem": [
+          "10.0.0.1"
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.nft b/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.nft
new file mode 100644
index 000000000000..df0be9af386b
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/rbtree_timeout_no_commit.nft
@@ -0,0 +1,7 @@
+table ip t {
+	set s {
+		type ipv4_addr
+		flags interval,timeout
+		elements = { 10.0.0.1 }
+	}
+}
diff --git a/tests/shell/testcases/sets/rbtree_timeout_no_commit b/tests/shell/testcases/sets/rbtree_timeout_no_commit
new file mode 100755
index 000000000000..6101fff35e74
--- /dev/null
+++ b/tests/shell/testcases/sets/rbtree_timeout_no_commit
@@ -0,0 +1,63 @@
+#!/bin/bash
+
+# Test for bug added with kernel commit
+# 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
+# The binary search blob gets out-of-sync with the rbtree, holding pointers to elements
+# that have been free'd by garbage collection (element timed out).
+#
+# Prerequisite: set has a timed-out entry and 'add/create element' caused
+# that element to be free'd.
+
+# 1. add new element, transaction is later aborted.
+# Commit hook isn't called, so make sure ->abort refreshes the blob too.
+#
+# 2. re-add an existing element, transaction passes.
+# In this case, the commit hook isn't called because we don't have
+# any changes to the set from transaction point of view.
+# Transaction log can even be empty in this case.
+#
+# 3. create (F_EXCL) an existing element.
+# Also triggers abort, but ->abort callback isn't invoked
+# as no element was added.
+
+$NFT -f - <<EOF
+table t {
+	set s {
+		type ipv4_addr
+		flags interval, timeout
+		elements = { 10.0.0.1, 10.0.1.2-10.1.2.4 timeout 1s }
+	}
+}
+EOF
+
+sleep 2
+
+$NFT add element ip t s { 10.0.0.1 } || exit 1
+
+# The above insert triggered GC on the existing element,
+# and the 'add' suceeded (transaction successful).
+# 'get element' must fail and not encounter the removed
+# element.
+$NFT get element ip t s '{ 10.0.1.2 }' && exit 1
+echo "PASS: Did not find expired element after re-adding existing element"
+
+# Re-add an expiring element
+$NFT add element ip t s '{ 10.0.1.2 timeout 1s }' || exit 1
+sleep 2
+
+$NFT -f - <<EOF
+add element ip t s { 10.0.0.3, 10.0.1.5-10.0.1.42 }
+add element inet t s { 10.0.0.3 }
+EOF
+[ $? -eq 0 ] && exit 1
+
+$NFT get element ip t s '{ 10.0.1.2 }' && exit 1
+echo "PASS: Did not find expired element after transaction abort"
+
+# This create must fail, the transaction is aborted.
+# But the failed insertion also triggered GC on the
+# existing element.
+$NFT create element ip t s { 10.0.0.1 } && exit 1
+
+$NFT get element ip t s '{ 10.0.1.2 }' && exit 1
+echo "PASS: Did not find expired element after create failure"
-- 
2.52.0

