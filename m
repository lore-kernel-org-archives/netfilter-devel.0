Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C316DEA9
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443907; cv=none; b=VLE8Blicz8KY67UnxCLiNGgqbtVOh3RRcbEGAcFPHhXYWh1DCKu7RwvYLiXPZpxxwL0BB38eZGPmVPpR+XCjxXBXz/2ZIoyxmd6DYVN0JJ27P+C4C1ShOZI2tmGF0h3JXnAcfoZ/Xy7XBVXY0mJE6iGsxZgr7oeyrvrOs7sUSRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443907; c=relaxed/simple;
	bh=Yz3sOLNRF40wXAVZDALP6Vz39Lu3ddh3mEMyNtjdLtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPDFgyjVZpsg3ADyNCAtyN7eAGDttKsvqrIAf2BsuH6/MzsREXuaopExIszv1eLyHyhAm1kV0nk6oObsD3AhTcAS1n5S/Qx+1O8vEDXy8ky140Doi1NkoAqW3nWMWC+CL7Az6CXc8n1f2VI9zsqs/TOyIL8t9B9UWOUpbPAKNjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kBZJBBse; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kBZJBBse"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pO/WOnDpDC94yK7kKz5Oq5KMFQuNhBcaFTEjeeNyhvw=; b=kBZJBBse3UT537Wzb3mc/c6zAc
	sGxAMsb+3DWJDhVi7mvmeyZARrcRnEvE8GFpCngENN6m2ZqlSmpIXeFQJdl034Sk8N3u6RaUprcVn
	tbgWG9KR5AP4mYm7jVFE8EetD83LigA7SI0gAaKf7jeGCAZE2aAIqDtEiWftyu/BWEL/wdBhC8++7
	M+r49gUFo6V4/EgBlt4en0HNHoFZgL51L34iQDrGO7uRbJNvrZ9wAqcUNR1zG0CbqtnYWvPT+PAkw
	ELBZ0y1dxTintIIOD6WV9b13gAWWYoZucQYo3YnfTbhEw9SHtBhYGR+wdkQpnUFS9QDtG6ymMjfUy
	Rea7ZSTg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNh-000000006MN-13AR;
	Thu, 09 Jan 2025 18:31:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 2/6] netfilter: nf_tables: Store user-defined hook ifname
Date: Thu,  9 Jan 2025 18:31:33 +0100
Message-ID: <20250109173137.17954-3-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109173137.17954-1-phil@nwl.cc>
References: <20250109173137.17954-1-phil@nwl.cc>
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
index 4afa64c81304..d8fb1d0d6c8a 100644
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
index 1357238bb64d..fdb14b357f71 100644
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
2.47.1

