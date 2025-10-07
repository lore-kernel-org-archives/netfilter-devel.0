Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D85023BD1A
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868928; cv=none; b=nqnL8jMnF6u/zhQQcdKKjRKg8RQChTagkDvq0heseEDLPHzysrJ9KF0KWM6Qi3NAyTVZc9UKD2uzFltgmSPiooy4tQGqNP6meo6dClq3mlbJNuQL7dSqMscruwnG4nHl9FSARNf7CqldreZk8Wz4IlxuloobdfFvwH1kQjZ2Z5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868928; c=relaxed/simple;
	bh=YezXjkvtD31xLCsozvOr9O6ePNAtZobsN3MFzVOAtII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H5WGfba6UM5Mb/kD+1ZwbJOr5XvGinRObwAbZ0aHTetLDKsfd20KgZKRSIVMae0fyyr3o5CPme/Mto/fptuPpRSq1v017ZM5+S2xHwW/xR6GSb5wsQSReekOSYvNIilwnXjxGMPZjFxPtDZ8HvRoaxGoQELndc36W5xbbn/qezI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5313C60299; Tue,  7 Oct 2025 22:28:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: fix name based checks with CONFIG_NF_TABLES=y
Date: Tue,  7 Oct 2025 22:28:23 +0200
Message-ID: <20251007202827.23737-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't include a trailing space, its only there if nftables is a module:

  hook ingress device foo2 {
     0000000000 chain netdev t c [nf_tables]
  }

with CONFIG_NF_TABLES=y, this gets listed as:
'0000000000 chain netdev t c\n'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/chains/netdev_chain_name_based_hook_0 | 2 +-
 tests/shell/testcases/flowtable/0016name_based_hook_0       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/chains/netdev_chain_name_based_hook_0 b/tests/shell/testcases/chains/netdev_chain_name_based_hook_0
index 8a8a60178408..2e37b23a410a 100755
--- a/tests/shell/testcases/chains/netdev_chain_name_based_hook_0
+++ b/tests/shell/testcases/chains/netdev_chain_name_based_hook_0
@@ -2,7 +2,7 @@
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
 
-cspec=' chain netdev t c '
+cspec=' chain netdev t c'
 $NFT add table netdev t
 $NFT add $cspec '{ type filter hook ingress priority 0; devices = { lo, foo* }; }'
 $NFT list hooks netdev device lo | grep -q "$cspec" || {
diff --git a/tests/shell/testcases/flowtable/0016name_based_hook_0 b/tests/shell/testcases/flowtable/0016name_based_hook_0
index 9a5559602715..19135b7e33cf 100755
--- a/tests/shell/testcases/flowtable/0016name_based_hook_0
+++ b/tests/shell/testcases/flowtable/0016name_based_hook_0
@@ -3,7 +3,7 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_list_hooks_flowtable_info)
 
-ftspec=' flowtable ip t ft '
+ftspec=' flowtable ip t ft'
 $NFT add table t
 $NFT add $ftspec '{ hook ingress priority 0; devices = { lo, foo* }; }'
 $NFT list hooks netdev device lo | grep -q "$ftspec" || {
-- 
2.49.1

