Received: from mail.netfilter.org (unknown [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D306A1547D8;
	Thu, 16 Jan 2025 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047963; cv=none; b=cmIlPtmXcotyFR4dJU9S15HLv+VKD48EbhxCkyZzFdr9BWhojRcdqAcVenghKwSp77PbBnDpo3ZGIUwG6C8lHFHHvkb0+Y7eHRpV7CwepG4LWtMnBQpcoX3yuYekPpujshTE9pfbFj1bwnLsXmzFWgKsNfKu+WJbAe+Evyfmd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047963; c=relaxed/simple;
	bh=qeu8DXk77WA52Oinxzb134Fm5lfLpbVOpYGurIMNy6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fed+ONhb7JjlqpYXIP6TT9mRjfCUcv2JrZOZT6kcn0VYINgOvY2qQBCK8L2i1cVcDyAU7csfImf7So6KfnvD1/ubRtsRFJSMqZIqMjl6KC87FxjiggzOaTl6oW1K1D0ZLyX/qeJPhGDocichv8UBG6w2e7LBMm1/AOwd2U/S32k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 04/14] netfilter: nf_tables: Store user-defined hook ifname
Date: Thu, 16 Jan 2025 18:18:52 +0100
Message-Id: <20250116171902.1783620-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250116171902.1783620-1-pablo@netfilter.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
and store the interface name and length as specified by the user upon
creation. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7dcea247f853..d1f274af5b70 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1198,6 +1198,8 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	char			ifname[IFNAMSIZ];
+	u8			ifnamelen;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e41c77e5eefd..95d8d33589b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2276,7 +2276,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
 	struct net_device *dev;
-	char ifname[IFNAMSIZ];
 	struct nft_hook *hook;
 	int err;
 
@@ -2286,12 +2285,17 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
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
2.30.2

