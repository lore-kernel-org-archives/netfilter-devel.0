From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 10:58:16 +0000
Message-ID: <20151124105816.GL2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124104834.GF1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44815 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbbKXK6U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:58:20 -0500
Content-Disposition: inline
In-Reply-To: <20151124104834.GF1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > +static void trace_print_if(const struct nftnl_trace *nlt, uint16_t attr, const char *str)
> > > +{
> > > +	char __name[IFNAMSIZ];
> > > +	const char *ifname;
> > > +
> > > +        if (!nftnl_trace_is_set(nlt, attr))
> > > +		return;
> > > +
> > > +	ifname = nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name);
> > > +	if (ifname)
> > > +		printf(" %s %s", str, ifname);
> > > +	else
> > > +		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
> > > +}
> > 
> > A lot of the other trace attributes are not used so far. I'm wondering if
> > you intend to add special print functions for them as well.
> 
> All of the trace attributes are used, most of the use is limited to
> libnftnl though.
> 
> Wrt. to iif/oif, I do the printing for it in nftables to take advantage
> of the iif/oif idx<->name cache.
> 
> I would have preferred to just stick it into libnftnl like most of the
> other rest BUT then you either have the additional name translation overhead
> or just the index number...

I see. In that case this seems fine, no need to make it more complicated just
for this single attribute.

> > An alternative would be to use our internal datatypes, IOW parse the
> > attributes, associate the values with an internal type and use the regular
> > printing functions. The benefit would be fully consistent output, also
> > with respect to output options like numerical output.
> 
> Yes, right now virtually all of the printing is in libnftnl
> (called from nftables via nftnl_trace_fprintf() ).

The downside is that we're stuck to fprintf. I'm working on moving nft to
printing to buffers for pretty printing, intending set contents, sorting
flow tables in different dimensions etc. If we have external printing we'll
be missing some flexibilty in handling it, also regarding logging to other
outputs than stdout.

> > > +			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
> > > +				continue;
> > > +
> > > +			/* When tracing we'd like to translate the rule handle
> > > +			 * we receive in the trace messages to the actual rule
> > > +			 * struct to print that out.  Populate rule cache now.
> > > +			 */
> > 
> > Tracing might be a long running operation. The cache can go out of sync, might
> > be better to do a lookup on demand.
> 
> Hmm, okay.

We can certainly also update it when we receive notifications. Not sure what
we do about those currently.
