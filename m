From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: PTR_RET can be used
Date: Mon, 20 Aug 2012 16:51:44 +0200
Message-ID: <20120820145144.GA18676@1984>
References: <20120729004550.GA7049@localhost>
 <5015280A.6000105@bfs.de>
 <20120729121449.GA16489@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: walter harms <wharms@bfs.de>, netfilter-devel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52798 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab2HTOv4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:51:56 -0400
Content-Disposition: inline
In-Reply-To: <20120729121449.GA16489@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 29, 2012 at 08:14:49PM +0800, Fengguang Wu wrote:
> > > --- linux.orig/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:09.703759534 +0800
> > > +++ linux/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:14.255759643 +0800
> > > @@ -100,9 +100,7 @@ static struct nf_hook_ops ebt_ops_filter
> > >  static int __net_init frame_filter_net_init(struct net *net)
> > >  {
> > >  	net->xt.frame_filter = ebt_register_table(net, &frame_filter);
> > > -	if (IS_ERR(net->xt.frame_filter))
> > > -		return PTR_ERR(net->xt.frame_filter);
> > > -	return 0;
> > > +	return PTR_RET(net->xt.frame_filter);
> > >  }
> > >  
> > 
> > i do not understand this,
> > ebt_register_table() return (struct ebt_table *) on success
> > 
> > Does PTR_RET really return 0 if this is a propper pointer ?
> 
> Right. Here is how PTR_RET defined. This patch does not change any behavior.
> 
> static inline int __must_check PTR_RET(const void *ptr)
> {      
>         if (IS_ERR(ptr))
>                 return PTR_ERR(ptr);
>         else   
>                 return 0;
> }

Applied, thanks Fengguang.
