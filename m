Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BD544C8F;
	Sun, 12 May 2024 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530491; cv=none; b=mDppOVkg+wT0spIBAZr3w4pmkk/aZqzStPIfHxSCJqq0OSk2sBVsO9+kVmBOsMXzmtnybso0f/zCpdesZVzdcF9vlbyooavl43OZjFfJGgB7BQMAvptvyXM/outgKdjxWwmUkbytrMjUam+sEyvVzAqgvKY4JzjkU6xq51qsAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530491; c=relaxed/simple;
	bh=9npD0TDw3o2mX9t5lmQ8iUe5npj/q4ysiciVemWe8TI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LzKSYDuOnNBJC5L/MqVu/NJDapWoJqwub+FpAFo8Yc5VTypRx53GXWK2/y4X7Z5FxPN5Z4WU5vcYfVZyf88xQD2aB3wv+B0OodYuOncDw+mwe45LibK4jyK0Yrv2ECa7dTckMnUMM3AXBwVLURulkgUNq2NuAm47+MqLoA1DOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 02/17] netfilter: nf_tables: remove NETDEV_CHANGENAME from netdev chain event handler
Date: Sun, 12 May 2024 18:14:21 +0200
Message-Id: <20240512161436.168973-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
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
index d170758a1eb5..7010541fcca6 100644
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
@@ -367,8 +364,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_CHANGENAME)
+	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(ctx.net);
-- 
2.30.2

