Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8221AC44E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344613; cv=none; b=J9KKbXs8G5Ye0gjkB0MRNf28g6iYyzJXVcw8Z9jxbPhcwTPvk1UqxVOBcCo+0FJ1C5QZiq6iZJZVA88NRe9omNZyPhe3EN8sVBFKIL5sWDrc4sn7X+ZmsqOcxfXUYeROQXTKuZH+FLzrf8vdtSE3CTiJsHwDt57sKNZz28DifIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344613; c=relaxed/simple;
	bh=Mj3ULNJTBhjPqq1CZTIaexRT5N3czg39T18K4bQNDaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dvjxf2WVcMQ1Rf/4dNPCfaMJMRRKQf3g4lkgIYDkUnHcwKVcok+q6wxx6T//XXdig7UlnPQk/muviY/Gan/MxpYciJmeJJef942wS9MjYpeiQofiXnMptPCbsV6uCHZ/eeeBC4E85ef0CN40pJ+0YdP1KQH5Z5nhSGQIhcMmUSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Lnzte2TZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Lnzte2TZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6rGI0WC3iRclcNdSk/jWWybMNLgGOetAn8fZWpU+IBo=; b=Lnzte2TZYPUwNa2KSvQ4Pcn3+H
	lQjI2zyNj334bAYX+RUrh9duNxiB2hXcuQYm5wuV0Aatk+8iaGkbHRhqJB4wCstu27uBLhlxWgAH/
	+T0fqGLq1QLlXY3tOXynfICwZs1rv24zNPnwftnKbpVRqHZMICT2EEYEQNvgwE92TV+XfnMJ4Tlis
	10MjKw+frGmdyn8Ovxo2T1Gla5vL45FhAyY3644y8jbiyMxruJ1bvH2UM/JOILKRO/t+3/4bE0rnD
	yJPa9kPTLlQWgg8GnmPElvSVjvOJmiDTKtX4IJwcb9o8ouaKZzMZHjDaS/a16DQnPWEp5DlIGKCLx
	wwtvdjJQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEw-000000006FY-0NHc;
	Thu, 26 Sep 2024 11:56:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 10/18] netfilter: nf_tables: Drop __nft_unregister_flowtable_net_hooks()
Date: Thu, 26 Sep 2024 11:56:35 +0200
Message-ID: <20240926095643.8801-11-phil@nwl.cc>
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

The function is a 1:1 copy of nft_netdev_unregister_hooks(), use the
latter in its place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3721f4636e0a..7a721df27f12 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8560,25 +8560,10 @@ static void nft_unregister_flowtable_hook(struct net *net,
 				    FLOW_BLOCK_UNBIND);
 }
 
-static void __nft_unregister_flowtable_net_hooks(struct net *net,
-						 struct list_head *hook_list,
-					         bool release_netdev)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
-		}
-	}
-}
-
 static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct list_head *hook_list)
 {
-	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
+	nft_netdev_unregister_hooks(net, hook_list, false);
 }
 
 static int nft_register_flowtable_ops(struct net *net,
@@ -11473,8 +11458,7 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	list_for_each_entry(chain, &table->chains, list)
 		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
-						     true);
+		nft_netdev_unregister_hooks(net, &flowtable->hook_list, true);
 }
 
 static void __nft_release_hooks(struct net *net)
-- 
2.43.0

