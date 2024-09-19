Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA8919C57B
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 10:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726742712; cv=none; b=Wl98bR6pfTZwHn/1W2qPArDhhLYvB1l2bvxMtIh6bN3X+Od0kJ9JEaJ9n9rf7dYthM7l8PUdcvgXvsGbU18oHOWqhIKaZbTc3FUiHOuznX1NLIbL8M2HUGciXrmnAHRoPcZh0LyHWQoQiLIVv6gfHkDLkGhnDtIfuRTGQM6WadY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726742712; c=relaxed/simple;
	bh=Y/fP0D3pnTrWdlnj8XFMNq4R0Pf1agQ48eA771a9NJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VrkXa8NLXtYNVSyDzg+BAcaHkaWj3wxxE+7YRXjp3ScJt2CUBXn7BFjxTe7Yk+mLXDQP772lnMGIqOXTRVjkH0rMIMUxXfqPbUXS/0gjXZO/L0no3qeL/cOU+6AyJOEyRnVEu2X9xWN7UBZEjP4hqisPKRNex9Jb5rzmXA6oUuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=X1hEbdJB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="X1hEbdJB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c08/SFe0tXRE86xA99WMdWuZ/FWX+cmKv5xzeXmlrzk=; b=X1hEbdJBviSpZv8zI+8p8wew+1
	j9HdH4Aw5vl6DAXnBJ0jICaJhFlr6K/3p74EB7sKzePMR1Qn2T9UZl9Du3FoU8taxUT6ETPJF3mbn
	sLFmQ+fVRDVh1x8Oag3PrLnHEKTezh8G+8otWOGua0WqXwSrYU/ogHGyQ6apno0Utjpc/QUY4Brl8
	Xw5fuSzB6vctoIHm3WEDbKuueqNHXKH0NsMbmXLzcTUhRPZsf26LgBodaAsIs81NE1JHL6B3pP6a5
	jQY73IBbZ3W+4JW/8Ldtt0RSaUgJhIIibv+CSy1wwlCLjp1HYeMZbCVohOU7enmZbh5z1GY89cWoc
	1UWjJlxQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srEep-0000000025Y-1qcp;
	Thu, 19 Sep 2024 12:45:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf PATCH] netfilter: nf_tables: nft_flowtable_find_dev() lacks rcu_read_lock()
Date: Thu, 19 Sep 2024 12:45:03 +0200
Message-ID: <20240919104503.20821-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure writers won't free the current hook being dereferenced.

Fixes: c63a7cc4d795 ("netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_flow_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ab9576098701..8044dbe58ccf 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -173,6 +173,7 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	struct nft_hook *hook;
 	bool found = false;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
 		if (hook->ops.dev != dev)
 			continue;
@@ -180,6 +181,7 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 		found = true;
 		break;
 	}
+	rcu_read_unlock();
 
 	return found;
 }
-- 
2.43.0

