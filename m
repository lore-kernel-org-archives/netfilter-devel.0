Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E43158D98
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714765849; cv=none; b=n9LzBD4MNFWbOfcUyItYwwVlRokFWtc8Zp3oEmQkRL7tUlN3LxrdHnX4u7KQjaiiapltzfTHQMQ/4KbEAZk9D31EkmJHX/5O2WK039QQ5uQTt/L/ehIwbJ/w29j3COIsT2ES1R8GBylP47OlFnIf2sWB0TYfnwg6i6pStqMT/tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714765849; c=relaxed/simple;
	bh=6GFCKN9lXUEIgKCHJnnYf5A+eb/HJF4wFev+qactQr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrkwCCe7JB/xhEXaHU/pe1d6pU9Depd0ePOd/R9zaGmhNKwkHyQJIfV+90hPZ+Y7OQuSlfeB7p0HoxI/6kif37Wg2UjboNqH0cnTExb+S2a4NhWC/8duYSIjJ4e+b/e5KxSFex94lngol6kwHOAZiFm54RGe1AZvSUKHmj4ocNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CO9P9BYx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CO9P9BYx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7pciD9Q7CVzApqJjvV7RzRhMQkqxQjFhYoTFcjoZQQc=; b=CO9P9BYxLKeKUXtQ63okLz6M02
	6KYVgMojIVgdORi0Bgo+CpVRKkGpeMMyge/X0Zit1nQW0XQxUQGvVleVLMrDt/VDdDgZTfGZHsqv/
	t+c3fxc7BBeKC3xbPfuxS1YuPirp2MDcy5z8IfdjtmutMGo/HMMlEdNLBj8QJDexQn++u2vpTaxqJ
	NMutG/GXgzzhdqfDQ5V8ld5VDhzeAFLv4wuc6SH26P6hzpEiQrG5tbhSdGEC3rffoeQ7+c+pr5oTJ
	Nx0CSq5OJS+qLIqApsjz6bWWkZuXtTZ0mJHLOcBqpAZpb4UFuRcmAagVdlFn3liXau3EJ8oAulvjn
	xflvd0oA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2yvd-000000007E1-24Ry;
	Fri, 03 May 2024 21:50:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nf-next PATCH 1/5] netfilter: nf_tables: Store user-defined hook ifname
Date: Fri,  3 May 2024 21:50:41 +0200
Message-ID: <20240503195045.6934-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240503195045.6934-1-phil@nwl.cc>
References: <20240503195045.6934-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to support dynamic interface binding, the name must be stored
separately. Also store the attribute length, it may serve to implement
simple wildcards (eth* for instance).

Also use the stored name when filling hook's NFTA_DEVICE_NAME attribute.
This avoids at least inadvertent changes in stored rulesets if an
interface is renamed at run-time.

Compare hooks by this stored interface name instead of the 'ops.dev'
pointer. Also prerequisite work for dynamic interface binding.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 19 +++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3f1ed467f951..3dec239bdb22 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1183,6 +1183,8 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	char			ifname[IFNAMSIZ];
+	u8			ifnamelen;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 84fa25305b4f..4f64dbac5abc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1799,15 +1799,16 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 			if (!first)
 				first = hook;
 
-			if (nla_put_string(skb, NFTA_DEVICE_NAME,
-					   hook->ops.dev->name))
+			if (nla_put(skb, NFTA_DEVICE_NAME,
+				    hook->ifnamelen, hook->ifname))
 				goto nla_put_failure;
 			n++;
 		}
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
-		    nla_put_string(skb, NFTA_HOOK_DEV, first->ops.dev->name))
+		    nla_put(skb, NFTA_HOOK_DEV,
+			    first->ifnamelen, first->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -2118,7 +2119,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
 	struct net_device *dev;
-	char ifname[IFNAMSIZ];
 	struct nft_hook *hook;
 	int err;
 
@@ -2128,12 +2128,13 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_alloc;
 	}
 
-	nla_strscpy(ifname, attr, IFNAMSIZ);
+	nla_strscpy(hook->ifname, attr, IFNAMSIZ);
+	hook->ifnamelen = nla_len(attr);
 	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, ifname);
+	dev = __dev_get_by_name(net, hook->ifname);
 	if (!dev) {
 		err = -ENOENT;
 		goto err_hook_dev;
@@ -2154,7 +2155,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (this->ops.dev == hook->ops.dev)
+		if (hook->ifnamelen == this->ifnamelen &&
+		    !strncmp(hook->ifname, this->ifname, hook->ifnamelen))
 			return hook;
 	}
 
@@ -8908,7 +8910,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		hook_list = &flowtable->hook_list;
 
 	list_for_each_entry_rcu(hook, hook_list, list) {
-		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
+		if (nla_put(skb, NFTA_DEVICE_NAME,
+			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.43.0

