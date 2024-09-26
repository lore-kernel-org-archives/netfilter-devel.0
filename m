Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E41ACDF9
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344617; cv=none; b=hw7qW0h/Bxxue7BOMeZnADUC1w0WTLOo7gWgxKe5FJqKB9XwnTqs2T8ntWEWOwMqafsVgwAMOMobU5D0BgGOwX3n3WCIqSuvz2hE2iOLzu4zA2j2zUg2adRWIjfkZ5zHga3aIj2OYqnxpAYfZh6I+8vpt4Qc3HwkSKfGV5GoooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344617; c=relaxed/simple;
	bh=ys2vapbFgIGlsxEfXIg0H/QsfXyifeGUAo6DyE1nbGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz0N0G3/0Pcqq9XxIe6I0QlurT/XkbPQDKUqsGHYX887XVrmIBleSrLrC6Ky3FquZj8Lo4RPJHAZRe8bmAKvAYZEFcxHjAtSdJeS4CFmtBuqxffRU8lccWx19Cr7hubn4BuzpU5jV+Sq+WHamefsRoadHqBadJN1yXuVGEBIy9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kpittXCi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kpittXCi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H4Y2m+kyABUIs1jXlALRh+x5vK+RiJ8pssoPE3/5cBY=; b=kpittXCiYPhPYfM7fLCqAGVVGs
	Lh+g0OYN52EuaUZ7sBxHKgIj+8EykvMkydoEknOhDm9+q3r1vwzFpHOsG9b7Gk3pv3A+e50qXdya+
	bKT9WSzvolN/fE3IjqB4kxXzkh8RQ7C4zvtxub0lMsWIJq7Z2ZrX0bVCwZkeUsntL01dksVcwe1NF
	vaYjattugDt+MtKfCv+ZgN7Q8daW3Mo6X9DU6lgs+/SZsv8B/ySCvCTyVBrvjVlqp52QmpNgg2l0K
	080FJgy9WbDHemGP9iEzGELskohAO3U1EPmPB7gkog227zEw5un8j0Fmt/Rn5MI4pGoE9tOtk9z7r
	SnhhuZvw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF0-000000006GL-37qC;
	Thu, 26 Sep 2024 11:56:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 02/18] netfilter: nf_tables: Store user-defined hook ifname
Date: Thu, 26 Sep 2024 11:56:27 +0200
Message-ID: <20240926095643.8801-3-phil@nwl.cc>
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

Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
and store the interface name and length as specified by the user upon
creation. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 49708e7e1339..73714e9d9392 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1192,6 +1192,8 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	char			ifname[IFNAMSIZ];
+	u8			ifnamelen;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b85f15ed77ed..2ec3e407f91f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2173,7 +2173,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
 	struct net_device *dev;
-	char ifname[IFNAMSIZ];
 	struct nft_hook *hook;
 	int err;
 
@@ -2183,12 +2182,17 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_alloc;
 	}
 
-	nla_strscpy(ifname, attr, IFNAMSIZ);
+	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
+	if (err < 0)
+		goto err_hook_dev;
+
+	hook->ifnamelen = nla_len(attr);
+
 	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, ifname);
+	dev = __dev_get_by_name(net, hook->ifname);
 	if (!dev) {
 		err = -ENOENT;
 		goto err_hook_dev;
-- 
2.43.0

