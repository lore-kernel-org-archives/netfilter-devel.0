Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093D821E0AE
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741611824; cv=none; b=brpu+0CJIHJgA01ppfhDRpLqptvQBsROT31BNJTng8UEVXVaRDXC9o3QEN+Y+INxf2Fg4DVcc8NVRa/OhTSwgNHUXqdt3fuH/m7D3FhkFwq54NOBJ9kDiPNnvm/0fCAS31RE/56skUOxvBmLbLwQIRibUbFtycNZBE9/TCdS7b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741611824; c=relaxed/simple;
	bh=B5XJnCEE/+RBWtlCi48KkNzrOkkKAIdMJt2/IEKu8ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZcTvSNpfE2CaaxkGVTh61gd1cQsuW9+8vAEoTtovexJW7/BQDBptRcvs+XK37wHLUMzks1oMCPfN3NcfNB7zIHK9WTj3KnkVznQBBZ7rHFtso7SiEJ0PQIyX5qOFs6u5hi6euJa72dBUgx316/4tbOrftPgRdiKS98SGM06uTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1trcn7-00065w-Kk; Mon, 10 Mar 2025 14:03:33 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: skip interval size tests on kernel that lack rbtree size fix
Date: Mon, 10 Mar 2025 13:42:29 +0100
Message-ID: <20250310124232.11796-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip these tests for older kernels.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/rbtree_size_limit.nft      | 10 ++++++++++
 tests/shell/testcases/sets/interval_size        |  2 ++
 tests/shell/testcases/sets/interval_size_random |  2 ++
 3 files changed, 14 insertions(+)
 create mode 100644 tests/shell/features/rbtree_size_limit.nft

diff --git a/tests/shell/features/rbtree_size_limit.nft b/tests/shell/features/rbtree_size_limit.nft
new file mode 100644
index 000000000000..7eb44face077
--- /dev/null
+++ b/tests/shell/features/rbtree_size_limit.nft
@@ -0,0 +1,10 @@
+# 8d738c1869f6 ("netfilter: nf_tables: fix set size with rbtree backend")
+# v6.14-rc1~162^2~7^2~13
+table inet x {
+        set y {
+                typeof ip saddr
+                flags interval
+                size 1
+                elements = { 10.1.1.0/24 }
+        }
+}
diff --git a/tests/shell/testcases/sets/interval_size b/tests/shell/testcases/sets/interval_size
index 6d0759672999..55a6cd4948e2 100755
--- a/tests/shell/testcases/sets/interval_size
+++ b/tests/shell/testcases/sets/interval_size
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_rbtree_size_limit)
+
 RULESET="table inet x {
 	set x {
 		typeof ip saddr
diff --git a/tests/shell/testcases/sets/interval_size_random b/tests/shell/testcases/sets/interval_size_random
index 701a1e73956c..3320b51245db 100755
--- a/tests/shell/testcases/sets/interval_size_random
+++ b/tests/shell/testcases/sets/interval_size_random
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_rbtree_size_limit)
+
 generate_ip() {
 	local first=($1)
 	echo -n "$first.$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
-- 
2.45.3

