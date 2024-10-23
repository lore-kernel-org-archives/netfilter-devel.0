Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69054146018
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695463; cv=none; b=ho+PiupcAAg9ZHRGBnRhL8C9qp2G7R3rRYh0Xr5m9qFWalo9PzW3YImepussNVfZoJ8CfcpkbNkny6YTwuJkwU9NrGQfnm2vEmC39fV/yvc4R8LPQnib/rqu2q5oWfAtI8xnuZJDCDYuLkZmmxkJi839UzdCI7P9ufLmzA0/69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695463; c=relaxed/simple;
	bh=dL5F5KOtCMzqXoEzY+jSxcJC3WWTuByIzCAmmLgSWTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYahqZED0xHc6bLywF8jjLnR7AzK7ft9UsSB0oB2TC0Z9+WsSgKHkBpU49gqpyXXbLBja10lW+4xmhO1VBv2wzGNWneKDSezPzwrzhfb6z6xqtE1lr0SlTv+A0QhQBbIotVCDYwJ1LZarPLz7JQmoD7Aup5nCEm11HPDEV5TtNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jHc0jvPY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jHc0jvPY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nnlA/BayTD8dUstVGdzoaJ7DcYfyaDZ8vRds1Y4WThA=; b=jHc0jvPYBf9tMfyYOVzfi90OBr
	fnEZbEijmVFP358Mj9yTE75pPO9jjo54Ysi57uMlbth6Z7MSo6cRY6foLd9q9NHBn9tNGSh4vRQgd
	XE9rvCpWtxe9xOrtaIocExySHJC9lrSdnomh/tDNvGApilyuOhUXL0wXHeZBwQC6F3pVvMQSoh8Nb
	7+dQNow3M9XFciM9T+JBSumzizc3e/0jF6wlFuYTyvlB740EwkisaLjF7wFu7pX8CS952BHme5rSr
	n8HPl9YfpxgVuZsSdElzsqn0GV5kSWJOZQYBpMIJldY9tjdhTTx9PNMuaERroCHfTC27ayR3DCrIl
	sIWElv0A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3cnm-000000003sm-0HFW;
	Wed, 23 Oct 2024 16:57:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 3/7] netfilter: nf_tables: Use stored ifname in netdev hook dumps
Date: Wed, 23 Oct 2024 16:57:26 +0200
Message-ID: <20241023145730.16896-4-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241023145730.16896-1-phil@nwl.cc>
References: <20241023145730.16896-1-phil@nwl.cc>
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
index 088c0f901092..ac25a7094093 100644
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
@@ -8997,7 +8998,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		hook_list = &flowtable->hook_list;
 
 	list_for_each_entry_rcu(hook, hook_list, list) {
-		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
+		if (nla_put(skb, NFTA_DEVICE_NAME,
+			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.47.0

