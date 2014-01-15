From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] evaluate: allow to use string with binary operations
Date: Wed, 15 Jan 2014 10:29:43 +0100
Message-ID: <20140115092943.GA4566@localhost>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-3-git-send-email-pablo@netfilter.org>
 <20140114122251.GB27277@macbook.localnet>
 <20140114152532.GA9059@localhost>
 <20140114154859.GB2204@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaAOJ3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:29:50 -0500
Content-Disposition: inline
In-Reply-To: <20140114154859.GB2204@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 03:49:00PM +0000, Patrick McHardy wrote:
> On Tue, Jan 14, 2014 at 04:25:32PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 14, 2014 at 12:22:52PM +0000, Patrick McHardy wrote:
> > > On Tue, Jan 14, 2014 at 12:30:29PM +0100, Pablo Neira Ayuso wrote:
> > > > This allows us to match ifname masks, eg.
> > > > 
> > > > nft add rule filter output meta oifname and eth == eth counter
> > > > 
> > > > I've been investigating other possibility, such as adding
> > > > ofiname-mask, which requires several patches and transformations
> > > > to make it look binop tree, but I still think this looks like
> > > > a natural way (and simple, look at the patch, it's rather small)
> > > > to represent this in the nftables.
> > > 
> > > I was just going to suggest adding a shortcut for this since its exposing
> > > a lot of low-level detail. The transformation should be quite easy during
> > > evaluation, could you elaborate on the problems?
> > 
> > Not really a problem but a bit more specific code to handle this case.
> > I started writing support for this following several approaches, but
> > after looking at my patchset I thought this approach was smaller and
> > it's requiring way less specific code.
> > 
> > The fist of my patches here (the ones that I didn't send) replace all
> > NFT_META_* references in the parser by internal META_*, eg. META_MARK,
> > just to prepare the addition of META_IIFNAMEMASK and META_OIFNAMEMASK.
> > Then, the follow-up patch transforms the following expression that we
> > got from that looks like:
> > 
> >               relational
> >                 /     \
> >                /       \
> >     meta oifnamemask  string
> > 
> > to a binary op expression. These also needs some specific code in the
> > delinearize path to transform the binop tree back to the expression
> > above.
> > 
> > Let me know if you have any better idea. Thanks.
> 
> Well, I think the easiest approach would be to add some code to
> expr_evaluate_relational() for OP_EQ for convert the LHS of a
> relational meta expression to LHS & RHS:
> 
>      relational (==)
>     /               \
> meta oifname       string
> 
> =>
> 
>         relational (==)
>        /               \
>     binop (&)        string
>   /          \
> meta oifname  string
> 
> The attached patch uses '*' as a trigger (and obviously won't work
> because the '*' is also used in the mask, but you get the idea.
> netlink_delinarize adjustments are missing, but it should be pretty
> trivial to add the corresponding code to postprocessing of relational
> expressions.

Oh yes, with that wildcard trick the thing is simplified. There was
some discuss on the use of '+' that seems to be possible to be used in
a device name. I guess '*' is safe as udev is using it in their rules.
