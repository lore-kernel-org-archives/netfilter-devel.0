From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 15:35:49 +0100
Message-ID: <20140826143549.GC23476@acer.localdomain>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia>
 <20140826121420.GA22955@acer.localdomain>
 <CAOkSjBhHGygRWjY04M-H3JUp8uy5DzOFB7oL219jsHrOQYUsxw@mail.gmail.com>
 <6dbe283a-500c-4897-9ece-68d940ef9ced@email.android.com>
 <20140826134706.GA5913@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaHZOfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:35:53 -0400
Content-Disposition: inline
In-Reply-To: <20140826134706.GA5913@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 03:47:06PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 26, 2014 at 02:30:30PM +0100, Patrick McHardy wrote:
> > >> - add a generation ID to the ruleset
> > >> - dump the entire ruleset
> > >> - generate delete commands for each existing rule/chain/set...
> > >> - generate add commands for each new rule/chain/set...
> > >> - send the entire thing to the kernel, including the generation ID
> > >> - if the generation ID doesn't match, meaning the ruleset has changed
> > >>   since the last dump, return an error to userspace, retry
> > >
> > >The approach in my patchset is different:
> > >
> > >- generate a delete command that will flush all the previous ruleset
> > >- generate add commands for each new rule/chain/set/tables
> > >- send the batch to the kernel
> > >
> > >In this approach, we don't care about what is in the kernel previous
> > >to the delete command.
> > 
> > Sure, but as Pablo pointed out, it adds more code that needs to be maintained that isn't strictly neccessary.
> 
> Oh, I probably didn't explain well myself. I'd like to see Arturo's
> shortcut using _DELTABLE unless you have any concern with them :-).

No concerns, was just trying to support your arguments :) Either way seems
reasonable to me.

> We still need that generation ID indeed to catch interferences between
> two object dumps, I'll send you a patch proposal for this soon.

Yep, we also need this for set transactions. I suppose we need generation
IDs for each individual object type as well as AF-specific ones which
change for any object change (table level doesn't work because sets are
per AF).
