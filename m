Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10624146589
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712610952; cv=none; b=KuWMSF9pzGJ93AWXaCkdj0W0if09Xg5IxEPaU498cyBsK6zHUOcElmNzlA21Eso4N48+Djpuv3qjLeihAsa4w2akIDAiVOFRRLyc+ABvf9mcE318VTynXwfCVH0ZYtoG3LfYVAUeGIWwSEa7nMR7KVZ25ok+sv/nhGHKcJC12Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712610952; c=relaxed/simple;
	bh=kSNIYfpI89IxVpyMMcZ2uhmxHwxLIERgyLHFspoeGZQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m8q/NlrHLTdBOzwhM4taf5t9bBEMen6LvEafaDjnBOF0s+zYbjgX2ejS5z4EMvQf31o/w5n68QKGik51QwGCpE3A7E93vbriF7Kw40Jo9iyJcEXcKoxaM3ax0wyRY3oPT5rlC77mU9YZPh8hiHTfoQNb3aSbtfIA438P6vy3AYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] tests: shell: chains/{netdev_netns_gone,netdev_chain_dev_gone} require inet/ingress support
Date: Mon,  8 Apr 2024 23:15:38 +0200
Message-Id: <20240408211540.311822-3-pablo@netfilter.org>
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

Fixes: 6847a7ce0fc9 ("tests: shell: cover netns removal for netdev and inet/ingress basechains")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/chains/netdev_chain_dev_gone | 2 ++
 tests/shell/testcases/chains/netdev_netns_gone     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tests/shell/testcases/chains/netdev_chain_dev_gone b/tests/shell/testcases/chains/netdev_chain_dev_gone
index 77f828d50df0..99933a31dd7d 100755
--- a/tests/shell/testcases/chains/netdev_chain_dev_gone
+++ b/tests/shell/testcases/chains/netdev_chain_dev_gone
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_ingress)
+
 set -e
 
 iface_cleanup() {
diff --git a/tests/shell/testcases/chains/netdev_netns_gone b/tests/shell/testcases/chains/netdev_netns_gone
index e6b6599691bc..3a92c99e667e 100755
--- a/tests/shell/testcases/chains/netdev_netns_gone
+++ b/tests/shell/testcases/chains/netdev_netns_gone
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_ingress)
+
 set -e
 
 rnd=$(mktemp -u XXXXXXXX)
-- 
2.30.2

