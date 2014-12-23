From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] bridge: detect NAT66 correctly and change MAC address
Date: Tue, 23 Dec 2014 15:13:18 +0100
Message-ID: <20141223141318.GA17379@salvia>
References: <1417813945-5050-1-git-send-email-bernhard.thaler@wvnet.at>
 <20141223140343.GA17171@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sven@open-mesh.com
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41882 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbaLWOKo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:10:44 -0500
Content-Disposition: inline
In-Reply-To: <20141223140343.GA17171@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 23, 2014 at 03:03:43PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 05, 2014 at 10:12:25PM +0100, Bernhard Thaler wrote:
> > diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> > index c190d22..73ea96a 100644
> > --- a/net/bridge/br_netfilter.c
> > +++ b/net/bridge/br_netfilter.c
> [...]
> > +static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
> > +{
> > +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> > +	struct rtable *rt;
> > +	struct net_device *dev = skb->dev;
> > +
> > +	if (nf_bridge->mask & BRNF_PKT_TYPE) {
> > +		skb->pkt_type = PACKET_OTHERHOST;
> > +		nf_bridge->mask ^= BRNF_PKT_TYPE;
> > +	}
> > +	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
> 
> There is no fragmentation handling here. Actually, not your fault, the
> original br_nf_pre_routing_finish_ipv6() doesn't consider this case.
> 
> I can take this patch, it doesn't do any worse than the existing code,
> but probably you want to have a look at this.

A bit more info if you have a look at this: br_netfilter fragmentation
handling is poorly designed, basically it may modify original fragment
boundaries and a bridge shouldn't do that. But this is how this has
been working since long time ago.
