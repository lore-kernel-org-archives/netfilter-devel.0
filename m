From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 14:58:23 +0100
Message-ID: <20150302135823.GB21965@salvia>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131940.GA7418@breakpoint.cc>
 <20150302132657.GR6142@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46451 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbbCBNyr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 08:54:47 -0500
Content-Disposition: inline
In-Reply-To: <20150302132657.GR6142@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 01:27:05PM +0000, Patrick McHardy wrote:
> On 02.03, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > 2) TCPMSS. Relax the checking when used from nft_compat and make sure
> > >    that we skip !syn packets in case userspace provides a wrong
> > >    configuration.
> > > diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> > > index e762de5..3b9761f 100644
> > > --- a/net/netfilter/xt_TCPMSS.c
> > > +++ b/net/netfilter/xt_TCPMSS.c
> > > @@ -97,6 +97,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
> > >  	if (!skb_make_writable(skb, skb->len))
> > >  		return -1;
> > >  
> > > +	if (unlikely(!tcph->syn))
> > > +		return 0;
> > > +
> > >  	len = skb->len - tcphoff;
> > 
> > Applying this to my copy of nf-next would insert this test before
> > tcph is set up.
> 
> I actually don't think the test is necessary at all. Since we
> don't check the protocol with nft, any packet with that bit set
> will pass. It will most likely fail or corrupt the packet, but
> why should we care? It won't crash and with nft its the
> responsibility of userspace to take care of using the extension
> correctly.

According to what I can read from the code, it will corrupt the
packet since we will get a MSS option in non-syn TCP packet.

I thought we could crash, but looking at it again you seem to be
right, I'm going to undo this change and send a v2.
