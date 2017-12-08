From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC,v2 4/6] netfilter: flow table support for IPv4
Date: Fri, 8 Dec 2017 22:14:28 +0100
Message-ID: <20171208211428.GB4126@salvia>
References: <20171207124501.24325-1-pablo@netfilter.org>
 <20171207124501.24325-5-pablo@netfilter.org>
 <20171208100413.GG24449@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, simon.horman@netronome.com,
        ronye@mellanox.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdLHVOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 16:14:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65E2E1C4386
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:14:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55273DA804
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:14:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208100413.GG24449@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 11:04:13AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch adds the IPv4 flow table type, that implements the datapath
> > flow table to forward IPv4 traffic. Rationale is:
> > 
> > 1) Look up for the packet in the flow table, from the ingress hook.
> > 2) If there's a hit, decrement ttl and pass it on to the neighbour layer
> >    for transmission.
> > 3) If there's a miss, packet is passed up to the classic forwarding
> >    path.
> 
> Is there a plan to also handle zone IDs in future?

Zone ID is meaningful to whoever applies the policy: in this offload
approach this patchset implements, the policy resides in the kernel.

> I't going to be messy for sure since we'd need to tell HW how to do
> the zone mapping.  Perhaps only support a builtin list, e.g.
> vlan id == zone...?

I've been considering a more simple solution, ie. add the input ifindex
device in the flowtable hash lookup, as part of the flow tuple. All
examples I've been observing for zones are basically mapping network
interfaces to zones.

> Don't yet see how it could be done in a generic way as the mappings can
> be arbitrarily complex.
> 
> Right now afaics one could install one flow table per zone and map
> this in nft, but then we still miss the part that tells the hardware
> how the zone identifier was derived.
> 
> > +static bool ip_has_options(unsigned int thoff)
> > +{
> > +	return thoff > sizeof(struct iphdr);
> 
> I'd use
> 	thoff != sizeof(...)
> 
> to catch case where ihl is < struct iphdr.

ok.

> > +nf_flow_offload_hook(void *priv, struct sk_buff *skb,
> > +		     const struct nf_hook_state *state)
> > +{
> > +	struct flow_offload_tuple_rhash *tuplehash;
> > +	struct nf_flowtable *flow_table = priv;
> > +	struct flow_offload_tuple tuple = {};
> > +	union nf_inet_addr nexthop;
> > +	struct flow_offload *flow;
> > +	struct net_device *outdev;
> > +	struct iphdr *iph;
> > +
> > +	if (nf_flow_tuple_ip(skb, &tuple) < 0)
> > +		return NF_ACCEPT;
> > +
> > +	tuplehash = flow_offload_lookup(flow_table, &tuple);
> > +	if (tuplehash == NULL)
> > +		return NF_ACCEPT;
> > +
> > +	outdev = dev_get_by_index_rcu(&init_net, tuplehash->tuple.oifidx);
> 
> state->net ?

Yes, netns support is in my TODO list.
