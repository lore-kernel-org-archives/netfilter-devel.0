From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC,v2 6/6] netfilter: nft_flow_offload: add ndo
 hooks for hardware offload
Date: Fri, 8 Dec 2017 22:16:16 +0100
Message-ID: <20171208211616.GC4126@salvia>
References: <20171207124501.24325-1-pablo@netfilter.org>
 <20171207124501.24325-7-pablo@netfilter.org>
 <20171208101836.GH24449@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, simon.horman@netronome.com,
        ronye@mellanox.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171208101836.GH24449@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 08, 2017 at 11:18:36AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> 
> > diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
> > index ff27dad268c3..c578c3aec0e0 100644
> > --- a/net/netfilter/nf_flow_table.c
> > +++ b/net/netfilter/nf_flow_table.c
> > @@ -212,6 +212,21 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
> >  }
> >  EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
> >  
> > +static void flow_offload_hw_del(struct flow_offload *flow)
> > +{
> > +	struct net_device *indev;
> > +	int ret, ifindex;
> > +
> > +	rtnl_lock();
> > +	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
> > +	indev = __dev_get_by_index(&init_net, ifindex);
> 
> I think this should pass struct net * as arg to flow_offload_hw_del.
>
> > +	if (WARN_ON(!indev))
> > +		return;
> > +
> > +	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_DEL, flow);
> > +	rtnl_unlock();
> > +}
> 
> Please no rtnl lock unless absolutely needed.
> Seems this could even avoid the mutex completely by using
> dev_get_by_index + dev_put.

OK, we still need to make sure that we additions and deletions from
hardware don't occur concurrently, but that we can probably do it with
another mutex.

> > +static int do_flow_offload(struct flow_offload *flow)
> > +{
> > +	struct net_device *indev;
> > +	int ret, ifindex;
> > +
> > +	rtnl_lock();
> > +	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
> > +	indev = __dev_get_by_index(&init_net, ifindex);
> 
> likewise.
> 
> > +#define FLOW_HW_WORK_TIMEOUT	msecs_to_jiffies(100)
> > +
> > +static struct delayed_work nft_flow_offload_dwork;
> 
> I would go with struct work and no delay at all.

Will have a look into this, thanks!
