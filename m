Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBEE184542
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863841; cv=none; b=efFgEQNNGtARMDmYvtq006Bruio9AJSQrmS3cxz4OMd9V+T8CW7AuYXLfM+9hKOtotWq/k8QTWBnUXl0km7SJR0CWOC/oxyfIsF3LxhYmoPG/iyBJTt0sGMsEMqIKqPCM1TLGMI3GBdZV72PhHiOruW1j+2cuOl20aTNg2R1DPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863841; c=relaxed/simple;
	bh=i3CGuYKh9WWv7t9tYDauReZqpXZ9PqCpFRjvn7QtAVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nimdnicQydE7p3kGW1cRAkmJzWTn9B+9JlM5U+tRWbFiQYL1/liOxPntiAY6fLsTh9O9BZqMNmj9xqW570+sGnKaZYQV6WFKgBRv64fn5S/k9HPAcmG+9+zLCRdYXlW6VfVyadqUEl5iUgTJSL3TKrEZ95ke2t3JC/35D33ZQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mNpRVWza; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mNpRVWza"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qVrRCoakoMABR+z57N4tSPOKSBsHTCzfmeNC/X4tujA=; b=mNpRVWzaerNGCu+KB8ZyVdf0Ua
	pwNgLhno955yNQ6+/HJCXMOV8q270DG/51Sy7o4rJRYueb21eTRsQK03sH74QgYyM92QUjs7DckqA
	59Jl3LHA3UM+4p+nABUPpzAwSRAcxkureAK34THE59G84k5qLBGePKRGj467XWkKR1zxU8PsvcgaA
	e5fr1NlQsqhDi2EekOJYT2lAi8BNq8JCo1SyGpdXWr8/m3rEMVJXrGViaCjQxFVhk02gWxPK7FxyC
	MFCJyiEE9Kg6a7K0Nran9PQG8oqpM8eGnRnFXI3Y9pFP/Huu+ne1VlQQpoQOjFxoYVBBiP7h3/w5C
	nv/ezL1Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAS-000000006II-3LZV;
	Fri, 20 Sep 2024 22:23:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 03/16] netfilter: nf_tables: Use stored ifname in netdev hook dumps
Date: Fri, 20 Sep 2024 22:23:34 +0200
Message-ID: <20240920202347.28616-4-phil@nwl.cc>
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

The stored ifname and ops.dev->name may deviate after creation due to
interface name changes. Prefer the more deterministic stored name in
dumps which also helps avoiding inadvertent changes to stored ruleset
dumps.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2ec3e407f91f..c53afdecef24 100644
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
@@ -8999,7 +9000,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
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

