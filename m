Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845921018C;
	Thu,  7 Nov 2024 11:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730980235; cv=none; b=toiyYcGTMaJP8BRSkkxlNckFB6wnGTAGwUNAuYTKLTBCtaTbWeU7PLSB9cax+NGn45ICAgUJ73ewRD3KA2888zcK+VDykGlsBQC/rivGGrmSbI9zTYBTjLLBcaiyLwA5Ku/yAvp3dImT/JrGsL1EkpMX33UcNZVqd5CHRICGKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730980235; c=relaxed/simple;
	bh=unrDUK7EuHXUPbfJ13rQqin9fhrr9yIkm6BHGuTqL9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GT8zPcpl8uW7/48jk1zIxuUXN+UCAPQm3+SiAYZtHvuoc91XXJSlpN8/+ysZd8aw27WqM53Zx1DPZwMltHSELKTKssP6T7CaaXEc3LI9TMPHxq6/ieb2QMchSnvvwMF+Q7ccFcWeDF9HgwTrg9QPvxCcwVWahYZ1XcuZhrZ7SCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42192 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t90eT-00ECKH-GN; Thu, 07 Nov 2024 12:26:15 +0100
Date: Thu, 7 Nov 2024 12:26:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: wait for rcu grace period
 on net_device removal
Message-ID: <Zyyj1KUDDJXEJjkd@calendula>
References: <20241106235853.169747-1-pablo@netfilter.org>
 <20241106235853.169747-2-pablo@netfilter.org>
 <362a90d1-a331-4bcc-8f14-495baf5c2309@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <362a90d1-a331-4bcc-8f14-495baf5c2309@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Nov 07, 2024 at 11:55:47AM +0100, Paolo Abeni wrote:
> Hi,
> On 11/7/24 00:58, Pablo Neira Ayuso wrote:
> > 8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
> > synchronize_net() call when unregistering basechain hook, however,
> > net_device removal event handler for the NFPROTO_NETDEV was not updated
> > to wait for RCU grace period.
> > 
> > Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
> > on net_device removal") does not remove basechain rules on device
> > removal, I was hinted to remove rules on net_device removal later, see
> > 5ebe0b0eec9d ("netfilter: nf_tables: destroy basechain and rules on
> > netdevice removal").
> > 
> > Although NETDEV_UNREGISTER event is guaranteed to be handled after
> > synchronize_net() call, this path needs to wait for rcu grace period via
> > rcu callback to release basechain hooks if netns is alive because an
> > ongoing netlink dump could be in progress (sockets hold a reference on
> > the netns).
> > 
> > Note that nf_tables_pre_exit_net() unregisters and releases basechain
> > hooks but it is possible to see NETDEV_UNREGISTER at a later stage in
> > the netns exit path, eg. veth peer device in another netns:
> > 
> >  cleanup_net()
> >   default_device_exit_batch()
> >    unregister_netdevice_many_notify()
> >     notifier_call_chain()
> >      nf_tables_netdev_event()
> >       __nft_release_basechain()
> > 
> > In this particular case, same rule of thumb applies: if netns is alive,
> > then wait for rcu grace period because netlink dump in the other netns
> > could be in progress. Otherwise, if the other netns is going away then
> > no netlink dump can be in progress and basechain hooks can be released
> > inmediately.
> > 
> > While at it, turn WARN_ON() into WARN_ON_ONCE() for the basechain
> > validation, which should not ever happen.
> > 
> > Fixes: 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks on net_device removal")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netfilter/nf_tables.h |  2 ++
> >  net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++++++------
> >  2 files changed, 36 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index 91ae20cb7648..8dd8e278843d 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -1120,6 +1120,7 @@ struct nft_chain {
> >  	char				*name;
> >  	u16				udlen;
> >  	u8				*udata;
> > +	struct rcu_head			rcu_head;
> 
> I'm sorry to be pedantic but the CI is complaining about the lack of
> kdoc for this field...
> 
> >  
> >  	/* Only used during control plane commit phase: */
> >  	struct nft_rule_blob		*blob_next;
> > @@ -1282,6 +1283,7 @@ struct nft_table {
> >  	struct list_head		sets;
> >  	struct list_head		objects;
> >  	struct list_head		flowtables;
> > +	possible_net_t			net;
> 
> ... and this one ...
> 
> >  	u64				hgenerator;
> >  	u64				handle;
> >  	u32				use;
> 
> [...]
> > +static void nft_release_basechain_rcu(struct rcu_head *head)
> > +{
> > +	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
> > +	struct nft_ctx ctx = {
> > +		.family	= chain->table->family,
> > +		.chain	= chain,
> > +		.net	= read_pnet(&chain->table->net),
> > +	};
> > +
> > +	__nft_release_basechain_now(&ctx);
> > +	put_net(ctx.net);
> 
> ... and also about deprecated API usage here, the put_net_tracker()
> version should be preferred.
>
> Given this change will likely land on very old trees I guess the tracker
> conversion is better handled as a follow-up net-next patch.

Agreed.

> Would you mind addressing the kdoc above? Today PR will be handled by
> Jakub quite later, so there is a bit of time.

I will fix kdoc and resubmit.
