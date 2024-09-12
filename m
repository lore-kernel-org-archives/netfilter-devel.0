Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FBC1A7AE3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145141; cv=none; b=SBlGaKbh1ivgA3gBGLnL5MOJsykfwqP3+hIvTtAg8fado8LMJFQYzhefwMihVrgb9svFBCkfzMsG707vIpTbauu5qUh/7od4uczDUlAHoO0s+TaK/M/YTtCfC6A9joNByKrIb7LV225vQk0YJ0rU7Xcsgirl4aW8+E7v30262J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145141; c=relaxed/simple;
	bh=hdO33bZYWUXTA2ZWtPUzBCvsaHLJ8k7RWYycXs6s/tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6UyrT5KrAWsmWkOgliRpCh34Mkfv/xhWv2aDUuoGdIG5vu9MNyYZJ5F7Lrmx0akPXJ79ZRTX92cnEMXPf42AeKLnLX/JI+9d8LAzUUjkVoEU/w08cNmNbXCEX9Zus5Cmi1L7meeKcNv16O8PJDsRLEAfkqFXVonlT8YViLTSBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bgoGJG/z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bgoGJG/z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6cTrgOBMJ0fmS03g0nS1f7ZauA8PCmX0/1nA4xv955E=; b=bgoGJG/z046ACJ8OtjKOQNqGkW
	DtOQT0u7+MRqT5qfNPd1JpH6dsE4A6m6QxdqBG53eKQuUQuYg8lv2RMEq8Ui/ybglVmw+01qDh+8f
	oAdYMjcy4uxqsjDgMKGaq7431ikDhVOp/iYzDVyCM5LSjSQ/8VksLCVTjo3QDvr4lmoqulL/dbDjZ
	M1F04XZPsb49tIeuUugcBimCbaH7ZgUm5AjcCvoFSTcZEe0H4CKYlGfa5bd6EAnMUfCXbm95gpdiw
	XuYuJ7SgCwZqa42MqDiJYWlC+6RuQXzaxBizAjURpC1YLpNFASYDIOm/5eEnZfEW//SS1Pz736Wvf
	mWBiX/BQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipd-000000004DM-3zHK;
	Thu, 12 Sep 2024 14:21:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 13/16] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Thu, 12 Sep 2024 14:21:45 +0200
Message-ID: <20240912122148.12159-14-phil@nwl.cc>
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

For the sake of simplicity, treat them like consecutive
NETDEV_UNREGISTER and NETDEV_REGISTER events.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 4 ++++
 net/netfilter/nft_chain_filter.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 40cff8539c74..88528775732a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9361,6 +9361,10 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
+	if (event == NETDEV_CHANGENAME) {
+		nf_tables_flowtable_event(this, NETDEV_UNREGISTER, ptr);
+		event = NETDEV_REGISTER;
+	}
 	if (event != NETDEV_REGISTER &&
 	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ec44c27a9d91..4f13591e5cd1 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -372,6 +372,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
+	if (event == NETDEV_CHANGENAME) {
+		nf_tables_netdev_event(this, NETDEV_UNREGISTER, ptr);
+		event = NETDEV_REGISTER;
+	}
 	if (event != NETDEV_REGISTER &&
 	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
-- 
2.43.0

