Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B342F481C7
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951185; cv=none; b=Vg3rAIK9+H2eSnnBBA3xsxvDUsCx+ygD+EHqsiYYrq260PXYoGRGUkDKvewQ8i2HWd85QmVLN6f6S9oYqpuwFNvJ3bZEqat4TP2H1jl81+AgMaXCmtO9rp5de2VyZgbDzyC6QV/Pviz50VzowSUvJdOM+sfuYeJ1pHBTjCmrvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951185; c=relaxed/simple;
	bh=6GFCKN9lXUEIgKCHJnnYf5A+eb/HJF4wFev+qactQr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suOZr5R3rQPitStCEObCbXOOYi2itV9BykXTQKYF2ejgVvaQef2ylWyc+aYDXOqW6uELD01xwjv/XkIyUj8vHpaMevJV4qeK58NuLyigkkwT5OXTTBnkqhrn2MOOZJoRvQNxuxL7rOZRRv0Ansv4CmkpbIm3dYRKpTXqJxjOUJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qfE6SFWi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qfE6SFWi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7pciD9Q7CVzApqJjvV7RzRhMQkqxQjFhYoTFcjoZQQc=; b=qfE6SFWi1jMahfG9K8+NCtug6z
	aZRpLocAIn4y+JvC2vYaEafxySaXIT94C7O/BYScpgT1Db3zjx6atXUwXwg4LIbGDtNfA/O6kqB5R
	dApTn9PCUBuBf/Z2LuzBMWGJmDRaO9bcdJ/yBg5AyecL2j2OKbmbqU2Y9eRzW6SlTWqKIiPD0NA5s
	+yCJA9E43h1A9aCvDgXcP4H3m1W/h6MyKrsXtvZj0tMWWti0HkleBjCqPO7D87cRxmxPB9QJeTWlR
	sTN4UEa6ZvlurraPq98F1ZMJZaWXsbDU0YLE9xSzxnLOtE/ROrCvVtonWwETUqttvMVfAHZhjshk2
	c6PPmJmA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHr-000000001cp-2n3J;
	Fri, 17 May 2024 15:06:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 1/7] netfilter: nf_tables: Store user-defined hook ifname
Date: Fri, 17 May 2024 15:06:09 +0200
Message-ID: <20240517130615.19979-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517130615.19979-1-phil@nwl.cc>
References: <20240517130615.19979-1-phil@nwl.cc>
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

