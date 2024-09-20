Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E6183CD8
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863844; cv=none; b=jcJKyjUiMRDVn64IXV7r+uvpwOoC8klcW2qbEjwD473Xdt0t2nl+7ilA7d6mSH3ASS4YlEUmMHhpLyob6X1R4s54aKt1iGLq2yQI2JgBzAt7Oer6jwAjaQ2KfmfAbb+aEd6qA4rxCKBeW/slD6hWg8FmJ4AwtAX5/5wjcfqyHP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863844; c=relaxed/simple;
	bh=c3H08C+4Kj+CfAJcaC0bIzC4l/fwEVtYjL0lQpdhpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQvG8r+tetKDUlhYk+AvWLp+/5ohKdxclXTovCYBZBCVy2ZHc48hBq5BzpbUGDzJyYWqajQZuZ4EJxAskYPn0mp9Kf9dCQrc3AeTUTHSrVCpgT4YPWHyAcFaT2Rh3v9xXulxkA+B9LkRLbrw6VlC8mMXJDTWKlLJUzmzv5hlxs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K+uZZd1+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K+uZZd1+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RHAnDVU/m3T+BFI1L1P8wk+rTXAl1Bp/B1tFdeqc9oQ=; b=K+uZZd1+EpNzVGw0M0lkLQbsAW
	QBnDExBoOUsRalgk72eLzr5niwIcum8ZC3k5uqEER9ATgK/L8BfJSrZki6G83/gxQWB3FSddS1wIt
	QDQiXX98NX5MZq4WXTmdP+/Kh3k//kptPlJXENh7r70Nw5uN/xEt0AD61byxHpox7shJmgvaupyRE
	FhFDvNMursqiHUDt0VNgXrut36Unkj2o4Tn9cLebo1s7aH/Z9Tm+kyjHr3S3YJMXHrIA4bKu0szl9
	IhgJoRw5/9jq6hpuA0CMDRk5gHYxdCBucNNwe3SST4TnjOwxxjxz23kyqHeHjzc3E3DEj09pGmoXn
	sGUYqnmQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAV-000000006Ik-0pih;
	Fri, 20 Sep 2024 22:23:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 13/16] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Fri, 20 Sep 2024 22:23:44 +0200
Message-ID: <20240920202347.28616-14-phil@nwl.cc>
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

For the sake of simplicity, treat them like consecutive NETDEV_REGISTER
and NETDEV_UNREGISTER events. If the new name matches a hook spec and
registration fails, escalate the error and keep things as they are.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Register first and handle errors to avoid having unregistered the
  device but registration fails.
---
 net/netfilter/nf_tables_api.c    | 5 +++++
 net/netfilter/nft_chain_filter.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2684990dd3dc..4d40c1905735 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9371,6 +9371,11 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
+	if (event == NETDEV_CHANGENAME) {
+		if (nf_tables_flowtable_event(this, NETDEV_REGISTER, ptr))
+			return NOTIFY_BAD;
+		event = NETDEV_UNREGISTER;
+	}
 	if (event != NETDEV_REGISTER &&
 	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 562af2773a66..0f5706addfcb 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -373,6 +373,11 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
+	if (event == NETDEV_CHANGENAME) {
+		if (nf_tables_netdev_event(this, NETDEV_REGISTER, ptr))
+			return NOTIFY_BAD;
+		event = NETDEV_UNREGISTER;
+	}
 	if (event != NETDEV_REGISTER &&
 	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
-- 
2.43.0

