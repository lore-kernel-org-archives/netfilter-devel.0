From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] nftables: ct: add byte/packet counter support
Date: Fri, 8 Jan 2016 13:43:49 +0100
Message-ID: <20160108124349.GB26058@breakpoint.cc>
References: <1452198864-10134-1-git-send-email-fw@strlen.de>
 <20160108123818.GB4816@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48531 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbcAHMnu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 07:43:50 -0500
Content-Disposition: inline
In-Reply-To: <20160108123818.GB4816@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 07, 2016 at 09:34:24PM +0100, Florian Westphal wrote:
> > @@ -366,6 +398,13 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
> >  		goto nla_put_failure;
> >  
> >  	switch (priv->key) {
> > +	case NFT_CT_BYTES:
> > +	case NFT_CT_PKTS:
> > +		if ((priv->dir == IP_CT_DIR_ORIGINAL ||
> > +		     priv->dir == IP_CT_DIR_REPLY) &&
> > +		     nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
> > +			goto nla_put_failure;
> > +		break;
> >  	case NFT_CT_PROTOCOL:
> 
> Any concern if I fold this change into your patch? It just simplifies
> this check, see below:
> 
>         switch (priv->key) {
>         case NFT_CT_BYTES:
>         case NFT_CT_PKTS:
> -               if ((priv->dir == IP_CT_DIR_ORIGINAL ||
> -                    priv->dir == IP_CT_DIR_REPLY) &&
> -                    nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
> +               if (priv->dir < IP_CT_DIR_MAX &&
> +                   nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
>                         goto nla_put_failure;

No, go ahead.
