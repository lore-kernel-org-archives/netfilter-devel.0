From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:48:34 +0100
Message-ID: <20151124104834.GF1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58521 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbbKXKsg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:48:36 -0500
Content-Disposition: inline
In-Reply-To: <20151124102553.GE2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > +static void trace_print_if(const struct nftnl_trace *nlt, uint16_t attr, const char *str)
> > +{
> > +	char __name[IFNAMSIZ];
> > +	const char *ifname;
> > +
> > +        if (!nftnl_trace_is_set(nlt, attr))
> > +		return;
> > +
> > +	ifname = nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name);
> > +	if (ifname)
> > +		printf(" %s %s", str, ifname);
> > +	else
> > +		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
> > +}
> 
> A lot of the other trace attributes are not used so far. I'm wondering if
> you intend to add special print functions for them as well.

All of the trace attributes are used, most of the use is limited to
libnftnl though.

Wrt. to iif/oif, I do the printing for it in nftables to take advantage
of the iif/oif idx<->name cache.

I would have preferred to just stick it into libnftnl like most of the
other rest BUT then you either have the additional name translation overhead
or just the index number...

> An alternative would be to use our internal datatypes, IOW parse the
> attributes, associate the values with an internal type and use the regular
> printing functions. The benefit would be fully consistent output, also
> with respect to output options like numerical output.

Yes, right now virtually all of the printing is in libnftnl
(called from nftables via nftnl_trace_fprintf() ).

> > +static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
> > +{
> > +	struct table *t;
> > +	struct set *s;
> > +	struct netlink_mon_handler monhandler;
> > +
> > +	monhandler.cache_needed = need_cache(cmd);
> >  	if (monhandler.cache_needed) {
> > +		struct rule *rule, *nrule;
> > +		struct chain *chain;
> > +		int ret;
> > +
> >  		list_for_each_entry(t, &table_list, list) {
> >  			list_for_each_entry(s, &t->sets, list)
> >  				s->init = set_expr_alloc(&cmd->location);
> > +
> > +			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
> > +				continue;
> > +
> > +			/* When tracing we'd like to translate the rule handle
> > +			 * we receive in the trace messages to the actual rule
> > +			 * struct to print that out.  Populate rule cache now.
> > +			 */
> 
> Tracing might be a long running operation. The cache can go out of sync, might
> be better to do a lookup on demand.

Hmm, okay.
