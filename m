From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 0/6] events
Date: Tue, 18 Feb 2014 09:24:30 +0000
Message-ID: <20140218092429.GE10327@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140218014348.GD12893@macbook.localnet>
 <CAOkSjBgi5jePNt3F1V0t=iomgNM5iVcan1hdw43kaYcKgCF0pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58009 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaBRJYd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:24:33 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgi5jePNt3F1V0t=iomgNM5iVcan1hdw43kaYcKgCF0pw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:20:46AM +0100, Arturo Borrero Gonzalez wrote:
> On 18 February 2014 02:43, Patrick McHardy <kaber@trash.net> wrote:
> >>
> >> Its quite simple, the syntax is:
> >>  % nft event <all|table|chain|rule|set> [xml|json]
> >
> > So far we're pretty much (except for shortcuts like default "add rule")
> > following the scheme "nft action object". "event" doesn't fit in this
> > scheme, so I'd propose to change this to "monitor". Also I guess object
> > specification could be optional so "all" wouldn't be needed, but that's
> > not too important.
> >
> 
> Ok, so I propose the syntax:
> 
>  % nft monitor [table|chain|rule|set] [new|delete] [xml|json]

Looks good to me.

> >> add rule ip6 filter input handle 4
> >
> > No expressions in the output? Why the set caching then?
> >
> 
> Well, in this first approach I was unable to achieve that :-(
> I needed some feedback (this RFC).
> 
> The intention is of course print out all the expressions.

Great. Let me know if you need some help with that.
