From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 13:27:05 +0000
Message-ID: <20150302132657.GR6142@acer.localdomain>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131940.GA7418@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33686 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbCBN12 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 08:27:28 -0500
Content-Disposition: inline
In-Reply-To: <20150302131940.GA7418@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.03, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 2) TCPMSS. Relax the checking when used from nft_compat and make sure
> >    that we skip !syn packets in case userspace provides a wrong
> >    configuration.
> > diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> > index e762de5..3b9761f 100644
> > --- a/net/netfilter/xt_TCPMSS.c
> > +++ b/net/netfilter/xt_TCPMSS.c
> > @@ -97,6 +97,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
> >  	if (!skb_make_writable(skb, skb->len))
> >  		return -1;
> >  
> > +	if (unlikely(!tcph->syn))
> > +		return 0;
> > +
> >  	len = skb->len - tcphoff;
> 
> Applying this to my copy of nf-next would insert this test before
> tcph is set up.

I actually don't think the test is necessary at all. Since we
don't check the protocol with nft, any packet with that bit set
will pass. It will most likely fail or corrupt the packet, but
why should we care? It won't crash and with nft its the
responsibility of userspace to take care of using the extension
correctly.
