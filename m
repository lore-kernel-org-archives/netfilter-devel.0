From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_tables: extend payload to support
 writing data
Date: Mon, 17 Feb 2014 18:46:51 +0000
Message-ID: <20140217184651.GA11041@macbook.localnet>
References: <1392660737-10149-1-git-send-email-nikolay@redhat.com>
 <20140217183751.GB10701@macbook.localnet>
 <5302585A.9070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52134 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaBQSqz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:46:55 -0500
Content-Disposition: inline
In-Reply-To: <5302585A.9070309@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 07:43:38PM +0100, Nikolay Aleksandrov wrote:
> On 02/17/2014 07:37 PM, Patrick McHardy wrote:
> >>  
> >> -static void nft_payload_eval(const struct nft_expr *expr,
> >> -			     struct nft_data data[NFT_REG_MAX + 1],
> >> -			     const struct nft_pktinfo *pkt)
> >> +static int nft_payload_make_offset(const struct nft_pktinfo *pkt,
> >> +				   const struct nft_payload *payload)
> > 
> > We're using priv everywhere. Please keep this consistent. Also please
> > make sure (in the entire patch) that arguments are aligned with the
> > opening (.
> > 
> Okay, I'll use the priv.
> They're adjusted, apply the patch and see for yourself, or do you mean some
> other adjustment ?
> Both arguments are aligned from what I can see.

I see. Probably misrepresented by mutt.

> >> +static void nft_payload_set_eval(const struct nft_expr *expr,
> >> +				 struct nft_data data[NFT_REG_MAX + 1],
> >> +				 const struct nft_pktinfo *pkt)
> >> +{
> >> +	const struct nft_payload *priv = nft_expr_priv(expr);
> >> +	struct nft_data *source = &data[priv->sreg];
> >> +	int offset = nft_payload_make_offset(pkt, priv);
> >> +
> >> +	if (offset == -1)
> >> +		goto err;
> >> +	if (!skb_make_writable(pkt->skb, offset + priv->len))
> >> +		goto err;
> >> +	memcpy(pkt->skb->data + offset, source, priv->len);
> > 
> > We need to take care of checksumming. Shouldn't be too hard to get *most*
> > cases right using the existing checksum helpers.
> > 
> Yes, but would you like to do that in here or have a separate op which
> is configurable i.e. you can set what to calculate and where to put it,
> or would you prefer to make it automatic based on what we're changing here ?

Something here is a lot cheaper since we can use incremental checksumming.
That won't be possible somewhere else, additionally we'd have to check
the checksum before recalculating it to make sure we don't fix up bad
packets. So yes, I think it should be done here.
