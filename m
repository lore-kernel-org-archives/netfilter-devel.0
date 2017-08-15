From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 3/4] echo: Fix for added delays in rule updates
Date: Tue, 15 Aug 2017 13:27:56 +0200
Message-ID: <20170815112756.GY16375@orbyte.nwl.cc>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-4-phil@nwl.cc>
 <20170815103530.GA5889@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57843 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdHOL16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 07:27:58 -0400
Content-Disposition: inline
In-Reply-To: <20170815103530.GA5889@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Aug 15, 2017 at 12:35:30PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 15, 2017 at 01:43:04AM +0200, Phil Sutter wrote:
[...]
> > diff --git a/include/netlink.h b/include/netlink.h
> > index 3726171424c33..e7e4bbcfc0f51 100644
> > --- a/include/netlink.h
> > +++ b/include/netlink.h
> > @@ -119,10 +119,7 @@ extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
> >  extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
> >  				  const struct handle *h,
> >  				  const struct location *loc);
> > -extern int netlink_replace_rule_batch(struct netlink_ctx *ctx,
> > -				      const struct handle *h,
> > -				      const struct rule *rule,
> > -				      const struct location *loc);
> > +extern int netlink_replace_rule_batch(struct netlink_ctx *ctx, struct cmd *cmd);
> 
> This patch comes with an interesting cleanup, that is that you just
> pass struct cmd as function parameter.
> 
> Probably we can do this everywhere in the netlink.c code? I wonder if
> it's better just to fix this without changing the function footprint.
> Then, work a cleanup patch to update all netlink_* functions to pass
> struct cmd as parameter.
> 
> So we leave everything looking consistent.

This change was necessary in order to pass the required parameters to
cache_update(). Doing without, I would have to pass nf_sock, cache, obj
and msgs fields additionally, and the number of parameters was already
quite big.

I would instead suggest to follow-up with a patch applying the change to
all other functions as well, though I'm not sure whether Eric might
make a voodoo doll which looks like me if I submit that now.

[...]
> > diff --git a/src/rule.c b/src/rule.c
> > index 1bd5c80158b7b..ab19525757fff 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c
> > @@ -1017,8 +1017,16 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
> >  {
> >  	uint32_t flags = excl ? NLM_F_EXCL : 0;
> >  
> > -	if (ctx->octx->echo)
> > +	if (ctx->octx->echo) {
> > +		int rc;
> 
> Another nitpick: We seem to use 'int ret' everywhere in the code. So
> probably for consistency, use this name here too.

You mean if 'int err' is not used? But OK, in src/rule.c we have at
least three cases of 'return ret' and only two of 'return rc' (from my
patch) so I'll change that.

Cheers, Phil
