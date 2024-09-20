Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F81518454F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863842; cv=none; b=ACRelBfGoTkt4fPgpZ91BRnTYiRlnDEcjkWBBeayyL9+uvkeXGbQDGa4VHWhwqtVCM1YMRHxswjdNnmcs+K/M9eoDP5Tv4xiZJjLxTpbf1OLVS1UGTAobPUkzuFvEW2HvB/U3h7RI9P9ad5h09IVurdhD93NboW06LQlna5WMC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863842; c=relaxed/simple;
	bh=jP3eNvAGzzO+PxiQSh3XivjP2v133G69VlKRR2lDEgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5JfG8Nc+AMA2AEbB3oLSul7qHe41dSdmklxGZgBJbmHN/eUY3947tle5vBz5M24e54XiY3wbeyhiAjmas4TjZCQJ98nYWDvmRY59sF6dhsFcXtq/hK09uSvjeBTUb2oV7UL1uHm3y7vG4HGkOjBY9KCrLIySMTcLIVEY4w9iiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UAQAk5lK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UAQAk5lK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CC5dM4Zc5EXnBOn4yT8DsZoEqtnWAvRvw43sL3jgmyY=; b=UAQAk5lKMHrMaYzX8BgGKdwScM
	GJH+WOrCET3TwNW8H7wx1oIwYX+d9zPBjCoYJ+Wn5eSP2zqJH7zW9zylb8H1omaKYKYdSFkeYrG75
	nVhAn4tl/LUqHQjQMHKQQTJDhaodIpRuuX9QSQranE0z6AFxtrP+sRu8p3UTcVcMl6+Cby6UOBMEB
	1vudgpMP1SUMCEUf1iGlsLu/eYpF7z0si91L0IYVwySaNGBxhzO8vaasw0eBw/WLXM3r/I6bqFK00
	349OWf8zVHvakXtPVFhRItJFIExhq2PrW15aUnt7XI7YqYWfN+uCAVPvwYWe0knt0KF9tzw35ysty
	8hB3Plzg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAT-000000006IW-42Fr;
	Fri, 20 Sep 2024 22:23:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 02/16] netfilter: nf_tables: Store user-defined hook ifname
Date: Fri, 20 Sep 2024 22:23:33 +0200
Message-ID: <20240920202347.28616-3-phil@nwl.cc>
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

Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
and store the interface name and length as specified by the user upon
creation. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Assert max attribute length to avoid bogus values in hook->ifnamelen
  as per Florian's suggestion.
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

