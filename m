From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix suboptimal set selection
Date: Sun, 5 Jan 2014 22:21:48 +0000
Message-ID: <20140105222148.GA19052@macbook.localnet>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-2-git-send-email-pablo@netfilter.org>
 <20140105212406.GA13624@macbook.localnet>
 <20140105213403.GA4158@localhost>
 <20140105214531.GA18624@macbook.localnet>
 <20140105221105.GA4387@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47856 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaAEWVw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:21:52 -0500
Content-Disposition: inline
In-Reply-To: <20140105221105.GA4387@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 11:11:05PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 05, 2014 at 09:45:31PM +0000, Patrick McHardy wrote:
> > On Sun, Jan 05, 2014 at 10:34:03PM +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Jan 05, 2014 at 09:28:35PM +0000, Patrick McHardy wrote:
> > > > On Sun, Jan 05, 2014 at 10:18:46PM +0100, Pablo Neira Ayuso wrote:
> > > > > The rb-tree is currently used for simple sets and maps with no
> > > > > intervals which is suboptimal. Fix it by adding the weight field
> > > > > to each existing set implementation, this value allows to select
> > > > > the best candidate in case that several set types can be used.
> > > > 
> > > > Ohh, lets do this properly. This is one point why I was opposed to a
> > > > merge at this stage, lets not paper over this but fix this how it
> > > > was intended. I'll work on that after finishing the inet family.
> > > > Until then no harm is done, just some memory waste.
> > > 
> > > Please, elaborate your plans on this.
> > 
> > Well, the selection should happen based on the set contents, not on
> > some static weight. Basically we have memory usage and performance
> > as measurable weights, and both depend on the contents of the set,
> > so we need an abstrace description of those.
> 
> I agree on that the more information we provide to the kernel, the
> best decision regarding the set type and its configuration will be
> made.
> 
> This simple weight thing that this patch adds is just a way to
> break a tie in case two sets provides the features that are needed
> (this is the only description information that we have at this moment
> from userspace). I think for simple sets (with no intervals) hash
> should be prefered to rb-trees.

Indeed, but not based on the fact that its a hash, but based on
performance and memory usage.

> But if bitmap sets come into place, the selection between hash and
> bitmaps cannot be done by this weight this patch adds, as we need more
> information on the set elements to make the right choice. That I can
> think, we need the distance between the two elements that are further
> from each other to calculate the memory consumption at least.

Correct. I would really prefer to keep the waste to keep the incentive
to fix this properly up. Its definitely doable, lets keep the pain
up to fix this properly, nobody is using this in production anyway.
