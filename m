From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] netfilter: PTR_RET can be used
Date: Sun, 29 Jul 2012 20:14:49 +0800
Message-ID: <20120729121449.GA16489@localhost>
References: <20120729004550.GA7049@localhost>
 <5015280A.6000105@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: walter harms <wharms@bfs.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5015280A.6000105@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> > --- linux.orig/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:09.703759534 +0800
> > +++ linux/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:14.255759643 +0800
> > @@ -100,9 +100,7 @@ static struct nf_hook_ops ebt_ops_filter
> >  static int __net_init frame_filter_net_init(struct net *net)
> >  {
> >  	net->xt.frame_filter = ebt_register_table(net, &frame_filter);
> > -	if (IS_ERR(net->xt.frame_filter))
> > -		return PTR_ERR(net->xt.frame_filter);
> > -	return 0;
> > +	return PTR_RET(net->xt.frame_filter);
> >  }
> >  
> 
> i do not understand this,
> ebt_register_table() return (struct ebt_table *) on success
> 
> Does PTR_RET really return 0 if this is a propper pointer ?

Right. Here is how PTR_RET defined. This patch does not change any behavior.

static inline int __must_check PTR_RET(const void *ptr)
{      
        if (IS_ERR(ptr))
                return PTR_ERR(ptr);
        else   
                return 0;
}

Thanks,
Fengguang
