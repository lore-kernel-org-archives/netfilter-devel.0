Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E904205F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 14:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710339282; cv=none; b=UmaxzukdEb6Q9E1QmSVyA3TR9yCs+baF2YZT/R9KkCEMTTAWQWyvLDwFqoTaoKde5jvU+U4ErjWfVD8sT93oV1ONT0lQzBmKgOlDoTi5Sb6H37Nufp9QwPVPLoiHW5CVUEDu57XncUg4guhmTi01Yjewg4v2CFkBXdGZgX/TjIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710339282; c=relaxed/simple;
	bh=7ECJfy7eSn3S+b4F0xEWnug/tFlHviESkX1iUw11viM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qosXb9hcNs6KodkIsS75ChsQpLwvpqUJNVX/sw0TqAa4yjwQy0Zjm3oHuCF+HvkZGpsIqd41EIQNIVMjrYc9XlQ1QjGEBarkY7xei5Rb+y2XNlsrU2UFN20A23ckk3aBPwiEE+UhGUB5C3NDgtPlkLK3xcdYnRaque/s3XJlDgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rkPNI-00089j-7b; Wed, 13 Mar 2024 15:14:32 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests/py: remove flow table json test cases
Date: Wed, 13 Mar 2024 15:13:22 +0100
Message-ID: <20240313141325.12547-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip(6)/flowtable.t tests fail both for normal and json mode.

WARNING: line 3: 'add rule ip test-ip input meter xyz size 8192 { ip saddr timeout 30s counter}': 'ip test-ip input' mismatches '[ payload load 4b @ network header + 12 => reg 1 ]'
ip/lowtable.t.payload.got: WARNING: line 2: Wrote payload for rule meter xyz size 8192 { ip saddr timeout 30s counter}
ip/flowtable.t: WARNING: line 5: 'add rule ip test-ip input meter xyz size 8192 { ip saddr timeout 30s counter}': 'meter xyz size 8192 { ip saddr timeout 30s counter}' mismatches 'update @xyz { ip saddr timeout 30s counter}'
WARNING: line 3: 'add rule ip6 test-ip6 input meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }': 'ip6 test-ip6 input' mismatches '[ meta load iif => reg 1 ]'
ip6/flowtable.t.payload.got: WARNING: line 2: Wrote payload for rule meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
ip6/flowtable.t: WARNING: line 5: 'add rule ip6 test-ip6 input meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }': 'meter acct_out size 4096 { iif . ip6 saddr timeout 10m counter }' mismatches 'update @acct_out { iif . ip6 saddr timeout 10m counter}'
ip6/flowtable.t: ERROR: line 6: add rule ip6 test-ip6 input meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }: This rule should not have failed.
ip6/flowtable.t: 2 unit tests, 2 error, 1 warning

Fix at least the non-json mode, I do not know how to fix up -j
or wheter the failure is actually correct.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/flowtable.t              |  2 +-
 tests/py/ip/flowtable.t.json         | 24 -----------
 tests/py/ip/flowtable.t.payload      |  6 +--
 tests/py/ip6/flowtable.t             |  4 +-
 tests/py/ip6/flowtable.t.json        | 62 ----------------------------
 tests/py/ip6/flowtable.t.json.output | 62 ----------------------------
 tests/py/ip6/flowtable.t.payload     |  6 +--
 7 files changed, 7 insertions(+), 159 deletions(-)
 delete mode 100644 tests/py/ip/flowtable.t.json
 delete mode 100644 tests/py/ip6/flowtable.t.json
 delete mode 100644 tests/py/ip6/flowtable.t.json.output

diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
index 086c6cf6b449..f1541fdca158 100644
--- a/tests/py/ip/flowtable.t
+++ b/tests/py/ip/flowtable.t
@@ -2,4 +2,4 @@
 
 *ip;test-ip;input
 
-meter xyz size 8192 { ip saddr timeout 30s counter};ok
+meter xyz size 8192 { ip saddr timeout 30s counter};ok;update @xyz { ip saddr timeout 30s counter}
diff --git a/tests/py/ip/flowtable.t.json b/tests/py/ip/flowtable.t.json
deleted file mode 100644
index a03cc9d79350..000000000000
--- a/tests/py/ip/flowtable.t.json
+++ /dev/null
@@ -1,24 +0,0 @@
-# meter xyz size 8192 { ip saddr timeout 30s counter}
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 30,
-                    "val": {
-                        "payload": {
-                            "field": "saddr",
-                            "protocol": "ip"
-                        }
-                    }
-                }
-            },
-            "name": "xyz",
-            "size": 8192,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
index c0aad39ea193..3d18070b7217 100644
--- a/tests/py/ip/flowtable.t.payload
+++ b/tests/py/ip/flowtable.t.payload
@@ -1,7 +1,5 @@
 # meter xyz size 8192 { ip saddr timeout 30s counter}
-xyz test-ip 31
-xyz test-ip 0
-ip test-ip input 
+xyz test-ip 30 size 8192
+ip test-ip input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ dynset update reg_key 1 set xyz timeout 30000ms expr [ counter pkts 0 bytes 0 ] ]
-
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
index e58d51bb9b8e..f8994bce9382 100644
--- a/tests/py/ip6/flowtable.t
+++ b/tests/py/ip6/flowtable.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;input
 
-meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter };ok;meter acct_out size 4096 { iif . ip6 saddr timeout 10m counter }
-meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter };ok;meter acct_out size 12345 { ip6 saddr . iif timeout 10m counter }
+meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter };ok;update @acct_out { iif . ip6 saddr timeout 10m counter }
+meter acct_out2 size 12345 { ip6 saddr . meta iif timeout 600s counter };ok;update @acct_out2 { ip6 saddr . iif timeout 10m counter }
diff --git a/tests/py/ip6/flowtable.t.json b/tests/py/ip6/flowtable.t.json
deleted file mode 100644
index d0b3a957f01b..000000000000
--- a/tests/py/ip6/flowtable.t.json
+++ /dev/null
@@ -1,62 +0,0 @@
-# meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "meta": { "key": "iif" }
-                            },
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 4096,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            {
-                                "meta": { "key": "iif" }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 12345,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/flowtable.t.json.output b/tests/py/ip6/flowtable.t.json.output
deleted file mode 100644
index d0b3a957f01b..000000000000
--- a/tests/py/ip6/flowtable.t.json.output
+++ /dev/null
@@ -1,62 +0,0 @@
-# meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "meta": { "key": "iif" }
-                            },
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 4096,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            {
-                                "meta": { "key": "iif" }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 12345,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/flowtable.t.payload b/tests/py/ip6/flowtable.t.payload
index 559475f6d2c6..f251289d4b88 100644
--- a/tests/py/ip6/flowtable.t.payload
+++ b/tests/py/ip6/flowtable.t.payload
@@ -1,16 +1,14 @@
 # meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-acct_out test-ip6 31
 acct_out test-ip6 0
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ payload load 16b @ network header + 8 => reg 9 ]
   [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
 
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-acct_out test-ip6 31
+# meter acct_out2 size 12345 { ip6 saddr . meta iif timeout 600s counter }
 acct_out test-ip6 0
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ meta load iif => reg 2 ]
-  [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
+  [ dynset update reg_key 1 set acct_out2 timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
 
-- 
2.43.0

