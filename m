From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 14:50:15 +0100
Message-ID: <20150302135015.GA21965@salvia>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131940.GA7418@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44199 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbbCBNql (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 08:46:41 -0500
Content-Disposition: inline
In-Reply-To: <20150302131940.GA7418@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 02:19:40PM +0100, Florian Westphal wrote:
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

Thanks, will fix this up.
