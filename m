Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175BB1A0BD3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143725; cv=none; b=FBoA4it9LqmScMsz0ZVbr+a+iHhWkNcPIUX193j/QH16pYZNfTvOdPId3+/KOJkd3R7+LMy29IQN2zuAb+jz1kxADt7UytVcnNyU6CnFGxDL+MzYmMGg7sMuJjNe7djePUG53Ut1HlBXn0xKN4ej7v2QhmtnxDfMhV81Hh3nLw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143725; c=relaxed/simple;
	bh=TRz+RZNR5nlPrlTJIIbeLMg18vJj4fXVclzkekqXPJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btmDUq4B8rodHdz/6gOJPrtIB0zS9tZKNqxW0D8EDoRwtWpJfPCdzXWPI1VVE5hHxboYVhCt5sfskTbxGAf9rKdtkmSvWjYzaWIuOqqwA8+HcyAjlk+GwZ1/lVGgE+ftsuMqjzj20X/3YcVC/M/yeHKAgH9CdwR6/D7eXUpSHRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SDCqoZnR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SDCqoZnR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tvnMCrfU58qp7P3UDQwIZ9rx3qmxn2URdF5feUvpc20=; b=SDCqoZnREP5KpDOheaUaPqI2KJ
	2JSOTVL2ILiz8kpeY/gBSbXswrC4GPG65X2BGe9cQqwRKN2lNPhsGh/u7AsYlWzSET1WO+XmHH6A5
	HZIxcut/SHqlpHBHaHI6/uu1c3zq0jhWLcYHA0300gJCYYHQO19fZTIyfAFK6hcdgVaaEEPPRC2yA
	QgF8F7v2GogyVDbN5YgwcB/r4LZwU+JetKhQ+ok3PUc7gXPXYnO/ZcefjRxkqW2y2c2DK6MzAY6f+
	cpBCX2GNI01HcVLnJ0D60WoDeZNjDBgvXaJCUHrl1qOacvzIhgGojLhfa3ZBIIX3xjz0WZtCXX1md
	DBHzZOJw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipk-000000004EY-0Ht1;
	Thu, 12 Sep 2024 14:22:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 14/16] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Thu, 12 Sep 2024 14:21:46 +0200
Message-ID: <20240912122148.12159-15-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
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
 net/netfilter/nf_tables_api.c    | 31 +++++++++++++++----------------
 net/netfilter/nft_chain_filter.c |  2 +-
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 88528775732a..3632be26d73a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2225,24 +2225,22 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, hook->ifname);
-	if (!dev) {
-		err = -ENOENT;
-		goto err_hook_dev;
-	}
+	for_each_netdev(net, dev) {
+		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
+			continue;
 
-	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
-	if (!ops) {
-		err = -ENOMEM;
-		goto err_hook_dev;
+		ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
+		if (!ops) {
+			err = -ENOMEM;
+			goto err_ops_alloc;
+		}
+		ops->dev = dev;
+		list_add_tail(&ops->list, &hook->ops_list);
 	}
-	ops->dev = dev;
-	list_add_tail(&ops->list, &hook->ops_list);
-
 	return hook;
 
-err_hook_dev:
-	kfree(hook);
+err_ops_alloc:
+	nft_netdev_hook_free(hook);
 err_hook_alloc:
 	return ERR_PTR(err);
 }
@@ -2253,7 +2251,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strcmp(hook->ifname, this->ifname))
+		if (!strncmp(hook->ifname, this->ifname,
+			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
 	}
 
@@ -9327,7 +9326,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			kfree(ops);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			if (strncmp(hook->ifname, dev->name, hook->ifnamelen))
 				continue;
 			ops = kzalloc(sizeof(struct nf_hook_ops),
 				      GFP_KERNEL_ACCOUNT);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 4f13591e5cd1..d691f8354049 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -338,7 +338,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			kfree(ops);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			if (strncmp(hook->ifname, dev->name, hook->ifnamelen))
 				continue;
 			ops = kzalloc(sizeof(struct nf_hook_ops),
 				      GFP_KERNEL_ACCOUNT);
-- 
2.43.0

