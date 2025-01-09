Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11618C01D
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443907; cv=none; b=OKgTO1nDF1N6cuv8DOWUb/PM6R2BAMfkAIry00hI8+bxMumiMNI+MK83r7jug2KsbH17fyZr3wuFa7nwPpctuMhWhGm663yb3/qDRKOFSfvF5j/e51LbaK1VZviryOEVvRwPuglHe3u39vwN7jzTkw2PZGamoZXR8wPhEKYmM+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443907; c=relaxed/simple;
	bh=2RgnOROUCYKDEUHcRxQP16vwUkg+RNOwf8bqeharBSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbsZ81U0o3t798HGuD3rVO1B9TwpQ2US5Idj5FpiH/PZk7HwbGJ+uxWDXx4P7SH7oeeK4jCUkz8IWkiUl2CkrPZBPbs6gliVn28fv0+uffu9YdsIj6UraoYU6HD8V+aZRcDCLc2xmrSjmSp3w9iEO9qwhCwEjHSk1oGuBpmk9MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TghNlN4G; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TghNlN4G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CYrY/UH/lFC+HuUl/zeyBke0JbinSFe/ruNUPmi+XBk=; b=TghNlN4G455FpqEIk50ZLbeIJs
	6KZ4TqdJvxCGVpsjsqQqnELxRRgKk+P8CbJIaJ+biICKYohoBJtPTipUuo6cuzY6ha3HR0VXS8rdP
	wEaNDAqhkgBfOtrwQysg5R/gDaR5Kj1H2j29qf8GYqRGmSWs9CDo2wOLJRARK1Kbu+539W162YYAJ
	Z9/2FeO6FwgkprcS5nW3hJBYIa+I5Sm4dnjfPzy6xa9iASmVy3zzCZwDsj3VJ2FI5NIc7pu97NfjH
	qhny8VotR2AE2Tse+5j2gWyb9k1ApMeDwkN012kjGyHlXyBtn2gFD0Jsx5L3U8pdn20mIehKhTqOL
	HkyxkQDA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNk-000000006N0-01aN;
	Thu, 09 Jan 2025 18:31:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 3/6] netfilter: nf_tables: Use stored ifname in netdev hook dumps
Date: Thu,  9 Jan 2025 18:31:34 +0100
Message-ID: <20250109173137.17954-4-phil@nwl.cc>
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

The stored ifname and ops.dev->name may deviate after creation due to
interface name changes. Prefer the more deterministic stored name in
dumps which also helps avoiding inadvertent changes to stored ruleset
dumps.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fdb14b357f71..900b6c7d5fd6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1956,15 +1956,16 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
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
@@ -9280,7 +9281,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	list_for_each_entry_rcu(hook, hook_list, list,
 				lockdep_commit_lock_is_held(net)) {
-		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
+		if (nla_put(skb, NFTA_DEVICE_NAME,
+			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.47.1

