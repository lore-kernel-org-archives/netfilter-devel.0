Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0D01A23BE
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741593047; cv=none; b=OArQjGR3uDtWab/NjNnK76Hv+lw2MxoH+QU1gDQglNUsL7m2uthTYj/+hG//nJuWC5Xty7YGGic90M+Yk/EpBcym2Ynbpc7KxeOrYOxij6ZSBxsAeq4QI/n1YxuSdb2XRlBcxgoCfBJSnhP1ee3bZK4hAJBZbF6I+Epeunwdekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741593047; c=relaxed/simple;
	bh=5cJGUpQgxU0M+h5mlTM+g3ttnGN0+KApOqCHXq1QGTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0qcOtbRUKDsbwOCs4xzHl/F5qp4LNIzu0zdJH6rEBamtaJd8JyikaKxb4QN0q1Wzy3d9yxPAVBx+ftfHYhB8evzYesEJnffqyDISJtwI9BNX/2b49zxyymmJaJ8fVtT7Ex5hhyEBeDSkAGbqRoWQPCzadK8bAZIXvBRKcDF/Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1trXuM-0001eD-HM; Mon, 10 Mar 2025 08:50:42 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't crash if range has same start and end interval
Date: Mon, 10 Mar 2025 08:29:37 +0100
Message-ID: <20250310072940.5524-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In this case, evaluation step replaces the range expression with a
single value and we'd crash as range->left/right contain garbage
values.

Simply replace the input expression with the evaluation result.

Also add a test case modeled on the afl reproducer.

Fixes: fe6cc0ad29cd ("evaluate: consolidate evaluation of symbol range expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                |  5 +++
 .../dumps/range_with_same_start_end.json-nft  | 35 +++++++++++++++++++
 .../sets/dumps/range_with_same_start_end.nft  |  7 ++++
 .../testcases/sets/range_with_same_start_end  | 13 +++++++
 4 files changed, 60 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
 create mode 100755 tests/shell/testcases/sets/range_with_same_start_end

diff --git a/src/evaluate.c b/src/evaluate.c
index e27d08ce7ef8..722c11a23c2d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2351,6 +2351,10 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 		expr_free(range);
 		return -1;
 	}
+
+	if (range->etype != EXPR_RANGE)
+		goto out_done;
+
 	left = range->left;
 	right = range->right;
 
@@ -2371,6 +2375,7 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 		return 0;
 	}
 
+out_done:
 	expr_free(expr);
 	*exprp = range;
 
diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
new file mode 100644
index 000000000000..c4682475917e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
@@ -0,0 +1,35 @@
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
+        "name": "X",
+        "table": "t",
+        "type": "inet_service",
+        "handle": 0,
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          10,
+          30,
+          35
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
new file mode 100644
index 000000000000..78979e9e0d5e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
@@ -0,0 +1,7 @@
+table ip t {
+	set X {
+		type inet_service
+		flags interval
+		elements = { 10, 30, 35 }
+	}
+}
diff --git a/tests/shell/testcases/sets/range_with_same_start_end b/tests/shell/testcases/sets/range_with_same_start_end
new file mode 100755
index 000000000000..127f0921f0de
--- /dev/null
+++ b/tests/shell/testcases/sets/range_with_same_start_end
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f - <<EOF
+table ip t {
+	set X {
+		type inet_service
+		flags interval
+		elements = { 10, 30-30, 30, 35 }
+	}
+}
+EOF
-- 
2.45.3

