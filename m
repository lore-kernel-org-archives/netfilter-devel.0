Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF9F1DDC01
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2025 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736983158; cv=none; b=GwCbrHz0O0fbMLlGbwIqUkFNEXC5HnUdxg/mRg6Ru5Fb4ddWKo8n3LJOPDRr9TGIy9jMsguaSYmROwZ1SE67sBcYKu4ge0a61EXlAVRB1m2N/9+lgjNv3tuayrUIDJQuL6gPUOE9Zmx6z8izT1tOsC9ErcqNjMNMm8uzbL2dFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736983158; c=relaxed/simple;
	bh=uE3fX4Lf0ynfJ3NAZ5FI3oHzwnxncCLneyfLWC/JDbw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SAtktQLzk2EdmefsXUp0b++zGOtw4EixzUxlxzrl3ZE6n51RBVFvkPpL2yvnGha0m1/vHCDtdYCQjUrA9C7tmUUbUwnk7R7h4n1h+P1o1roEjb3hzJXB1Q6a2gWIfJpOaAJnFbkODcSpKRDUtgpX+xgviM9vH9fa3/7dXr1R2FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft] tests: shell: delete netdev chain after test
Date: Thu, 16 Jan 2025 00:19:00 +0100
Message-Id: <20250115231900.436655-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This update is needed for kernel patch:

  ("netfilter: nf_tables: Tolerate chains with no remaining hooks")

otherwise this hits DUMP FAILED in newer kernels.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/chains/netdev_chain_0 | 1 +
 tests/shell/testcases/json/netdev           | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
index a323e6ec3324..f2eae6a1554a 100755
--- a/tests/shell/testcases/chains/netdev_chain_0
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -27,3 +27,4 @@ $NFT -f - <<< "$RULESET"
 $NFT add chain netdev x y '{ devices = { d0 }; }'
 $NFT add chain netdev x y '{ devices = { d1, d2, lo }; }'
 $NFT delete chain netdev x y '{ devices = { lo }; }'
+$NFT delete chain netdev x y
diff --git a/tests/shell/testcases/json/netdev b/tests/shell/testcases/json/netdev
index 8c16cf42baa0..23776c35d97d 100755
--- a/tests/shell/testcases/json/netdev
+++ b/tests/shell/testcases/json/netdev
@@ -26,3 +26,5 @@ if [ "$NFT_TEST_HAVE_json" = n ]; then
 	echo "Test partially skipped due to missing JSON support."
 	exit 77
 fi
+
+$NFT delete chain netdev test_table test_chain
-- 
2.30.2

