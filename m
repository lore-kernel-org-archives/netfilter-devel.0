Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8632BCF44;
	Thu, 22 May 2025 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932819; cv=none; b=n29azeKglkzoTKsJUoLO3daA+/uzgRCkBtPDtDxGjXi+KFCIlWuDBR34uii3LEC7295baynNvODORUkTWQRmTUDYkei+GzmZJ468FGHJyscEr+Z7ibSO1BFxJzod09Xbhf/dh4bJGx44VZLThhS1dIFOSAfdASia6+raN7Zwdeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932819; c=relaxed/simple;
	bh=R3ku4dQRx0EnSTgnWW4dEk/tS7kOM5uKTUJUGxk5GgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UKlUGLeLhgy6S5CmWz7r45581W3UTB7wmaLXG/qkhvCQzMJX8XFiyJWBo1frLTTZXF8JjwXMDaouihwLSy47LaQRvNSYgSqa1AmE7hACER7D0GZr5CTQ2NfIfEIrkalNKGRRS4/VV5VxatkILnf5jdRkAe1xsnuhYTAVaDzqi6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E0YQtH3Q; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d+RJelty; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E0YQtH3Q";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d+RJelty"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 69D8060715; Thu, 22 May 2025 18:53:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932816;
	bh=VqiTHhMZ9biq751h23zm4+9hDI1M7W9afAkweMrigW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0YQtH3Qdx3SCvlO4uXZlXe9xRHxUM05+yZI2KB+8/TWYrxSns/btYJ8nyKkCPCpD
	 NXPApfJCjG6W+N1jiBB2U2QrCnqPilduI8qmW5MU1Jmzo6TFajQaWJh6x7k4QI3eEO
	 U5XwAHIto8P25QQoFXSyEXY4WPYhvlveFJodbhLPYKBEadCK2syuNz63Td/nkbkSFO
	 QLR8su6+/krKDb57wilWMRo9DDudO2LXEpm6Yn4eHiPPWpZZcqKLWk3g9oVAOy5w2d
	 HOnLSYU9b69ufGyIoUKRJ0l9VvvyrdxxABksNf4KPjARs6mjojAFrjPglwxcRy2RFa
	 JoiKH7LgQhQYw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 083A36073E;
	Thu, 22 May 2025 18:53:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932783;
	bh=VqiTHhMZ9biq751h23zm4+9hDI1M7W9afAkweMrigW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+RJelty5+bXDmVdDek/Ba/1s3+apKKAQ93iXpTs9W1rEZ89eH72UIFmpM54r3ycD
	 /byj9cZ2IoohohnPaHzewV90BUQl6fJ4jaANM2wupDzUEHk6H9pkHvHOOoXElXALXq
	 NM0ufpD5gAwLwQLdfti0Q2luM43BZkEQR9r5PQaELS7QkSGqgYvcl1JmCMDMjLa/yC
	 qSGGefUtZ3wGt3uHVN0A7EeFTe703reNwOFUgtcfJiKJDVtZI6NLUz478+wS3bFocq
	 +PI+rvxiBE4s84qHJY6+tQxHUTJn1+N2Z7MjSHR9T2t1ff+3OwlxKvINYKYdNjAwfC
	 s51VUP90T58YQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 24/26] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Thu, 22 May 2025 18:52:36 +0200
Message-Id: <20250522165238.378456-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

User space may pass non-nul-terminated NFTA_DEVICE_NAME attribute values
to indicate a suffix wildcard.
Expect for multiple devices to match the given prefix in
nft_netdev_hook_alloc() and populate 'ops_list' with them all.
When checking for duplicate hooks, compare the shortest prefix so a
device may never match more than a single hook spec.
Finally respect the stored prefix length when hooking into new devices
from event handlers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    | 29 ++++++++++++++---------------
 net/netfilter/nft_chain_filter.c |  2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fabc82c98871..a7240736f98e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2330,24 +2330,22 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, hook->ifname);
-	if (!dev) {
-		err = -ENOENT;
-		goto err_hook_free;
-	}
+	for_each_netdev(net, dev) {
+		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
+			continue;
 
-	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
-	if (!ops) {
-		err = -ENOMEM;
-		goto err_hook_free;
+		ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
+		if (!ops) {
+			err = -ENOMEM;
+			goto err_hook_free;
+		}
+		ops->dev = dev;
+		list_add_tail(&ops->list, &hook->ops_list);
 	}
-	ops->dev = dev;
-	list_add_tail(&ops->list, &hook->ops_list);
-
 	return hook;
 
 err_hook_free:
-	kfree(hook);
+	nft_netdev_hook_free(hook);
 	return ERR_PTR(err);
 }
 
@@ -2357,7 +2355,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strcmp(hook->ifname, this->ifname))
+		if (!strncmp(hook->ifname, this->ifname,
+			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
 	}
 
@@ -9696,7 +9695,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b59f8be6370e..b16185e9a6dd 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -328,7 +328,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
-- 
2.30.2

