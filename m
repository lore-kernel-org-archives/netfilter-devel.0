Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900022628C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 00:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726444865; cv=none; b=Ba8efzpk7V9sVeUNtRvMacOtMyxCLUqkG/L/7DsLkQceN/dq+60ddpCwWcL0DmGe2nKENEurzRXuTzAplWcV8LBY6wSBdR7jT08N0e2jWWM9Z1ND8rGS4c/goo0KsEVDf/BtDNx2vsFXi1KcjdUwnPdojhIDoBLmm9SCn9SGbfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726444865; c=relaxed/simple;
	bh=Hr4bs2x3RCOvsbF2BemACl+qBt+QQCuCgdir0AI+FxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n86dDbS+Y4WcCgBbiE6dPUczqyvQ+8+YJAmDyBz0xoWepP11V8cncYMpkwBIkb421HXzeBWAMFQThN4VxCWj8u799mICY1Utmk3kkyUI3Rtjpp7SRkKnpqYgUjtRL+Hz3k93lHAtAcSTXfujKwjLmQWkWXMVsFUkihU89JRWJOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56064 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spzAm-00EYGc-IA; Mon, 16 Sep 2024 02:00:58 +0200
Date: Mon, 16 Sep 2024 02:00:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted
 flowtable hooks until after RCU
Message-ID: <Zud1JvDEohYHNbwz@calendula>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-2-phil@nwl.cc>
 <20240912133255.GB2892@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240912133255.GB2892@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 12, 2024 at 03:32:55PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Documentation of list_del_rcu() warns callers to not immediately free
> > the deleted list item. While it seems not necessary to use the
> > RCU-variant of list_del() here in the first place, doing so seems to
> > require calling kfree_rcu() on the deleted item as well.
> > 
> > Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nf_tables_api.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index b6547fe22bd8..2982f49b6d55 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -9180,7 +9180,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
> >  		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
> >  					    FLOW_BLOCK_UNBIND);
> >  		list_del_rcu(&hook->list);
> > -		kfree(hook);
> > +		kfree_rcu(hook, rcu);

This looks correct to me.

> >  	}
> >  	kfree(flowtable->name);
> >  	module_put(flowtable->data.type->owner);
> 
> AFAICS its safe to use list_del() everywhere, I can't find a single
> instance where the hooks are iterated without mutex serialization.

Netlink dump path is lockless.

nft_dump_basechain_hook() is missing list_for_each_entry_rcu() for
list iteration, that needs a fix.

nf_tables_fill_flowtable_info() does use list_for_each_entry_rcu().

> nf_tables_flowtable_destroy() is called after the hook has been
> unregisted (detached from nf_hook list) and rcu grace period elapsed.
