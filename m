Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6F620323
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Mar 2024 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709627891; cv=none; b=Obfk7isNdCuRHDd7plGB5cbeLnSjlOr6O5GV3bQjOCGE1Tr77jnmnWIPH4J7mjBcZdD0/doXI0u3w2NUI0YIIbtUXD/yaFFgbIK1ljHjdksTgIHE3eR7G/H+OJAKnUMo3uxezulabyy308+B9LvOq2aRJwsi+LnfZqFZV/Pke+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709627891; c=relaxed/simple;
	bh=+zfB5EXU8KsNiWYSJcvBom1/UWvzekYlc3q7gAg1+8s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Gm3W3FQrR3NH8DJ9ENO8Bkv9sUZazPtCmgcJbFC40A8lO/kw2y8+9zusJ3XMtfdgGX7B5NsziqHTAPQkinbIQsMb5RVDTsNiIG1nLZ3Xh+QZqsz7Gg6rDVAkyBHSj3r4QPQLvLFmdEhWpWt6VVR1ThHPQ67F47E2jRxXgTYolvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: remove NETDEV_CHANGENAME from netdev chain event handler
Date: Tue,  5 Mar 2024 09:38:04 +0100
Message-Id: <20240305083804.184479-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Originally, device name used to be stored in the basechain, but it is
not the case anymore. Remove check for NETDEV_CHANGENAME.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 274b6f7e6bb5..2e4ced64d503 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -325,9 +325,6 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	struct nft_hook *hook, *found = NULL;
 	int n = 0;
 
-	if (event != NETDEV_UNREGISTER)
-		return;
-
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		if (hook->ops.dev == dev)
 			found = hook;
@@ -365,8 +362,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_CHANGENAME)
+	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(ctx.net);
-- 
2.30.2

