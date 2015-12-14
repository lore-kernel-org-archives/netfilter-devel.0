From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 nf-next] netfilter: meta: add support for setting
 skb->pkttype
Date: Mon, 14 Dec 2015 14:38:46 +0100
Message-ID: <20151214133846.GF12854@breakpoint.cc>
References: <1449767047-15389-1-git-send-email-fw@strlen.de>
 <20151214114525.GA3469@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55589 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932348AbbLNNis (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 08:38:48 -0500
Content-Disposition: inline
In-Reply-To: <20151214114525.GA3469@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Cc'ing Patrick, I would like to hear him, this is bringing up again
> the datatype issue that we discussed before.
> 
> On Thu, Dec 10, 2015 at 06:04:07PM +0100, Florian Westphal wrote:
> > This allows to redirect bridged packets to local machine:
> > 
> > ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast
> > Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.
> > 
> > It is also useful to add support for a '-m cluster like' nft rule
> > (where switch floods packets to several nodes, and each cluster node
> >  node processes a subset of packets for load distribution).
> > 
> > Mangling is restricted to HOST/OTHER/BROAD/MULTICAST, i.e. you cannot set
> > skb->pkt_type to PACKET_KERNEL or change PACKET_LOOPBACK to PACKET_HOST.
> > @@ -190,6 +192,13 @@ err:
> >  }
> >  EXPORT_SYMBOL_GPL(nft_meta_get_eval);
> >  
> > +/* don't change or set _LOOPBACK, _USER, etc. */
> > +static bool pkt_type_ok(u32 p)
> > +{
> > +	return p == PACKET_HOST || p == PACKET_BROADCAST ||
> > +	       p == PACKET_MULTICAST || p == PACKET_OTHERHOST;
> > +}
> 
> I think we should make use of the datatypes in the kernel side, ie.
> add NFT_DATA_PKTTYPE. Currently we are using the raw NFT_DATA_VALUE
> which doesn't semantically tell us anything on the kind of data.

Yes, but otherwise you can't parameterize the set operations anymore.

Its probably not a big deal for pkt_type but it would be f.e. for mark,
we dfinitely want to take that from a sreg.

> The datatype will allow to perform validation from the configuration
> plane on correct value that we support, otherwise return -EOPNOTSUPP.
> This approach above seems a bit sloppy to me as the validation happens
> from the packet path.

Yes, but again ...  I think it would be okay for pkt_type to force
specification of the target value at config stage, but it would mean
that meta set works differently depending on the key (somethis input
is sreg, sometimes a specified attribute value).

Patrick, Pablo, please battle th^W^W discuss this and let me know the
result.

I can redo this as suggested by Pablo but since its a bit more work
I'd only do this if its decided that its indeed the right path forward.
(I.e. meta set would work with an sreg or some pre-set attribute depending
 on the meta operation key).

Thanks!
