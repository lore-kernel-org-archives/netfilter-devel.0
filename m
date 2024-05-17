Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804CB4EB3A
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951186; cv=none; b=TUpbw7JE01ucw8oMaUSzKkSebj9pLRvXdQjM1X8x4XaqHhcRjZJ+a4PGBy8XVCkneXNCXBZjiIxaaxhOnyncPtYHbsKrsUUPmte38ESowAxc+G1A2DJbYVfjS4MwTCg4NAUcCha6znN68+WSxSxzKKxU+ufI+P1y7iihrhhfMiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951186; c=relaxed/simple;
	bh=AshQwpn0QkKuctzDZ3q2z1HQtEe1xnCJhT0nIrZnVrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5XmNzQiToIn0avak/a9BW4nZp2avH6t7MalNKgS1HHGhTr6Fp64O91nGP7zvQmILYuGDVoBirS45G5z8g38xjDD+nekrds3JWiY+2pQSX2UtSodzO0mPoEo9irI//DkX+BANihPPFnlQgvnhXrWxXWD9v9Iy3KsW5/7zAIF8EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dEDgo3UI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dEDgo3UI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=029QCVXDyZbw+OsepMifHkYoYWMkmQ10OYs5fc1lD1Y=; b=dEDgo3UIeNyH9TGErWH94o6UVC
	9was+nDGw7Ha0BAT4DlHp6m1P/xK7ITzy7lsvNHHFZjBBlydCHpEr1aTaPuxe46vAdE0kt00tgEbF
	Wz3NnqP4dSViCdKbKKzoxmzf6d3RwFrRiKSb6sKtGAcUjsuZBvk6fh0srQoJTb5HhgItAXVn7kJft
	ar/A7N+d7BgICIxBWAE5A/z+WuKglL635v7/CnKV8l6wOfHn0ET1jnKXy9Fluf4b2NXw+73LlG6CS
	oT9bQ3qXUj7knoiNr8cd2seLEqogmQj+2RdnZHKPnchTDcrgiAeLjzAKU8bJDSdqhO6EPn7OffVEa
	e/vMgwpw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHu-000000001dW-25i0;
	Fri, 17 May 2024 15:06:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 5/7] netfilter: nf_tables: Correctly handle NETDEV_RENAME events
Date: Fri, 17 May 2024 15:06:13 +0200
Message-ID: <20240517130615.19979-6-phil@nwl.cc>
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

Treat a netdev rename like removal and recreation with a different name.
In theory, one could leave hooks in place which still cover the new
name, but this is both unlikely and needlessly complicates the
code.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 10 +++++++---
 net/netfilter/nft_chain_filter.c |  9 ++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b19f40874c48..b3a5a2878459 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9247,9 +9247,13 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_REGISTER)
-		return 0;
+	if (event == NETDEV_CHANGENAME) {
+		nf_tables_flowtable_event(this, NETDEV_UNREGISTER, ptr);
+		event = NETDEV_REGISTER;
+	} else if (event != NETDEV_UNREGISTER &&
+		   event != NETDEV_REGISTER) {
+		return NOTIFY_DONE;
+	}
 
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b2147f8be60c..cc0cf47503f4 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -379,10 +379,13 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_REGISTER &&
-	    event != NETDEV_CHANGENAME)
+	if (event == NETDEV_CHANGENAME) {
+		nf_tables_netdev_event(this, NETDEV_UNREGISTER, ptr);
+		event = NETDEV_REGISTER;
+	} else if (event != NETDEV_UNREGISTER &&
+		   event != NETDEV_REGISTER) {
 		return NOTIFY_DONE;
+	}
 
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
-- 
2.43.0

