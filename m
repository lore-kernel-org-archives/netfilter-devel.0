Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9A183CBF
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863842; cv=none; b=p3LMtcDi8W/9u8QcI9sQn3isJHKciogsjhm+o3rkg0gmmNxmloBAfomIh4PEa46RjHT9A2Ii2HD6s4yBd8+BgQYbJti4+NdwtnXPjH1SW4fUMbcVtovvBQQ/J5Of1AqMQTRj+/XH0Vgdf4C/Xpfe/u8fw0Xbt6vRMuxUeT42CP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863842; c=relaxed/simple;
	bh=hF2LbM6coqidUOBah4qWUziCX/jYYmBwKKQImEO6JFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2eYUBorbX0Mt1T7b8X/n2TNaxsupdDvaTT0qU93Z9sGphMwLphaSn6260uzNPgJtZYKwvTlEEeg7Xf8VigG9AaEJGOQxu4/laI+Q5LwQEOBKdWlxqxXF/3h3NK179IKEMe8/AFRfYsjvi9ULA35k9CWr1066lRx0tw2KctEI+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hVqFHoDw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hVqFHoDw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yb8Oh0PjZostfgsQrogLDWBJHXlLKknJiLjPp80GWs4=; b=hVqFHoDwZSU0UtiKh3IpbWb3n2
	qfi2ErmixsGGNadBSf9vFOGonLgDgxdvkNHnC3wREA5Vhume4pSDTOOZ/DmM0QmwK4mzfEoUQrf1n
	9/SJs1cO0ljvX2kkUpCvaK/o/ub6uaH29Ism4Q0QRyM+uo4kdIRJXtw1eig6TWV/eawb+UXqSpdcM
	Npo+k0LcF1F+0DBg1lr3K4+7WhqfTtTV/hO3ZpmpjG5qYUjvL6T+NUw43k8rtg+5XWXpLfFjqB6U0
	M79Q5p2VEWTjFMj0qQJ8QlE1wJoHZt+hqxcz6qxtlhUc0Ml3nWqWeL7k9n0OeJ1L+lF4EK7kvELZt
	Mvs1zKaQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAU-000000006Id-2HYU;
	Fri, 20 Sep 2024 22:23:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 14/16] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Fri, 20 Sep 2024 22:23:45 +0200
Message-ID: <20240920202347.28616-15-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240920202347.28616-1-phil@nwl.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
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
 net/netfilter/nf_tables_api.c    | 33 ++++++++++++++++----------------
 net/netfilter/nft_chain_filter.c |  2 +-
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4d40c1905735..ba2038ea56d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2222,7 +2222,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 
 	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	if (err < 0)
-		goto err_hook_dev;
+		goto err_ops_alloc;
 
 	hook->ifnamelen = nla_len(attr);
 
@@ -2230,24 +2230,22 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
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
@@ -2258,7 +2256,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strcmp(hook->ifname, this->ifname))
+		if (!strncmp(hook->ifname, this->ifname,
+			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
 	}
 
@@ -9337,7 +9336,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			if (strncmp(hook->ifname, dev->name, hook->ifnamelen))
 				continue;
 			ops = kzalloc(sizeof(struct nf_hook_ops),
 				      GFP_KERNEL_ACCOUNT);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 0f5706addfcb..f7290dc20a53 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -338,7 +338,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			if (strncmp(hook->ifname, dev->name, hook->ifnamelen))
 				continue;
 
 			ops = kmemdup(&basechain->ops,
-- 
2.43.0

