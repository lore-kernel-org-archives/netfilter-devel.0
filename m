Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEA71A304C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145129; cv=none; b=Moh3C7BJlSlL+0sxZZb90QIe01/Qslzv2sILfgMD6eEX60VsK2zkrct/+aRzxX+H8+qJdT2hNBo/YhVEUlh1O+aYKFJITPOt5x9gKXjhn2e8t0kWKeTAsLx5jPFCQVFjLf7aSJjgThSYDqHsuIeFEGXxwKziTKm1Cj36WnZDE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145129; c=relaxed/simple;
	bh=t3Ee95MHjeyrmSNyugjlFjW6wOPiNxlmHdhPjO+uFpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3BjEgmfLo36JClCt5PCy2TF2fT53Q+g4MC0u8nRbrz9rGBF27xSXUX7SRtpIUsPyMXrVhMz/1cdSUxejNpq4G3Rwe0c4DvzzOPwmmKnEVTCYs2u6+ZPqAdWHxcegM8sbOo0lNyBlFFH2KQ4NBcXnD6sYxne0rVayjdQT0Cq07M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=D/EfKiXE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="D/EfKiXE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TanlLLDTixftNoWFm/mW+HQx8h1sVyqCIn8xWo5u/lw=; b=D/EfKiXEGPYriRVooNId86/6ih
	R53qZnXkgTs0tvOz27ydKhqO3sOVfUH8+tV0PnZe0EUcwAkmOqCYnI+fEaVdJoaIlFu8prR9v0Ifq
	wJYp0JKUnSG9MOkeTOB8AIKoy4vWAJ6zNENmRqseMi/s0/U1WrLAws67x9xyLhIKpH3TCieUxiQ4I
	ak2oXpG14DjQJxpLmirXD5617f8sRswGJtCQqzihR9Zo9ISBilprlbfSx509PNGv8Pq7hKqFgH1Um
	euUlBGzk74vultQu47QmpcQOlYVMeyPsB3ufiFmg+3+QJZ8nDCZy8vjBoiY5cQwFrTYc9n2EBhS9e
	lHFHyjhg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipf-000000004Da-05GH;
	Thu, 12 Sep 2024 14:21:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 12/16] netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
Date: Thu, 12 Sep 2024 14:21:44 +0200
Message-ID: <20240912122148.12159-13-phil@nwl.cc>
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

Hook into new devices if their name matches the hook spec.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 47 +++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64f8305189f1..40cff8539c74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9314,15 +9314,41 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		ops = nft_hook_find_ops(hook, dev);
-		if (!ops)
-			continue;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			ops = nft_hook_find_ops(hook, dev);
+			if (!ops)
+				continue;
 
-		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
-		list_del(&ops->list);
-		kfree(ops);
-		break;
+			/* flow_offload_netdev_event() cleans up entries for us. */
+			nft_unregister_flowtable_ops(dev_net(dev),
+						     flowtable, ops);
+			list_del(&ops->list);
+			kfree(ops);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
+			ops = kzalloc(sizeof(struct nf_hook_ops),
+				      GFP_KERNEL_ACCOUNT);
+			if (ops) {
+				ops->pf		= NFPROTO_NETDEV;
+				ops->hooknum	= flowtable->hooknum;
+				ops->priority	= flowtable->data.priority;
+				ops->priv	= &flowtable->data;
+				ops->hook	= flowtable->data.type->hook;
+				ops->dev	= dev;
+			}
+			if (ops && !nft_register_flowtable_ops(dev_net(dev),
+							       flowtable, ops)) {
+				list_add_tail(&ops->list, &hook->ops_list);
+				break;
+			}
+			printk(KERN_ERR "flowtable %s: Can't hook into device %s\n",
+			       flowtable->name, dev->name);
+			kfree(ops);
+			continue;
+		}
 	}
 }
 
@@ -9335,8 +9361,9 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
-	if (event != NETDEV_UNREGISTER)
-		return 0;
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
 
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
-- 
2.43.0

