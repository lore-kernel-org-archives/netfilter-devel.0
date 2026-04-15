Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD432E126
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 21:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776287116; cv=none; b=otxH/bLCYESFhKEhf6N2kCEPRDWelLd1DrtFWsgqWDD6N9+Jsmkd7XdmB2TKqSkcTB30XQ2ORq+eJQ+XvajiFrbdMK3AIf8cdc1m0eudw3PxNSg0hl9YNuTvV6VU6MVZjWEOx9/nfkW2yEtL9r0o46g391dj+f9IwEnlZHFznF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776287116; c=relaxed/simple;
	bh=/eVvfb8/C8kUFuTyoeLhPmkqaypi3fjfMIere346t4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uq6sOOeZzeTJ0xhm1xw3QNChg6743M5+iZZEggdwKOPDOr+afXwC/3b02BnsawM8FD33kvjoQtvVDk5/7/RMcL1f6S3nD+erzv2uc9UJ3NBCzjOQf6TPj1RrtzDgdDXixqof6tP4vY8E9SGEdORBm6Ot3biDD1FxrsfROhiqAp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BN1+Vxap; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BN1+Vxap"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 556FE60179;
	Wed, 15 Apr 2026 23:05:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776287112;
	bh=dfio/Z1nmstskWHxDhbghMcef7Ivh4JdWJdtQJHVcCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BN1+Vxapa6wGEr1vUxdzdp5lUIAhdgThF9qRd2fBk2U89WgjTHUJpwYzSQmiIZjmC
	 jxcl1SmZFgQyE0HyxL+s57DSrtrSn9XqH7qjV4PmpZMjZrhix1D4k0h8MvwRRPADPz
	 RfQlNdy4qmZr2EXFAhwXUsXla5D7098hKvCdISbsVayQlX3GbDDgLyY3MkoFUcGRC/
	 KoQjrXB9dNfXpTSlKSK4n5PkxBO1uprs6m6zeeiTVHtpMyTKIkLH3f/uKgUx/wcNjQ
	 vscFeTQcK/dir/ngo0Xp2CDjMTs+AuOSX77NbumXO9+NaLejLLfUdc7l/bdriI8MDH
	 jDM4/uFV6bYFQ==
Date: Wed, 15 Apr 2026 23:05:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 3/3] netfilter: nf_tables: add hook transactions
 for device deletions
Message-ID: <ad_9hYaAp1Sbj1G7@chamomile>
References: <20260415171038.41442-1-pablo@netfilter.org>
 <20260415171038.41442-2-pablo@netfilter.org>
 <ad_6PaOwZJRHWgTd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad_6PaOwZJRHWgTd@strlen.de>

On Wed, Apr 15, 2026 at 10:51:09PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Restore the flag that indicates that the hook is going away, ie.
> > NFT_HOOK_REMOVE, but add a new transaction object to track deletion
> > of hooks without altering the basechain/flowtable hook_list during
> > the preparation phase.
> > 
> > The existing approach that moves the hook from the basechain/flowtable
> > hook_list to transaction hook_list breaks netlink dump path readers
> > of this RCU-protected list.
> > 
> > It should be possible use an array for nft_trans_hook to store the
> > deleted hooks to compact the representation but I am not expecting
> > many hook object, specially now that wildcard support for devices
> > is in place.
> > 
> > Note that the nft_trans_chain_hooks() list contains a list of struct
> > nft_trans_hook objects for DELCHAIN and DELFLOWTABLE commands, while
> > this list stores struct nft_hook objects for NEWCHAIN and NEWFLOWTABLE.
> > Note that new commands can be updated to use nft_trans_hook for
> > consistency.
> > 
> > Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
> > Fixes: b6d9014a3335 ("netfilter: nf_tables: delete flowtable hooks via transaction list")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: no changes.
> > 
> >  include/net/netfilter/nf_tables.h |  13 ++++
> >  net/netfilter/nf_tables_api.c     | 124 ++++++++++++++++++++++++++----
> >  2 files changed, 120 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index ec8a8ec9c0aa..3ec41574af77 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -1216,12 +1216,15 @@ struct nft_stats {
> >  	struct u64_stats_sync	syncp;
> >  };
> >  
> > +#define NFT_HOOK_REMOVE	(1 << 0)
> > +
> >  struct nft_hook {
> >  	struct list_head	list;
> >  	struct list_head	ops_list;
> >  	struct rcu_head		rcu;
> >  	char			ifname[IFNAMSIZ];
> >  	u8			ifnamelen;
> > +	u8			flags;
> >  };
> >  
> >  struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
> > @@ -1676,6 +1679,16 @@ struct nft_trans {
> >  	u8				put_net:1;
> >  };
> >  
> > +/**
> > + * struct nft_trans_hook - nf_tables hook update in transaction
> > + * @list: used internally
> > + * @hook: struct nft_hook with the device hook
> > + */
> > +struct nft_trans_hook {
> > +	struct list_head		list;
> > +	struct nft_hook			*hook;
> > +};
> 
> Do I get this correctly?
> 
> nft_trans_container_flowtable(trans)->hook_list
> and
> nft_trans_container_chain(trans)->hook_list
> 
> Either hold 'struct nft_hook' objects or nft_trans_hook objects?
> Former when adding, latter when removing from existing base hook?

Add, update -> struct nft_hook
Delete -> struct nft_trans_hook

Yes. I could add a separated list, but this list is exclusive for the
transaction object. Another option is a union to highlight how it is
used, but it is not better than the current mixed semantics, which are
not ideal.

As a follow up, it should be possible to use nft_trans_hook for
updates too in nf-next for consistency.

> > +		trans_hook = kmalloc(sizeof(*trans_hook), GFP_KERNEL);
> 
> Note that 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
> transformed such allocation requests to use "kmalloc_obj(*trans_hook, GFP_KERNEL);"
> instead.

I will replace it to use the new kmalloc_obj().
