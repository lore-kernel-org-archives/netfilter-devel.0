Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C6183CCB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720647720; cv=none; b=JwwVVLPBR7ZnLkmgmv2tNxaXiY5fGIbEiYTiYVzLr+PWy4xEn9JV2v0SXXkkZYrOb9guOwcGUpPhFmgf22EQD1QS18FrHAbBV8ZQBdDAQdkVEt9uPVEGtJ1Bvc4BKdlClBLR88RGcxx163InZi77MuRwKN8xxs42F6qyHTkGkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720647720; c=relaxed/simple;
	bh=ycfvny9PsMptAuSCMP6syK2Y6fspHygrA5wkR3Ozbb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt/kczFCTEYrGxKORV5kucj52Mqtgla8joiZ2oYkKwCQ5vkWEgdXa3flmUDaksb2fla+AIR3O7K+IV4+hogrtlHEMaD3y2xLT6wRuN0vF07ZIYXhzIuI3CS8bl+g09fjHeiOqAi6xFVfz89ANAvEWl2322kI4hd6YnmpTAUZ9Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sRf4W-0000mh-Hg; Wed, 10 Jul 2024 23:41:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: connect chains to hook point
Date: Wed, 10 Jul 2024 23:42:20 +0200
Message-ID: <20240710214224.11841-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240710214224.11841-1-fw@strlen.de>
References: <20240710214224.11841-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These tests should fail because they contain a loop or exceed the jump stack.

But this depends on the kernel validating chains that are not bound to any
basechain/hook point.

Wire up the initial chain to filter type.

Without this tests will start to fail when kernel stops validating chains
that are not reachable by any base chain.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/chains/0003jump_loop_1                | 3 ++-
 tests/shell/testcases/chains/0010endless_jump_loop_1        | 2 +-
 tests/shell/testcases/chains/0011endless_jump_loop_1        | 2 +-
 tests/shell/testcases/chains/0018check_jump_loop_1          | 2 +-
 tests/shell/testcases/chains/dumps/0003jump_loop_1.json-nft | 6 +++++-
 tests/shell/testcases/chains/dumps/0003jump_loop_1.nft      | 1 +
 .../testcases/chains/dumps/0010endless_jump_loop_1.json-nft | 6 +++++-
 .../testcases/chains/dumps/0010endless_jump_loop_1.nft      | 1 +
 .../testcases/chains/dumps/0011endless_jump_loop_1.json-nft | 6 +++++-
 .../testcases/chains/dumps/0011endless_jump_loop_1.nft      | 1 +
 .../testcases/chains/dumps/0018check_jump_loop_1.json-nft   | 6 +++++-
 .../shell/testcases/chains/dumps/0018check_jump_loop_1.nft  | 1 +
 tests/shell/testcases/transactions/0023rule_1               | 2 +-
 tests/shell/testcases/transactions/anon_chain_loop          | 2 +-
 14 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/tests/shell/testcases/chains/0003jump_loop_1 b/tests/shell/testcases/chains/0003jump_loop_1
index 80e243f07bdb..1a8eaf686747 100755
--- a/tests/shell/testcases/chains/0003jump_loop_1
+++ b/tests/shell/testcases/chains/0003jump_loop_1
@@ -5,8 +5,9 @@ set -e
 MAX_JUMPS=16
 
 $NFT add table t
+$NFT "add chain t c1 { type filter hook prerouting priority 0; }"
 
-for i in $(seq 1 $MAX_JUMPS)
+for i in $(seq 2 $MAX_JUMPS)
 do
 	$NFT add chain t c${i}
 done
diff --git a/tests/shell/testcases/chains/0010endless_jump_loop_1 b/tests/shell/testcases/chains/0010endless_jump_loop_1
index 5d3ef2393331..6000e5d7dbf3 100755
--- a/tests/shell/testcases/chains/0010endless_jump_loop_1
+++ b/tests/shell/testcases/chains/0010endless_jump_loop_1
@@ -3,7 +3,7 @@
 set -e
 
 $NFT add table t
-$NFT add chain t c
+$NFT add chain "t c { type filter hook input priority 0; }"
 
 # kernel should return ELOOP
 $NFT add rule t c tcp dport vmap {1 : jump c} 2>/dev/null || exit 0
diff --git a/tests/shell/testcases/chains/0011endless_jump_loop_1 b/tests/shell/testcases/chains/0011endless_jump_loop_1
index d75932d7a7ca..66abf8d04543 100755
--- a/tests/shell/testcases/chains/0011endless_jump_loop_1
+++ b/tests/shell/testcases/chains/0011endless_jump_loop_1
@@ -3,7 +3,7 @@
 set -e
 
 $NFT add table t
-$NFT add chain t c1
+$NFT add chain "t c1 { type filter hook forward priority 0; }"
 $NFT add chain t c2
 $NFT add map t m {type inet_service : verdict \;}
 $NFT add element t m {2 : jump c2}
diff --git a/tests/shell/testcases/chains/0018check_jump_loop_1 b/tests/shell/testcases/chains/0018check_jump_loop_1
index b87520f287d7..1e674d3dc12b 100755
--- a/tests/shell/testcases/chains/0018check_jump_loop_1
+++ b/tests/shell/testcases/chains/0018check_jump_loop_1
@@ -3,7 +3,7 @@
 set -e
 
 $NFT add table ip filter
-$NFT add chain ip filter ap1
+$NFT add chain ip filter ap1 "{ type filter hook input priority 0; }"
 $NFT add chain ip filter ap2
 $NFT add rule ip filter ap1 jump ap2
 
diff --git a/tests/shell/testcases/chains/dumps/0003jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0003jump_loop_1.json-nft
index ceef32242503..d197e123bd67 100644
--- a/tests/shell/testcases/chains/dumps/0003jump_loop_1.json-nft
+++ b/tests/shell/testcases/chains/dumps/0003jump_loop_1.json-nft
@@ -19,7 +19,11 @@
         "family": "ip",
         "table": "t",
         "name": "c1",
-        "handle": 0
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": 0,
+        "policy": "accept"
       }
     },
     {
diff --git a/tests/shell/testcases/chains/dumps/0003jump_loop_1.nft b/tests/shell/testcases/chains/dumps/0003jump_loop_1.nft
index 7054cde45963..8d89bc40a6c4 100644
--- a/tests/shell/testcases/chains/dumps/0003jump_loop_1.nft
+++ b/tests/shell/testcases/chains/dumps/0003jump_loop_1.nft
@@ -1,5 +1,6 @@
 table ip t {
 	chain c1 {
+		type filter hook prerouting priority filter; policy accept;
 		jump c2
 	}
 
diff --git a/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.json-nft
index db64cdbcc447..af99873dbeda 100644
--- a/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.json-nft
+++ b/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.json-nft
@@ -19,7 +19,11 @@
         "family": "ip",
         "table": "t",
         "name": "c",
-        "handle": 0
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
       }
     }
   ]
diff --git a/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.nft b/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.nft
index 1e0d1d603739..62fefaff185b 100644
--- a/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.nft
+++ b/tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.nft
@@ -1,4 +1,5 @@
 table ip t {
 	chain c {
+		type filter hook input priority filter; policy accept;
 	}
 }
diff --git a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
index e1a2262fdf04..75a4d895fc3e 100644
--- a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
+++ b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
@@ -19,7 +19,11 @@
         "family": "ip",
         "table": "t",
         "name": "c1",
-        "handle": 0
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "accept"
       }
     },
     {
diff --git a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.nft b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.nft
index ca0a7378a584..d35736e8ded6 100644
--- a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.nft
+++ b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.nft
@@ -5,6 +5,7 @@ table ip t {
 	}
 
 	chain c1 {
+		type filter hook forward priority filter; policy accept;
 		tcp dport vmap @m
 	}
 
diff --git a/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.json-nft
index 7294c8411b20..ac7e11995848 100644
--- a/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.json-nft
+++ b/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.json-nft
@@ -19,7 +19,11 @@
         "family": "ip",
         "table": "filter",
         "name": "ap1",
-        "handle": 0
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
       }
     },
     {
diff --git a/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.nft b/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.nft
index 437900bc6793..bdd0ead778cb 100644
--- a/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.nft
+++ b/tests/shell/testcases/chains/dumps/0018check_jump_loop_1.nft
@@ -1,5 +1,6 @@
 table ip filter {
 	chain ap1 {
+		type filter hook input priority filter; policy accept;
 		jump ap2
 	}
 
diff --git a/tests/shell/testcases/transactions/0023rule_1 b/tests/shell/testcases/transactions/0023rule_1
index e58c088c2e84..863bcde43aac 100755
--- a/tests/shell/testcases/transactions/0023rule_1
+++ b/tests/shell/testcases/transactions/0023rule_1
@@ -1,7 +1,7 @@
 #!/bin/bash
 
 RULESET="add table x
-add chain x y
+add chain x y { type filter hook input priority 0; }
 add rule x y jump y"
 
 # kernel must return ELOOP
diff --git a/tests/shell/testcases/transactions/anon_chain_loop b/tests/shell/testcases/transactions/anon_chain_loop
index 2fd61810753d..3053d166c286 100755
--- a/tests/shell/testcases/transactions/anon_chain_loop
+++ b/tests/shell/testcases/transactions/anon_chain_loop
@@ -3,7 +3,7 @@
 # anon chains with c1 -> c2 recursive jump, expect failure
 $NFT -f - <<EOF
 table ip t {
- chain c2 { }
+ chain c2 { type filter hook input priority 0; }
  chain c1 { }
 }
 
-- 
2.44.2

