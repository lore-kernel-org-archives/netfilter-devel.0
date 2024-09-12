Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FD21AB6FD
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145118; cv=none; b=V1JSg8+84OOhdFCNc8ytpDqQBJBujeAXentb7T9/GUa2wQMnQbyHwhnlWvSOCfRrOP9KyDU10StLgawzGjQCv+3bF699ujZNZF34Cnw6wdgQLesFoxrZM1ROxIzNYMyeizf34yjEvUgBzX7KjoTPJSD7UjCHjqbRz7I7DRbefy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145118; c=relaxed/simple;
	bh=EXdRuAQD8XMHHhIzTdfrmm95BzpeXNkChjwulxaBbzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBMRhw1bZs+OgqpuwuCvxfWv22kMUzy5pF33dZtU6CUO9/Sr5hOVu1Nwk26y1CsmzTnqKu2BQSTw3VtINQSc4I+G5KKIViO0qpnnHBF5G1rNApTvk/MMru5o7S2+OkZVE0Px238YXWEi7EAYRln6avFQrEyWb+Y2djSgUpiByFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Uj+4EMQC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Uj+4EMQC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UVFrkp3KWVL8St0NWZsXNEO+uheU9fzhkSYFDo3L7Q8=; b=Uj+4EMQC3gFIc307KfEptJKjcB
	O0heG+bh0ZNgTh8c5XxnFbHxnIEk6kpILy6PcD4PgBkWVuGzMRZ51TU2EdPKiuFUNZ9YM4aSDE56O
	oVV0VqEErf9zEBG5+kKvNKZOSAUiHNjHD0nP+I6W7olOeJ0EQxFNPuq5QZoXkFt4aPn1HBu+T9poM
	vLdOozIRpedSEr18QFR7GA3dE/dx+jg6hnBt2AEGpspVvW1shdSQIa/fShup51piulQdpjhlxIslA
	/Ru24GeUoiw0E6tMThAwt4Ap4dX2WixRGBQdyGdRK5T1fJKTBkZ4p/gRlxYC2pphTIcx8swfXrI6B
	VsOVT2UA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipg-000000004Dp-0hUU;
	Thu, 12 Sep 2024 14:21:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 03/16] netfilter: nf_tables: Store user-defined hook ifname
Date: Thu, 12 Sep 2024 14:21:35 +0200
Message-ID: <20240912122148.12159-4-phil@nwl.cc>
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

Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
and store the interface name and length as specified by the user upon
creation. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c302b396e1a7..efd6b55b4914 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1191,6 +1191,8 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	char			ifname[IFNAMSIZ];
+	u8			ifnamelen;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3ffb728309af..f1710aab5188 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2173,7 +2173,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
 	struct net_device *dev;
-	char ifname[IFNAMSIZ];
 	struct nft_hook *hook;
 	int err;
 
@@ -2183,12 +2182,13 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
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
-- 
2.43.0

