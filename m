Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C706E19F42E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 13:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148938; cv=none; b=DcJLDKPMxZKCBapYCiRHBrf4gGlkXkVCM39t5WlxvdeA8mMH7YDorzWyJGOZlpDDy2W4OyMExGOQLDOeEc5lBipfmPn7BK2WEPmyHvseyLpFcqMzi2Iz9Er6sSuc4itAIbMzoe4hOJpdqg14K1CoGM3ghU/niotomcXbuI+CDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148938; c=relaxed/simple;
	bh=tOvalzDbTdGiCz+WwZ9ab2rPv4EXsxl5zFF5W/PeDJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNVf7T8ZtwGCL26dgiG1yvaqqLtWucrrjefkJrZh+nY4RbcMkfodIrQFZkwTpj5dXiFbH3/4EtVQNIuMgHpfmHS7/JNkbr2n7zNO17u+WtDQ+3hhPFaoz/jm87qkqqttihZOuvqEu5CXhIkXId57wRTyabvjdnB6hi5NaMhYObo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A2QeCpKi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A2QeCpKi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GstM8bzT8zuqh0yuGK9Sz9Td8WbphlB2DWI4W58OnHM=; b=A2QeCpKiH5g3A7y8PJZofyxyah
	K+3uXAprTS8XICaZUS+g5yvfYFCQCrI2RUnCkgGu/4oEyEjRa+ehH2ldZeZmjNiEEmsOCdmnGBX8G
	dM9cYtVfPH9uUQ0BZi4MuXngZ0iE9gViAE+l7Ck/U7FoPOt+gPpXZ5ISIPX+dYyfnT8kKVKWY+780
	BjpxDknRQHgfV/yGF1epGBKr4PKTaWZw/9miC7s6zPnO+GNFjL/Nbxb+P3f36ceKoI8Q1STyNoA2n
	IXE7G77gGm1qCzB/xElUAJ/is3Lal5eJsVU+5uyalUkIMANjr+61p3GavuyY4fMO73k1zN4B7e6VS
	1dkNPrww==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sokBq-000000005cD-0Fsw;
	Thu, 12 Sep 2024 15:48:54 +0200
Date: Thu, 12 Sep 2024 15:48:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted
 flowtable hooks until after RCU
Message-ID: <ZuLxRi8asgeW1oLB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-2-phil@nwl.cc>
 <20240912133255.GB2892@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912133255.GB2892@breakpoint.cc>

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
> >  	}
> >  	kfree(flowtable->name);
> >  	module_put(flowtable->data.type->owner);
> 
> AFAICS its safe to use list_del() everywhere, I can't find a single
> instance where the hooks are iterated without mutex serialization.
> 
> nf_tables_flowtable_destroy() is called after the hook has been
> unregisted (detached from nf_hook list) and rcu grace period elapsed.

Yes, I didn't find a caller which didn't synchronize_rcu() before
calling it. Same applies to chain hooks, right? I'd drop all the _rcu()
calls and give it a try, but the resulting race conditions may be hard
to trigger.

Cheers, Phil
