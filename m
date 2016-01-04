From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/5] ct: add support for directional keys
Date: Mon, 4 Jan 2016 21:06:48 +0100
Message-ID: <20160104200648.GB1731@breakpoint.cc>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
 <1450472883-19743-2-git-send-email-fw@strlen.de>
 <20151229234941.GB1386@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37046 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbcADUGu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 15:06:50 -0500
Content-Disposition: inline
In-Reply-To: <20151229234941.GB1386@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Dec 18, 2015 at 10:07:59PM +0100, Florian Westphal wrote:
> > A few keys in the ct expression are directional, i.e.
> > we need to tell kernel if it should fetch REPLY or ORIGINAL direction.
> > 
> > Split ct_keys into ct_keys & ct_keys_dir, the latter are those keys
> > that the kernel rejects unless also given a direction.
> > 
> > During postprocessing we also need to invoke ct_expr_update_type,
> > problem is that e.g. ct saddr can be any family (ip, ipv6) so we need
> > to update the expected data type based on the network base.
> 
> I think this is the way to go. My original proposal will not allow
> things like:
> 
>         ct direction reply ct daddr original 2.2.2.2
> 
> which seems to me like a valid matching, specifically when NAT comes
> into place (where original and reply tuples are not the same). This is
> kind of corner case, but I think we shouldn't reduce the expressiveness.

Great, so this seems ready so I pushed the series to nft master.

> > diff --git a/include/expression.h b/include/expression.h
> > --- a/include/expression.h
> > +++ b/include/expression.h
> > @@ -273,6 +273,7 @@ struct expr {
> >  		struct {
> >  			/* EXPR_CT */
> >  			enum nft_ct_keys	key;
> > +			struct expr		*dir_expr;
> 
> I think you can store the direction as a value.

Ok, changed to int8_t ..

> > +		expr_free(ct->ct.dir_expr);
> > +		ct->ct.dir_expr = direction;
> > +	}
> 
> I'd suggest you parse the direction from the parser, I don't find any

... and added a helper to do just that.

There were no other changes.

If you get
ip/ct.t: WARNING: line: 16: 'src/nft add rule --debug=netlink ip test-ip4 output ct l3proto original ipv4': 'ct l3proto original ipv4' mismatches 'ct l3proto ipv4'

that means kernel lacks d5f79b6e4d1 ('netfilter: nft_ct: include direction when dumping NFT_CT_L3PROTOCOL key').
