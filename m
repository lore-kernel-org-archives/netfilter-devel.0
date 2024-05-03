Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39A8158D88
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714765849; cv=none; b=cLjco0XqD4WDqtJrwuBnCKffVtidZX+YUkf/dV7g4vvtrzO3G1mywbZf400OGOPF0xssJSluPEbzsJtnG6gNst6uERt9SGWNWIJNe5PUjaSYn31KliLNSkeb9/S8/GJ8cuInpJ0xxli6uz7cE53/7UOzhw3P9pe+Sp92JmQhUFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714765849; c=relaxed/simple;
	bh=AshQwpn0QkKuctzDZ3q2z1HQtEe1xnCJhT0nIrZnVrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btCnniNvq2pJN+ElhXyW6WAlUDjtwoc9kJCoiYoJFmU/SEYV92VIW15yJzxQVv5Je80fOlqb9YhLOX5HLMnefuyQuXpE4yeRTnMYXbzxcP+9/ZX5xe5pA1sOET3Y+ESduNzpW32uXutbmUDcfz56pCqtmW0q50mFIzXYlsRq/IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fH8IGv3t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fH8IGv3t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=029QCVXDyZbw+OsepMifHkYoYWMkmQ10OYs5fc1lD1Y=; b=fH8IGv3tCk8E594ON9feUE4ji/
	TE4atiInUopDUZ8zDu+ztQVAHd8PZlU0/SgDa4LGLoLQ5liekcX8DvVn9XeZs4EjgIl8vIXYXkQG5
	6KcbKY2uVRsxk2UJV7nLWICvF2e9c5XWdwvBM1JeoZ911zuc/lNxTF+4oDuzjewR0whlWiHINrMF8
	yygUsDiEgncEdmJ1NVVRJj0p3qcNjmw2XzYD5Vtz81H07+eXAF/yEeXiScEx0paTynofvaoqsUjR4
	QCvw26WSu89acCFlNb2iE8tUdVw05gvVWpKgLUriH/hlyr8AbwxqpefCmjKRhRchOUf9v46Vidx+A
	6pAMCExw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2yvc-000000007Df-1eZV;
	Fri, 03 May 2024 21:50:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nf-next PATCH 5/5] netfilter: nf_tables: Correctly handle NETDEV_RENAME events
Date: Fri,  3 May 2024 21:50:45 +0200
Message-ID: <20240503195045.6934-6-phil@nwl.cc>
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

