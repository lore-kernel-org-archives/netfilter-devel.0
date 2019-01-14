From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] vrf: Fix conntrack-dnat conflict in vrf-device
 PREROUTING  hook
Date: Mon, 14 Jan 2019 23:15:10 +0100
Message-ID: <20190114221510.pvge3hmb3qyicry4@breakpoint.cc>
References: <1547251399-15997-1-git-send-email-wenxu@ucloud.cn>
 <20190114214043.pji6usreyngezczt@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenxu@ucloud.cn, netdev@vger.kernel.org, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114214043.pji6usreyngezczt@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jan 12, 2019 at 08:03:19AM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > In the ip_rcv the skb go through the PREROUTING hook first,
> > Then jump in vrf device go through the same hook again.
> > When conntrack dnat work with vrf, there will be some conflict for rules.
> > Because the package go through the hook twice with different nf status
> 
> Then, the first hook applies NAT, while the second is simply ignored.

Yes, but re-entry occurs with munged addresses in case DNAT was applied.
I'm not sure about this patch either though.

If vrf is used, then it seems its enough to add a 'meta iifname vr+ accept'
rule to prevent false matches/re-invocation.
If the name isn't enough, I think we should consider extending meta to
query 'interface is vrf' so userspace can add the 'don't re-do entire
ruleset for vrf' policy itself.

I am not sure kernel should auto-enforce bypass based on conntrack
state, there is no precedence for this and I don't like
arbitrarily-chosen behaviour.

In bridge case (ingress), the bridge path doesn't run the inet (ipv4/ipv6)
hooks, so we don't have a double-invocation if packet gets pushed up the
stack.  Same for bond/team.

> > +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> > +	enum ip_conntrack_info ctinfo;
> > +	struct nf_conn *ct;
> > +
> > +	ct = nf_ct_get(skb, &ctinfo);
> > +	if (ct && (ct->status & IPS_DST_NAT))
> > +		return skb;
> > +#endif
> 
> I think we need to scrub the packet here, from the beginning of the
> vrf path. The vrf represents a new virtual space, not sure we should
> be sharing connection tracking information between different vrf.

Hmm.  I see nf_reset calls, but apparently only on output.

If we would scrub (but no packet rewrite occured) we would re-lookup the
exactly same conntrack entry we just discarded, so I don't see the
point (we would also double-account each packet with nf_acct=1).

If re-write occured, I think we would mess up conntrack table:

1. Wire format: saddr A to daddr B.
2. NAT is applied, daddr B gets rewritten to daddr C (DNAT took place).
Then conntrack has: ORIGIN A,B; REPLY C,A            (expects replies to
come from the new destination to original source and further packets from
A to B).

If we re-enter conntrack, then packet (still the original packet!) is
'saddr A to daddr c'.

So, unless I've made a thinko here, conntrack picks up a new flow:
ORIGIN A,C ;  REPLY C,A .

Unlike netns, where the 'old' conntrack incarnation is invisible (netns
is part of the conntrack key), there will now be a clash/collision at
confirm time, because there already is a 'REPLY C,A' in the table.
