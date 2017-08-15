From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4] echo: Fix for added delays in rule updates
Date: Tue, 15 Aug 2017 13:49:17 +0200
Message-ID: <20170815114917.GB20284@salvia>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-4-phil@nwl.cc>
 <20170815103530.GA5889@salvia>
 <20170815112756.GY16375@orbyte.nwl.cc>
 <20170815113425.GZ16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56298 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdHOLtm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 07:49:42 -0400
Content-Disposition: inline
In-Reply-To: <20170815113425.GZ16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:34:25PM +0200, Phil Sutter wrote:
> On Tue, Aug 15, 2017 at 01:27:56PM +0200, Phil Sutter wrote:
> > On Tue, Aug 15, 2017 at 12:35:30PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Aug 15, 2017 at 01:43:04AM +0200, Phil Sutter wrote:
> > [...]
> > > > diff --git a/include/netlink.h b/include/netlink.h
> > > > index 3726171424c33..e7e4bbcfc0f51 100644
> > > > --- a/include/netlink.h
> > > > +++ b/include/netlink.h
> > > > @@ -119,10 +119,7 @@ extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
> > > >  extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
> > > >  				  const struct handle *h,
> > > >  				  const struct location *loc);
> > > > -extern int netlink_replace_rule_batch(struct netlink_ctx *ctx,
> > > > -				      const struct handle *h,
> > > > -				      const struct rule *rule,
> > > > -				      const struct location *loc);
> > > > +extern int netlink_replace_rule_batch(struct netlink_ctx *ctx, struct cmd *cmd);
> > > 
> > > This patch comes with an interesting cleanup, that is that you just
> > > pass struct cmd as function parameter.
> > > 
> > > Probably we can do this everywhere in the netlink.c code? I wonder if
> > > it's better just to fix this without changing the function footprint.
> > > Then, work a cleanup patch to update all netlink_* functions to pass
> > > struct cmd as parameter.
> > > 
> > > So we leave everything looking consistent.
> > 
> > This change was necessary in order to pass the required parameters to
> > cache_update(). Doing without, I would have to pass nf_sock, cache, obj
> > and msgs fields additionally, and the number of parameters was already
> > quite big.
> 
> ENOCOFFEE: Actually I only use obj field of struct cmd, and that should
> be optional since I can also just use CMD_INVALID instead - so I'll drop
> the signature changes in v2.

That's good, Eric won't do any voodoo toll with you then.
