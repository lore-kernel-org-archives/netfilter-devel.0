Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA48E1AC459
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147611; cv=none; b=HYmE/vxBpWK3utYLJIz9ziTRz8TYiKQOTv7xuzkhGeAXSmD3yWxCybJHYH1p/VokAjv7pZcykNKA38/XVbZqyCCh5qKn6AuG0Ce0vgScLSEiIa/W8DappJiOmMZY/IWgUtc+0tphc/W0ez9W1YLNdcGdYXjY2xDqOUjEJDN3l1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147611; c=relaxed/simple;
	bh=23G8A3nl3eau6FH1OOhCAmsaBPWNcg6783Yqxz+OKio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owbA8WF2vUzLS/kXohAN+QLfISmid4HxUpHErgwVUjMHJwICbdNU1bW1IpVr2tpY5Bb4XG9aa+N7cVvSDrJlKwOw898Kho2/T5Xh5NhxNnZEgiaA8hKGob46DOdnEGmDfCgEZ3rFjyAINEEg/gysLTJ6TwGwV2su6x56PamywE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B9HSIVub; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B9HSIVub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YWpMJfMT7UnbqoQPyzdWjkdHkvw/OblAhzedJPmlWGI=; b=B9HSIVubkyiLkvjMf+drFB01gt
	2KS7cbpsZsBJI1eXxMaBgeeAi14+RfSJkVK/4dBJXNxfRsrWcJZBrdmeSMzsb4iNdtnIi9dHRK2pA
	tH9w+FAuEiBKcdpb5iEUpClsZGdCQgb/kFzd+G03C+9SyJVCDg5OVrRycPYQoAkD4Ik/nFPU9E1NO
	nQd8qj3oTNWV1LWNwIb+C+zIwWW9dFiR9CVoBlBAH9+lYvn+fsmqPU0CSuxZ4m+BHbZEVaiOk47sQ
	0YCoLcLhOd4QZKir2B1GIQAzywr0DENY1JBOmX3rWiLb9mlYkfv1qD3XfWiX43qH22Wv03senjyZn
	shLTR3Yg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sojqQ-000000005Fc-3GQF;
	Thu, 12 Sep 2024 15:26:46 +0200
Date: Thu, 12 Sep 2024 15:26:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 03/16] netfilter: nf_tables: Store
 user-defined hook ifname
Message-ID: <ZuLsFhYzWH5ql-k2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-4-phil@nwl.cc>
 <20240912125641.GA2892@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912125641.GA2892@breakpoint.cc>

On Thu, Sep 12, 2024 at 02:56:41PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
> > and store the interface name and length as specified by the user upon
> > creation. No functional change intended.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/net/netfilter/nf_tables.h | 2 ++
> >  net/netfilter/nf_tables_api.c     | 6 +++---
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index c302b396e1a7..efd6b55b4914 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -1191,6 +1191,8 @@ struct nft_hook {
> >  	struct list_head	list;
> >  	struct nf_hook_ops	ops;
> >  	struct rcu_head		rcu;
> > +	char			ifname[IFNAMSIZ];
> > +	u8			ifnamelen;
> >  };
> >  
> >  /**
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 3ffb728309af..f1710aab5188 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -2173,7 +2173,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
> >  					      const struct nlattr *attr)
> >  {
> >  	struct net_device *dev;
> > -	char ifname[IFNAMSIZ];
> >  	struct nft_hook *hook;
> >  	int err;
> >  
> > @@ -2183,12 +2182,13 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
> >  		goto err_hook_alloc;
> >  	}
> >  
> > -	nla_strscpy(ifname, attr, IFNAMSIZ);
> > +	nla_strscpy(hook->ifname, attr, IFNAMSIZ);
> > +	hook->ifnamelen = nla_len(attr);
> 
> 
> Hmm. nft_netdev_hook_alloc has no netlink attribute policy validation
> :-/
> 
> Can you add another patch that fixes this up?
> 
> 
> I'd suggest to move the if (nla_type(tmp) != NFTA_DEVICE_NAME)
> test from nf_tables_parse_netdev_hooks() into nft_netdev_hook_alloc
> so nft_chain_parse_netdev() also has this test.

I fear this won't work, because nft_chain_parse_netdev() may call
nft_netdev_hook_alloc() directly, passing tb[NFTA_HOOK_DEV]. For
NFTA_HOOK_DEVS though, it calls nf_tables_parse_netdev_hooks() and thus
the nested attribute type check in there applies.
> 
> Then,
> > -     nla_strscpy(ifname, attr, IFNAMSIZ);
> 
> Into:
> 
> 	err = nla_strscpy(ifname, attr, IFNAMSIZ)
> 	if (err < 0)
> 		goto err_hook_dev;
> 
> so we validate that
> a) attr is NFTA_DEVICE_NAME

As said above, it may be NFTA_HOOK_DEV as well.

> b) length doesn't exceed IFNAMSIZ.

ACK. I think a) is already being asserted in spots where NFTA_HOOK_DEV
is not expected (which in turn has a policy).

> ATM this check is implicit because nla_strscpy() always
> null-terminates and the next line will check that the
> device with this name actually exists.
> 
> But that check is removed later.
> This patch can then set
> 
>  hook->ifnamelen = err
> 
> without risk that nla_len() returns 0xfff0 or some other bogus
> value.

Ah, nice!

From my perspective, all it takes is the nla_strscpy() return value
check in this patch to cover everything. Right?

Thanks, Phil
