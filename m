From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC v4] netfilter: nf_flow_table: add hardware
 offload support
Date: Thu, 25 Jan 2018 12:28:58 +0100
Message-ID: <20180125112858.s27mtfv3cikqfiny@salvia>
References: <20180125000941.2763-1-pablo@netfilter.org>
 <20180124173136.5ec57ba7@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, ronye@mellanox.com,
        simon.horman@netronome.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, fw@strlen.de
To: Jakub Kicinski <kubakici@wp.pl>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180124173136.5ec57ba7@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 24, 2018 at 05:31:36PM -0800, Jakub Kicinski wrote:
> On Thu, 25 Jan 2018 01:09:41 +0100, Pablo Neira Ayuso wrote:
> > This patch adds the infrastructure to offload flows to hardware, in case
> > the nic/switch comes with built-in flow tables capabilities.
> > 
> > If the hardware comes with no hardware flow tables or they have
> > limitations in terms of features, the existing infrastructure falls back
> > to the software flow table implementation.
> > 
> > The software flow table garbage collector skips entries that resides in
> > the hardware, so the hardware will be responsible for releasing this
> > flow table entry too via flow_offload_dead().
> > 
> > Hardware configuration, either to add or to delete entries, is done from
> > the hardware offload workqueue, to ensure this is done from user context
> > given that we may sleep when grabbing the mdio mutex.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> I wonder how do you deal with device/table removal?  I know regrettably
> little about internals of nftables.  I assume the table cannot be
> removed/module unloaded as long as there are flow entries? And on
> device removal all flows pertaining to the removed ifindex will be
> automatically flushed?

Yes, this code is part of the generic software infrastructure, it's
not specific to the hardware offload, it's already upstream, see
net/netfilter/nft_flow_offload.c, see flow_offload_netdev_notifier.

> Still there could be outstanding work items targeting the device, so
> this WARN_ON:
> 
> +	indev = dev_get_by_index(net, ifindex);
> +	if (WARN_ON(!indev))
> +		return 0;
> 
> looks possible to trigger.

It should not, that's why there's a WARN_ON there ;-).

See nf_flow_table_hw_module_exit(), there's a call to
cancel_work_sync() to stop the hw offload workqueue, then flushes it.
After this, there's a flow table cleanup. So noone should be calling
that function by then.

> On the general architecture - I think it's worth documenting somewhere
> clearly that unlike TC offloads and most NDOs add/del of NFT flows are
> not protected by rtnl_lock.

Someone could probably look at getting rid of the rtnl_lock() all over
the place for hardware offloads, holding on the entire rtnetlink
subsystem just because some piece of hardware is taking time to
configure things is not good. Not explicitly related to this, but have
a look at Florian Westphal's talk on rtnl_lock during NetDev.

> > v4: More work in progress
> > - Decouple nf_flow_table_hw from nft_flow_offload via rcu hooks
> > - Consolidate ->ndo invocations, now they happen from the hw worker.
> > - Fix bug in list handling, use list_replace_init()
> > - cleanup entries on nf_flow_table_hw module removal
> > - add NFT_FLOWTABLE_F_HW flag to flowtables to explicit signal that user wants
> >   to offload entries to hardware.
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index ed0799a12bf2..be0c12acc3f0 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -859,6 +859,13 @@ struct dev_ifalias {
> >  	char ifalias[];
> >  };
> >  
> > +struct flow_offload;
> > +
> > +enum flow_offload_type {
> > +	FLOW_OFFLOAD_ADD	= 0,
> > +	FLOW_OFFLOAD_DEL,
> > +};
> > +
> >  /*
> >   * This structure defines the management hooks for network devices.
> >   * The following hooks can be defined; unless noted otherwise, they are
> > @@ -1316,6 +1323,8 @@ struct net_device_ops {
> >  	int			(*ndo_bridge_dellink)(struct net_device *dev,
> >  						      struct nlmsghdr *nlh,
> >  						      u16 flags);
> > +	int			(*ndo_flow_offload)(enum flow_offload_type type,
> > +						    struct flow_offload *flow);
> 
> nit: should there be kdoc for the new NDO?  ndo kdoc comment doesn't
>      look like it would be recognized by tools anyway though..

Yes, I can add this in the next iteration, no problem.

> nit: using "flow" as the name rings slightly grandiose to me :)  
>      I would appreciate a nf_ prefix for clarity.  Drivers will have 
>      to juggle a number of "flow" things, it would make the code easier
>      to follow if names were prefixed clearly, I feel.

This infrastructure could be used from tc too. My take on this is that
we should look at generalizing ndo's so they can be used from every
subsystem, so you just pick your own poison when doing packet
classification.

With some intermediate representation that suits well for everyone, we
would save quite a bit of redundant code in the drivers, so all
frontend interfaces that are basically part of the "same world" could
call the same ndo. We just need some glue code/abstraction in between
drivers and frontends [1].

The other direction, that IMO I would prefer to skip, is to have one
ndo for each frontend packet classification subsystem.

[1] https://lwn.net/Articles/677965/
