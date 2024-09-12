Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0928A1A2C10
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143725; cv=none; b=FMVp+42aNi8+IKmCgJGi8j0U+iyk26HWOAYGzIOGjEoVfxIBdp/gDnYEMR3hOrbgd8ZM/epRK4drjLiO15b1qwWtRzs0IJs2bfblvlXW2jCEYuXPeB6QdZEvlVoTxioichXE2xK4reQnibM3RByc6OOVxNs+hmsGS04L8E/Owto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143725; c=relaxed/simple;
	bh=lcI6dI15XbivG9aNu+aNjF9Y02PYd9Rxrz7efPI8SmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAVCakgIyv0CbHPb7GXGGL/GQEjFCyWSIJLaen1URTs9W8cw+gU4pUCi6JuWphnIkF/TgmSQAt2SPzwleCnXyqgIU84Vds1UMXggFqc1BvXGb/OGr6F5umTCany7n+qO7Ro/XGEs3A3xoCGVmz5zzjAshgaKOzaVOelPmXE9x6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B1bjXV8K; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B1bjXV8K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DcVUZgY5BJoC650aBVKLDBCvFccHB9KT65CVnLGbu8k=; b=B1bjXV8K/tvz960rD2vlhLQvbs
	ZHRrUHml35LmYQO/wLvimBPNvhhj1Z05ERsDhCU/ZxTKW8AMYf5Gps094QJRsWf+xYoeR0u57qHVz
	uAr1rUcI6hO/1ck7zoZCMwkNXj8z1PWSsOYCBkK+ArlARtHiB/aer7zJ7Qb9Kc6zlT2J3tUqvQpGF
	u/L1Ldj2iQDa11B/4mHY1WFh675Y5L2wyl7JTK2ZOPwHM/Ba9PfEz4ss/4VZUbWolrKbFbd8nRh/S
	mFjzRmBrSAHexbHUUesC03xlhtrnJqmcFGPX9sfA+3xhf9rAfTpZ4pm/2477w2dJvIzSyoKOWupjR
	ccqRMltQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipm-000000004F3-1Yj8;
	Thu, 12 Sep 2024 14:22:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 04/16] netfilter: nf_tables: Use stored ifname in netdev hook dumps
Date: Thu, 12 Sep 2024 14:21:36 +0200
Message-ID: <20240912122148.12159-5-phil@nwl.cc>
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

The stored ifname and ops.dev->name may deviate after creation due to
interface name changes. Prefer the more deterministic stored name in
dumps which also helps avoiding inadvertent changes to stored ruleset
dumps.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f1710aab5188..4fb230e4afe3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1853,15 +1853,16 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 			if (!first)
 				first = hook;
 
-			if (nla_put_string(skb, NFTA_DEVICE_NAME,
-					   hook->ops.dev->name))
+			if (nla_put(skb, NFTA_DEVICE_NAME,
+				    hook->ifnamelen, hook->ifname))
 				goto nla_put_failure;
 			n++;
 		}
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
-		    nla_put_string(skb, NFTA_HOOK_DEV, first->ops.dev->name))
+		    nla_put(skb, NFTA_HOOK_DEV,
+			    first->ifnamelen, first->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -8968,7 +8969,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		hook_list = &flowtable->hook_list;
 
 	list_for_each_entry_rcu(hook, hook_list, list) {
-		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
+		if (nla_put(skb, NFTA_DEVICE_NAME,
+			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.43.0

