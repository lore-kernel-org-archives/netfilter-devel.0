Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303121474AF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 21:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712610952; cv=none; b=gSfE3bhznLamVMRgpJoSiZ5jKZoyHy5xeiIb9MT7R2hYWCXq88+FuH36HUMxSEA3lqMQ9s/DT2cno4QgU0RcngPjFJ/6COSYQVkb0S3mBe0aD7DXIQchpO9EYNMLyw2nlqNkqrlkLs0m3SyErx+KH4YW54TCkdCP5ScKT0MBBKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712610952; c=relaxed/simple;
	bh=iByNcO/TCFLOBxv1oN+wO9vd9hRS/e8vC3XAfZ4QCr8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XAF/Ridbzh2ZEKS8gyqKNSwqENktZ1GhlLdMaAgEu83m7w1ABOpJ+XUxoxNZxWX4YSeBAS2jCPl8R32r3N6HiEm4LCHAb+WTxHWuaEwgkjg76pWCxQ5dIn9VsGPocmewbnSmLD02ePHcd2Y8IAUj4cUgYWH/eS2nlEJqQjZuyeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] tests: shell: maps/{vmap_unary,named_limits} require pipapo set backend
Date: Mon,  8 Apr 2024 23:15:39 +0200
Message-Id: <20240408211540.311822-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240408211540.311822-1-pablo@netfilter.org>
References: <20240408211540.311822-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... sets/typeof_sets_concat needs it too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/maps/named_limits       | 2 ++
 tests/shell/testcases/maps/vmap_unary         | 2 ++
 tests/shell/testcases/packetpath/set_lookups  | 2 ++
 tests/shell/testcases/sets/typeof_sets_concat | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/tests/shell/testcases/maps/named_limits b/tests/shell/testcases/maps/named_limits
index 5604f6caeda6..ac8e434cce05 100755
--- a/tests/shell/testcases/maps/named_limits
+++ b/tests/shell/testcases/maps/named_limits
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 dumpfile=$(dirname $0)/dumps/$(basename $0).nft
 
 $NFT -f "$dumpfile" || exit 1
diff --git a/tests/shell/testcases/maps/vmap_unary b/tests/shell/testcases/maps/vmap_unary
index 4038d1c109ff..f4e1f01215ec 100755
--- a/tests/shell/testcases/maps/vmap_unary
+++ b/tests/shell/testcases/maps/vmap_unary
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 RULESET="table ip filter {
diff --git a/tests/shell/testcases/packetpath/set_lookups b/tests/shell/testcases/packetpath/set_lookups
index 84a0000af665..851598580796 100755
--- a/tests/shell/testcases/packetpath/set_lookups
+++ b/tests/shell/testcases/packetpath/set_lookups
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 $NFT -f /dev/stdin <<"EOF"
diff --git a/tests/shell/testcases/sets/typeof_sets_concat b/tests/shell/testcases/sets/typeof_sets_concat
index 07820b7c4fdd..34465f1da0be 100755
--- a/tests/shell/testcases/sets/typeof_sets_concat
+++ b/tests/shell/testcases/sets/typeof_sets_concat
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 dumpfile=$(dirname $0)/dumps/$(basename $0).nft
 
-- 
2.30.2

