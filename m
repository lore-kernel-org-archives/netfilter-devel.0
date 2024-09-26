Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141751ABECE
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344612; cv=none; b=bAc0Vmy+EHLeBBUM32KhPR2N4EX4VIHfu4Q6jBYRoLh6jQU/lEN0+6lYUlH65vpPz5lbtJaiH3SsTlS0HVqB8XTgMsG7xfvylUGZnur/o8EjZ1+lP/5fvkcQQVGO7VQuFXLHXYDi4yOVlQB/6pba+sDH+ltkO2m78PnkyqnCoNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344612; c=relaxed/simple;
	bh=U55sg35wpPH1/eTHpdus/9QAyQ+dlrD5mcvZ48QPcZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUvR5O9uOJKtNE/8kCoLeKSDUBFa3rkNXq93dSZFTjx35S7G0lAWzQCsRJH2E/5AYALdVAa702yF+m25jOWasRFAwwa+KoalYfHzm2xUOnwitmDlHCBGC571XDNJzpSfeo49esN/Zm5HflGYqp8zE640CwuK1vgqkir1lYfCByE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OAgf6z0P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OAgf6z0P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=reR/CMXeWGz/Eg0KMP9I++rBkJRu6rBjAjeuBg/XcVs=; b=OAgf6z0Pk6JYvYtMiOiefmWjPJ
	GIRTw90YHb5Nti5EntziUvX3hiYfxhU7k+BmyOO/4FlYO9h4PN7X0hVA4L5ly25zqBqQAes+jLOFd
	6T9Hbba8/c0mcZZI7Pexq4D89kRyLVMtb2cH+GPJIRB5HDrJdHDCJwy26/dXc4hVBzcQ62bNiLFfB
	z4I1WqSwdMEGIDL/EM/49iq2nbGcO2KAx2v3uX9K5+1+m1pHl3qMjcdCj3Ti0So+/eteAom2h+DaL
	6uk1Bgd1yJSoOnGEmiVipbOuTlkeBqZibKXO10zL6s3Izi14M9/4Y5tJO1ceYVD8h12psRuw+mcnH
	zj7j8EPw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEv-000000006FR-2AIh;
	Thu, 26 Sep 2024 11:56:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 16/18] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Thu, 26 Sep 2024 11:56:41 +0200
Message-ID: <20240926095643.8801-17-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
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
index 50221d4d747b..d5ce3ddeee26 100644
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
 
@@ -9326,7 +9325,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ea07460d2bef..6a69f73126eb 100644
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
2.43.0

