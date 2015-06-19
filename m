From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 3/3] rule: fix use of intervals in set declarations
Date: Fri, 19 Jun 2015 15:59:48 +0200
Message-ID: <20150619135948.GM22946@acer.localdomain>
References: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
 <1434719718-10371-3-git-send-email-pablo@netfilter.org>
 <20150619131336.GH22946@acer.localdomain>
 <20150619134816.GA19433@salvia>
 <20150619134444.GL22946@acer.localdomain>
 <20150619135958.GA19487@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, admin@rollinix.net,
	niels@kristensen.io, tom@compton.nu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56808 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbbFSN7w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20150619135958.GA19487@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2015 at 03:44:44PM +0200, Patrick McHardy wrote:
> > On 19.06, Pablo Neira Ayuso wrote:
> > > On Fri, Jun 19, 2015 at 03:13:36PM +0200, Patrick McHardy wrote:
> > > > >  static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
> > > > > -			   const struct expr *expr)
> > > > > +			   const struct location *loc, struct expr *expr)
> > > > >  {
> > > > > -	if (netlink_add_setelems(ctx, h, expr) < 0)
> > > > > +	struct set *set;
> > > > > +
> > > > > +	if (netlink_get_set(ctx, h, loc) < 0)
> > > > 
> > > > I think we should get it from the internal list and not from the
> > > > kernel.
> > > 
> > > There is no such internal list at this moment, we retrieve the list
> > > only for do_command_list(). Are you suggesting to add the code to
> > > retrieve it inconditionally initially?
> > 
> > We do have the table->sets list. Yeah, but we don't add it to that
> > list in the creation part, I see. Actually we should be doing that,
> > since otherwise we also won't support creating a set and adding
> > new elements in seperate commands but a single transaction.
> 
> Right.
> 
> > > > We can't add intervals to existing sets so far anyways, and this
> > > > would allow it, but it wouldn't work.
> > > 
> > > Not sure what you mean with this.
> > 
> > Intervals need to know the entire set content to be created correctly.
> > We don't handle incremental updates with intervals correctly ATM.
> 
> What's the problem?

Consider a set with an interval 0-10. We add an interval 9-11. This
effectively means 0-10 needs to be transformed to 0-8 and we don't
do that.

The root cause is that the kernel must not have overlapping intervals.
They need to be transformed before adding them. This is what segtree
does.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
