Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047CA25FA0E
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747780092; cv=none; b=RfhU/thDyZ6fg5AZAUCgOiou2gVseOI5WCdLgP073+BKwyJsk/UMxoj3KssZ9JUFhQcFSDX8alsmr/ShgtWfjpOph4BoI4Vh+zW2qzHi7TYYJdMJJWDqOm/1uClW6bkUJ4tuxYczuFqIbpGhrpSh9MZ6P07haYEJIsOa1MxprZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747780092; c=relaxed/simple;
	bh=PqJ0nluBrLX/xhLCgjGMeHX86GpfX/cx7facyofrx6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sw+UtIWV2RnGxHTYJ63M7Pg2Mzva8/lelwxj9imGMWm6qzQmZA8vu5kg8e11XbtB7Nhfv+oWbzotun//cxwoFykrqKMo/9jJxHTLi7ZMmdp+Y/XYe8pWjNVAeKLHjcIf6EndUcRnStYrbpx2pqzJRzC+31zKsjOYlBNgwhUkPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rvx6wCOX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KkhYz6Nf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rvx6wCOX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KkhYz6Nf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2842B60781; Wed, 21 May 2025 00:28:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747780086;
	bh=bYSB1bJCEO1Tgx1fIY5h5m6M53P9Evo+RtQQOgS8YnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rvx6wCOXUDvnEOko+Ya3FbhQBeIsRsNXl2B3tZ6Iz6ldlHRHPmvEDuTVCYUvrwkcU
	 IGxGqxphTFYP7j6SxZvfWbtiYVvENGJEZ6wOZ2FLbGAZX6FaAKgd5ylKr/giAJf/Tw
	 6d5ecSAcquyp+1oXLQb0indIfIk0LHEmN+ALECC3+cLDUupIFweJbsNSix1/C5N+I8
	 jVHnuHnHFVz3MbNX9HngYFi8PuPPB3oqybpZGTpoVcurATcR5r9qvMO7tCR6ZEvfvv
	 r7gps0eryYlosVoX7ZO300Xqc1/WxeMQWWZlNHgQbf/K88H8cqxiko7rEq0HuhVW/R
	 h+fxvEBDYuIqQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A70FE6077B;
	Wed, 21 May 2025 00:28:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747780084;
	bh=bYSB1bJCEO1Tgx1fIY5h5m6M53P9Evo+RtQQOgS8YnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KkhYz6Nf7Q844DoXMlIhKGxMMK6zBsMc7uDndeN4zIgjyshOgtFblxo2OyhETjz74
	 7pKBHSqEoN13ODCGBqKYsKLfecvhBrLRRr1PnBNESdHI8mVEOp30wdT5AEtpUsTtkY
	 Erx7JIoOp9ffe99vFDq5QM+9R0t9hnNOKb6s8chw8yJVELt1v1X8SqP6Vrrow9yhmA
	 qJReYYkeZiAs+U2puIxDPJxkSRQSc9zDfboDPeF/UPHcPTwbgz4QjVuCSl5cVJ7vw0
	 Pq13/wTEVgbvXQx8IBa4rgx3w/RI8ysI7AGfCYqEwulKF6b5LDF513RLpxffpMm/9d
	 dTMF0Q8+Ofibg==
Date: Wed, 21 May 2025 00:28:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aC0B8ZSp8qNzbPqR@calendula>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>

Hi Phil,

This looks very good, I still have a few comments, related to three
patches:

== netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook

1) There's a possible inconsistent use of list_for_each_entry{_safe}
   while calling nf_unregister_net_hook().

 static void nft_netdev_unregister_hooks(struct net *net,
                                        struct list_head *hook_list,
                                        bool release_netdev)
 {
+       struct nf_hook_ops *ops, *nextops;
        struct nft_hook *hook, *next;

        list_for_each_entry_safe(hook, next, hook_list, list) {
-               nf_unregister_net_hook(net, &hook->ops);
+               list_for_each_entry_safe(ops, nextops, &hook->ops_list, list) <--- HERE
+                       nf_unregister_net_hook(net, ops);

[...]

@@ -2923,8 +2962,10 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 err_hooks:
        if (nla[NFTA_CHAIN_HOOK]) {
                list_for_each_entry_safe(h, next, &hook.list, list) {
-                       if (unregister)
-                               nf_unregister_net_hook(ctx->net, &h->ops);
+                       if (unregister) {
+                               list_for_each_entry(ops, &h->ops_list, list)   <--- HERE
+                                       nf_unregister_net_hook(ctx->net, ops);

Which one should be adjusted? I think _safe can be removed?

Maybe add nf_unregister_net_hook_list() helper? It helps to avoid
future similar issues.

2) I wonder if nft_hook_find_ops()  will need a hashtable sooner or
   later. With the wildcard, the number of devices could be significantly
   large in this list lookup.

@@ -9611,9 +9666,12 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
                                      const struct net_device *dev)
 {
-       if (hook->ops.dev == dev)
-               return (struct nf_hook_ops *)&hook->ops;
+       struct nf_hook_ops *ops;

+       list_for_each_entry(ops, &hook->ops_list, list) {
+               if (ops->dev == dev)
+                       return ops;
+       }
        return NULL;
 }

3) Maybe move struct rcu_head at the end of struct nf_hook_ops?

 struct nf_hook_ops {
+       struct list_head        list;
+       struct rcu_head         rcu; <--- move it at the end of this struct?

   This is a control plane object, but still it is common to place
   this at the end. But not a deal breaker.

4) nft_netdev_event() is missing a break; I think it is an overlook?

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 783e4b5ef3e0..bac5aa8970a4 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -332,9 +332,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
                if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
                        nf_unregister_net_hook(dev_net(dev), ops);

-               list_del_rcu(&hook->list);
-               kfree_rcu(hook, rcu);
-               break;    <------------------------- this is gone!
+               list_del_rcu(&ops->list);
+               kfree_rcu(ops, rcu);
        }
 }

but I can still see break; in the flowtable event handler.

So nft_netdev_event() shows no break;
But nft_flowtable_event() still has a break;

== Support wildcard netdev hook specs

Nitpick: the err_ops_alloc: tag takes me to nft_netdev_hook_free(hook);
maybe better rename it to err_hook_free: ? Because currently
err_ops_alloc takes me to nft_netdev_hook_free(hook);

@@ -2323,7 +2323,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,

        err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
        if (err < 0)
-               goto err_hook_dev;
+               goto err_ops_alloc;

but takes you to free the hook:

-err_hook_dev:
-       kfree(hook);
+err_ops_alloc:
+       nft_netdev_hook_free(hook);

== netfilter: nf_tables: Add "notications" <-- typo: "notifications"

I suggest you add a new NFNLGRP_NFT_DEV group for these notifications,
so NFNLGRP_NFTABLES is only used for control plane updates via
nfnetlink API. In this case, these events are triggered by rtnetlink
when a new device is registered and it matches the existing an
existing device if I understood the rationale.

Thanks.
