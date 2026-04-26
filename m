Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D2C366072
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777214714; cv=none; b=PdRIdf6Mwe6Mk7bXsU8MCqWzwdjIXyUJ0o8xfdKMm3KDPaH++eE0hJh8WpEkRpu1TviFXcvhGwQLaEH6HnA99J4u8izsxQ7dc+yZQ9toiyMjj+NhJhxtG5E/mX+DwNbPx9e1upp554rt9L3m6Ol3wKV4eWJsENVe1v2zQLiPZO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777214714; c=relaxed/simple;
	bh=GR1RGPxqJz0ZTjv6DD8wbVPnNYiIqnSI/+r8RlRxlz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K6z38rA+j950kia6caLwBlVWvCAaiCkVpOFxNmmZhBl08ydYTs63+5YFIrs00i0+y6DVfmYK9NgvkSAhii/bAd6Jeovp9u9PGqXVDhQGdQO1qNAe3s4os3747CLHinZukKwPnlxOKlDnceLgwkygoAdYscXj0HhHaQTuGonlFBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 123CA604DC; Sun, 26 Apr 2026 16:45:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add test case for netdev + dormant table
Date: Sun, 26 Apr 2026 16:44:51 +0200
Message-ID: <20260426144456.146241-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

both commit update and abort path need to release memory associated with
netdev hooks.  kfree gets skipped because it mixes registration and
allocation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../transactions/dormant_updchain_abort       | 23 +++++++++++++
 .../dumps/dormant_updchain_abort.json-nft     | 33 +++++++++++++++++++
 .../dumps/dormant_updchain_abort.nft          |  7 ++++
 3 files changed, 63 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/dormant_updchain_abort
 create mode 100644 tests/shell/testcases/transactions/dumps/dormant_updchain_abort.json-nft
 create mode 100644 tests/shell/testcases/transactions/dumps/dormant_updchain_abort.nft

diff --git a/tests/shell/testcases/transactions/dormant_updchain_abort b/tests/shell/testcases/transactions/dormant_updchain_abort
new file mode 100755
index 000000000000..56ad887d0d92
--- /dev/null
+++ b/tests/shell/testcases/transactions/dormant_updchain_abort
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f - <<EOF
+table netdev t {
+	flags dormant
+
+	chain c {
+		type filter hook ingress priority 0
+	}
+}
+EOF
+
+# check abort path frees transaction
+$NFT --check --f - <<EOF
+table netdev t {
+	flags dormant
+	chain c {
+		type filter hook ingress device lo priority 0
+	}
+}
+EOF
diff --git a/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.json-nft b/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.json-nft
new file mode 100644
index 000000000000..f6838c15e9f1
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.json-nft
@@ -0,0 +1,33 @@
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
+        "family": "netdev",
+        "name": "t",
+        "handle": 0,
+        "flags": [
+          "dormant"
+        ]
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.nft b/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.nft
new file mode 100644
index 000000000000..95dcc59a3e46
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/dormant_updchain_abort.nft
@@ -0,0 +1,7 @@
+table netdev t {
+	flags dormant
+
+	chain c {
+		type filter hook ingress priority filter; policy accept;
+	}
+}
-- 
2.53.0

