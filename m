From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] nftables: ct: add byte/packet counter support
Date: Fri, 8 Jan 2016 02:37:08 +0100
Message-ID: <20160108013708.GH23789@breakpoint.cc>
References: <1452198864-10134-1-git-send-email-fw@strlen.de>
 <20160108013311.GG23789@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47237 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbcAHBhJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 20:37:09 -0500
Content-Disposition: inline
In-Reply-To: <20160108013311.GG23789@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > +	case NFT_CT_BYTES: /* fallthrough */
> > +	case NFT_CT_PKTS: {
> > +		const struct nf_conn_acct *acct = nf_conn_acct_find(ct);
> > +		u64 count = 0;
> > +
> > +		if (acct)
> > +			count = nft_ct_get_eval_counter(acct->counter,
> > +							priv->key, priv->dir);
> > +		memcpy(dest, &count, sizeof(count));
> 
> Seems this needs to be a put_unaligned().  V2 coming soon.

Ahem.  No.  This is fine.
Seems I need to rest, I'll send the nft_byteorder patch tomorrow.

Sorry.
