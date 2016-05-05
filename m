From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -nf v7] netfilter: nftables: add connlabel set support
Date: Thu, 5 May 2016 15:51:22 +0200
Message-ID: <20160505135122.GA12977@breakpoint.cc>
References: <1461664793-22342-1-git-send-email-fw@strlen.de>
 <20160505115432.GA10879@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54662 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbcEENv0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 09:51:26 -0400
Content-Disposition: inline
In-Reply-To: <20160505115432.GA10879@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Apr 26, 2016 at 11:59:53AM +0200, Florian Westphal wrote:
> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index 25998fa..4ef41a8 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -198,9 +198,22 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
> >  		}
> >  		break;
> >  #endif
> > +#ifdef CONFIG_NF_CONNTRACK_LABELS
> > +	case NFT_CT_LABELS:
> > +		if (nf_connlabels_replace(ct,
> > +					  &regs->data[priv->sreg],
> > +					  &regs->data[priv->sreg],
> > +					  NF_CT_LABELS_MAX_SIZE / sizeof(u32)))
> > +			goto err;
> > +		break;
> > +#endif
> >  	default:
> >  		break;
> >  	}
> > +
> > +	return;
> > +err:
> > +	regs->verdict.code = NFT_BREAK;
> 
> This will trigger a warning when CONFIG_NF_CONNTRACK_LABELS is
> disabled (the err: label will be unused).
> 
> I have fixed this here with:

Thanks, fix looks good!

> But still I'm unsure we should stop evaluating the rule. How can we
> reach this error situation?

It happens when you hit a conntrack that doesn't have the connlabel
extension attached because it predates the nft label set rule.

I don't mind changing this to not break and continue with evaluation
(i followed what xt_connlabel does but we don't need to follow that
 example).
