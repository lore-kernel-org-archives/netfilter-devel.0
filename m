From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 nf-next] netfilter: meta: add support for setting
 skb->pkttype
Date: Mon, 14 Dec 2015 18:26:42 +0100
Message-ID: <20151214172642.GA1365@salvia>
References: <1449767047-15389-1-git-send-email-fw@strlen.de>
 <20151214114525.GA3469@salvia>
 <20151214133846.GF12854@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbbLNR0q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 12:26:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 82857B6BA3
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:26:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6BB29DA80B
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:26:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82272DA804
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:26:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151214133846.GF12854@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 14, 2015 at 02:38:46PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Cc'ing Patrick, I would like to hear him, this is bringing up again
> > the datatype issue that we discussed before.
> > 
> > On Thu, Dec 10, 2015 at 06:04:07PM +0100, Florian Westphal wrote:
> > > This allows to redirect bridged packets to local machine:
> > > 
> > > ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast
> > > Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.
> > > 
> > > It is also useful to add support for a '-m cluster like' nft rule
> > > (where switch floods packets to several nodes, and each cluster node
> > >  node processes a subset of packets for load distribution).
> > > 
> > > Mangling is restricted to HOST/OTHER/BROAD/MULTICAST, i.e. you cannot set
> > > skb->pkt_type to PACKET_KERNEL or change PACKET_LOOPBACK to PACKET_HOST.
> > > @@ -190,6 +192,13 @@ err:
> > >  }
> > >  EXPORT_SYMBOL_GPL(nft_meta_get_eval);
> > >  
> > > +/* don't change or set _LOOPBACK, _USER, etc. */
> > > +static bool pkt_type_ok(u32 p)
> > > +{
> > > +	return p == PACKET_HOST || p == PACKET_BROADCAST ||
> > > +	       p == PACKET_MULTICAST || p == PACKET_OTHERHOST;
> > > +}
> > 
> > I think we should make use of the datatypes in the kernel side, ie.
> > add NFT_DATA_PKTTYPE. Currently we are using the raw NFT_DATA_VALUE
> > which doesn't semantically tell us anything on the kind of data.
> 
> Yes, but otherwise you can't parameterize the set operations anymore.

We can still via nft_data_init(), we would need a nft_pkttype_init()
there (or some generic infrastructure to register datatypes from each
extensions). So as long as you indicate NFT_DATA_PKTTYPE, the data
will be validated. That will catch both store of pkttype into register
both from immediate and sets.

> Its probably not a big deal for pkt_type but it would be f.e. for mark,
> we dfinitely want to take that from a sreg.
>
> > The datatype will allow to perform validation from the configuration
> > plane on correct value that we support, otherwise return -EOPNOTSUPP.
> > This approach above seems a bit sloppy to me as the validation happens
> > from the packet path.
> 
> Yes, but again ...  I think it would be okay for pkt_type to force
> specification of the target value at config stage, but it would mean
> that meta set works differently depending on the key (somethis input
> is sreg, sometimes a specified attribute value).

Not talking here about passing the data via sreg (through immediate
expression) or as a netlink attribute. Although that is another
interesting topic.

Last time I met Patrick a bit more that one month ago, he mentioned it
would be good to evaluate this from performance point of view as we
would skip the handling of the immediate expression.

We may keep going with the existing approach, ie. just raw data with
no semantics, then if we decide to go this path, to retain backward
compatibility, we would need to pass two data attributes through
netlink: one with the raw data and another with the specific datatype
so older kernels keep handling what userspace generates.

Let me see if I can reach Patrick to discuss this.
