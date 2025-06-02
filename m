Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A43819E98B
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Jun 2025 12:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748866355; cv=none; b=OZAhZkfYyJB2EFjFMTHKabX00Ql9os3Bs1TXWKIgGf9zttIOWKI9Lmjx3626XbMr1WCgbZrsJ74fy9gC6G5TMiLOFLlwlFHM6T/wiC7mrwCfn/FgKZyymwZ8fif1hKAyV9s7IMmRFtYi3WTlWF3RaJKV/SDr4PK/IvHstEfUq74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748866355; c=relaxed/simple;
	bh=wCWhcDJxSCRujaD54m6Gy5eXndx1T6BQWQF78UzVlkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mH/9D4LSJSWZxBVTYkoOTqMQTb1GkAohojpm4NiGrmSh5X7Uu7KAHbOCPEvvvqgGsIOODleMLH8dKdkuMkc9QFtyFm/XCkvMv4sNjQckLuZI1EN4N1+8zJiaG4y+tFcpaO6iWLr7QkFe8n03+C9s8Yb0CV48eHPn9JYtJqPO9/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2495560532; Mon,  2 Jun 2025 14:12:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: fix json single-flag output for fib & synproxy
Date: Mon,  2 Jun 2025 14:12:16 +0200
Message-ID: <20250602121219.3392-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commits change output format but did not adjust existing tests:
  inet/fib.t: WARNING: line 16: '{"nftables": ..

Fixes: 38f99ee84fe6 ("json: Print single synproxy flags as non-array")
Fixes: dbe5c44f2b89 ("json: Print single fib flag as non-array")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/fib.t.json.output      | 32 ++++++++++++++++++++++++++++
 tests/py/inet/synproxy.t.json.output | 17 +++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 tests/py/inet/synproxy.t.json.output

diff --git a/tests/py/inet/fib.t.json.output b/tests/py/inet/fib.t.json.output
index 52cd46bc0e12..e21f1e72c636 100644
--- a/tests/py/inet/fib.t.json.output
+++ b/tests/py/inet/fib.t.json.output
@@ -37,3 +37,35 @@
     }
 ]
 
+# fib daddr oif exists
+[
+    {
+        "match": {
+            "left": {
+                "fib": {
+                    "flags": "daddr",
+                    "result": "oif"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# fib daddr oif missing
+[
+    {
+        "match": {
+            "left": {
+                "fib": {
+                    "flags": "daddr",
+                    "result": "oif"
+                }
+            },
+            "op": "==",
+            "right": false
+        }
+    }
+]
+
diff --git a/tests/py/inet/synproxy.t.json.output b/tests/py/inet/synproxy.t.json.output
new file mode 100644
index 000000000000..e32cdfb885e1
--- /dev/null
+++ b/tests/py/inet/synproxy.t.json.output
@@ -0,0 +1,17 @@
+# synproxy timestamp
+[
+    {
+        "synproxy": {
+            "flags": "timestamp"
+        }
+    }
+]
+
+# synproxy sack-perm
+[
+    {
+        "synproxy": {
+            "flags": "sack-perm"
+        }
+    }
+]
-- 
2.49.0

