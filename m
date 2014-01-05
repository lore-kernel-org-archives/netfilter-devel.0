From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix suboptimal set selection
Date: Sun, 5 Jan 2014 21:45:31 +0000
Message-ID: <20140105214531.GA18624@macbook.localnet>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-2-git-send-email-pablo@netfilter.org>
 <20140105212406.GA13624@macbook.localnet>
 <20140105213403.GA4158@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaAEVpu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:45:50 -0500
Content-Disposition: inline
In-Reply-To: <20140105213403.GA4158@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 10:34:03PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 05, 2014 at 09:28:35PM +0000, Patrick McHardy wrote:
> > On Sun, Jan 05, 2014 at 10:18:46PM +0100, Pablo Neira Ayuso wrote:
> > > The rb-tree is currently used for simple sets and maps with no
> > > intervals which is suboptimal. Fix it by adding the weight field
> > > to each existing set implementation, this value allows to select
> > > the best candidate in case that several set types can be used.
> > 
> > Ohh, lets do this properly. This is one point why I was opposed to a
> > merge at this stage, lets not paper over this but fix this how it
> > was intended. I'll work on that after finishing the inet family.
> > Until then no harm is done, just some memory waste.
> 
> Please, elaborate your plans on this.

Well, the selection should happen based on the set contents, not on
some static weight. Basically we have memory usage and performance
as measurable weights, and both depend on the contents of the set,
so we need an abstrace description of those.

I have another set type coming up, static weights will not help to
make a good decision long term. This won't be easy to get right,
but I really don't want to paper over this since this just allows
to delay to proper fix that will be needed at some point anyway.
