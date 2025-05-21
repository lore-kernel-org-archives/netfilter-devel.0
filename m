Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E39829C35C
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860285; cv=none; b=N+8LS2nsLoc+5Q9eOqhvwpiGL3ol/0oN3PwafCf54A54UwWWtOoILX34AWXmLWStlOaJivO8dRg5M4j9IrfPKlPUBYDwA31bFwNCHEt1mgfV6ncV11zQdRR6nB4+RkGAiYrIx7zSaHE+3yqfZcjOcsVRu28A1oa5mt7zkpYOWXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860285; c=relaxed/simple;
	bh=cZA/12wV3UmfUztHO8zsdY8LFPJMvTcvVB6RxJWdjnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iukH7OtUZ+AsSgQYrF2WP6QOXp6Bj8itIMcC7GTfklV3eoykRQs80klKZ4LZz7UaczvhRAMcoiRi4/jxjQk7KxiRORjoFjd5Br1ZIssPR2FXBYurC7zEQEQIaM/c+OHFIS8zb06xAGVvd6KF7vASqeVevvV1W7MFYbIm2rPyGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kgnl8dTD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kgnl8dTD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7cmuF2XD9C2HXfegj8bal35S7zBzLe2hb7n/lZ1EJ+Q=; b=kgnl8dTDKLLGh6c8Sowzw8qHGo
	A9K7oWjLXMpVvsCpK5uL9tm2oDeVzl6A73aAoy2ByR7flWwyoAXd+R8gzQuRh1yyvKXNIwoFuXAng
	aX8112fATdrvWJHIiRyshmjqcpSQrupJjZCxdUrKBBPfy2zRypzlquT7ybhdO/Fu46A55uI4FwoFn
	/rqAVrRo+7atuSv2BAKYWBadw6J8vg7MEro330wbFrwxB2EJgE70oD9rW2yJcgXwlxedwbeMH7QOv
	V67hvRi4UxFFbkMrmlULKEGywbHj3cBdRSDK7AulT0YnxQDfV5HYrIJWic3uz8WBOIAsnqrnXU71M
	pUshEu8A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIr-000000007Qi-2PD9;
	Wed, 21 May 2025 22:44:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 11/13] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Wed, 21 May 2025 22:44:32 +0200
Message-ID: <20250521204434.13210-12-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521204434.13210-1-phil@nwl.cc>
References: <20250521204434.13210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User space may pass non-nul-terminated NFTA_DEVICE_NAME attribute values
to indicate a suffix wildcard.
Expect for multiple devices to match the given prefix in
nft_netdev_hook_alloc() and populate 'ops_list' with them all.
When checking for duplicate hooks, compare the shortest prefix so a
device may never match more than a single hook spec.
Finally respect the stored prefix length when hooking into new devices
from event handlers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v6:
- Adjust changes in nft_netdev_hook_alloc() to new previous patch
  sorting jump labels in that function.
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
2.49.0

