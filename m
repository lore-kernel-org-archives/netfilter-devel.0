From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v3 3/4] Implement --echo option
Date: Wed, 2 Aug 2017 15:45:56 +0200
Message-ID: <20170802134556.GH16375@orbyte.nwl.cc>
References: <20170728115548.5171-1-phil@nwl.cc>
 <20170728115548.5171-4-phil@nwl.cc>
 <20170802123744.GC16003@salvia>
 <20170802131804.GA15462@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45901 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbdHBNp5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 09:45:57 -0400
Content-Disposition: inline
In-Reply-To: <20170802131804.GA15462@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 02, 2017 at 03:18:04PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 02, 2017 at 02:37:44PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 28, 2017 at 01:55:47PM +0200, Phil Sutter wrote:
> > [...]
> > > diff --git a/src/netlink.c b/src/netlink.c
> > > index f13dfd3f9a021..35b52a3344f87 100644
> > > --- a/src/netlink.c
> > > +++ b/src/netlink.c
> > > @@ -465,11 +465,11 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
> > >  			       const struct location *loc)
> > >  {
> > >  	struct nftnl_rule *nlr;
> > > -	int err;
> > > +	int err, flags = ctx->octx->echo ? NLM_F_ECHO : 0;
> > >  
> > >  	nlr = alloc_nftnl_rule(&rule->handle);
> > >  	netlink_linearize_rule(ctx, nlr, rule);
> > > -	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, 0, ctx->seqnum);
> > > +	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, flags, ctx->seqnum);
> > >  	nftnl_rule_free(nlr);
> > >  
> > >  	if (err < 0)
> > > @@ -2087,6 +2087,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
> > >  				printf("update table ");
> > >  			else
> > >  				printf("add table ");
> > > +		} else if (type == -1) {
> > > +			printf("table ");
> > 
> > Why do we need this '-1' case? Same question for other objects.
> 
> This is there just to skip the "add ..." part of the string, right?
> 
> I think this is relevant information. Semantically, this is just
> exposing the netlink NLM_F_ECHO flag, so it should be possible to use
> this flag in the future with 'delete' commands.
> 
> So if this -1 type is there just to skip the "add ...", I would simply
> remove it.

Yes, exactly. This is what I had in mind when I started with this
series, back when it was merely about atomic handle retrieval by
supporting '-a' flag in add/insert/replace commands for rules. Changing
the whole concept into this generic --echo option was your idea. :)

But OK, since most of the original idea is lost now anyway, I can get
rid of this last bit as well.

Cheers, Phil
