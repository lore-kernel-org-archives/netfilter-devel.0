Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BEE1922FB
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931122; cv=none; b=LqOBH74E/tXZ5bXQlJtx6EHQ16hlRxYO/A1Rdw9e7zbZxRgm+4OuI/7M8Ewdx73knZ88lAA2iygUjQE0fiYajUk4YiVaRXIN06HKNVQwK2dROyMKDxa8TT7tPObjy/uMmRgI4AVnFnQdxbnv0jnFCiVl8uM1gwSpImx2Gc08dnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931122; c=relaxed/simple;
	bh=6AkAV5BZNNPjMkOXTpLpwChmF2ARrC/Z21WhDMqESBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tBPISueTv8L2Omy3ZKEkYIb048Oaqp819YMj+Z1TAcGC0McXcqwTcyV5ytRGsbUNUu4HMAhhyKM5kaRQN7sOFp8dQaCiVLt1w0xEJdMgN827m1fDz9fIwYLglibzbv9fajpdjRFw49Pw5sx/PfYXjGk7QtrN6HzC8RSgLuHqOnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: eric@garver.life
Subject: [PATCH nft 4/5] cache: relax requirement for replace rule command
Date: Thu, 29 Aug 2024 13:31:52 +0200
Message-Id: <20240829113153.1553089-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240829113153.1553089-1-pablo@netfilter.org>
References: <20240829113153.1553089-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need for full cache, this command relies on the rule handle which is
not validated from userspace. Cache requirements are similar to those
of add/create/delete rule commands.

This speeds up incremental updates with large rulesets.

Extend tests/coverage for rule replacement.

Fixes: 01e5c6f0ed03 ("src: add cache level flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c                                   |  2 +-
 .../testcases/rule_management/0004replace_0   |  8 ++-
 .../dumps/0004replace_0.json-nft              | 49 ++++++++++++++++++-
 .../rule_management/dumps/0004replace_0.nft   | 11 ++++-
 4 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index fce71eed3452..db7dfd96081d 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -495,7 +495,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags = evaluate_cache_add(cmd, flags);
 			break;
 		case CMD_REPLACE:
-			flags = NFT_CACHE_FULL;
+			flags = NFT_CACHE_TABLE | NFT_CACHE_SET;
 			break;
 		case CMD_DELETE:
 		case CMD_DESTROY:
diff --git a/tests/shell/testcases/rule_management/0004replace_0 b/tests/shell/testcases/rule_management/0004replace_0
index c3329af500d3..18dc4a9fe30b 100755
--- a/tests/shell/testcases/rule_management/0004replace_0
+++ b/tests/shell/testcases/rule_management/0004replace_0
@@ -6,5 +6,9 @@
 set -e
 $NFT add table t
 $NFT add chain t c
-$NFT add rule t c accept	# should have handle 2
-$NFT replace rule t c handle 2 drop
+$NFT 'add set t s1 { type ipv4_addr; }'
+$NFT 'add set t s2 { type ipv4_addr; flags interval; }'
+$NFT add rule t c accept        # should have handle 4
+$NFT replace rule t c handle 4 drop
+$NFT replace rule t c handle 4 ip saddr { 1.1.1.1, 2.2.2.2 }
+$NFT replace rule t c handle 4 ip saddr @s2 ip daddr { 3.3.3.3, 4.4.4.4 }
diff --git a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
index 5d0b7d066e83..767e80f14ff2 100644
--- a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
@@ -22,6 +22,27 @@
         "handle": 0
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s1",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s2",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "flags": [
+          "interval"
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
@@ -30,7 +51,33 @@
         "handle": 0,
         "expr": [
           {
-            "drop": null
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              "right": "@s2"
+            }
+          },
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              },
+              "right": {
+                "set": [
+                  "3.3.3.3",
+                  "4.4.4.4"
+                ]
+              }
+            }
           }
         ]
       }
diff --git a/tests/shell/testcases/rule_management/dumps/0004replace_0.nft b/tests/shell/testcases/rule_management/dumps/0004replace_0.nft
index e20952ef573e..803c0debb737 100644
--- a/tests/shell/testcases/rule_management/dumps/0004replace_0.nft
+++ b/tests/shell/testcases/rule_management/dumps/0004replace_0.nft
@@ -1,5 +1,14 @@
 table ip t {
+	set s1 {
+		type ipv4_addr
+	}
+
+	set s2 {
+		type ipv4_addr
+		flags interval
+	}
+
 	chain c {
-		drop
+		ip saddr @s2 ip daddr { 3.3.3.3, 4.4.4.4 }
 	}
 }
-- 
2.30.2

