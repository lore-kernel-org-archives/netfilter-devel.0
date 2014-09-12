From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH] src: add set optimization options
Date: Fri, 12 Sep 2014 19:45:31 +0100
Message-ID: <20140912184530.GA3740@acer.localdomain>
References: <20140813081649.25737.82564.stgit@nfdev.cica.es>
 <20140903100959.GA17083@salvia>
 <20140903102233.GC4069@acer.localdomain>
 <CAOkSjBiWRHDx13UW34gMa_wfD2VZseETE+BQss3Qi2JbhAcRCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44032 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaILSpg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:45:36 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiWRHDx13UW34gMa_wfD2VZseETE+BQss3Qi2JbhAcRCw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 12, 2014 at 08:35:03PM +0200, Arturo Borrero Gonzalez wrote:
> On 3 September 2014 12:22, Patrick McHardy <kaber@trash.net> wrote:
> > On Wed, Sep 03, 2014 at 12:09:59PM +0200, Pablo Neira Ayuso wrote:
> >> Cc'ing Patrick.
> >>
> >> On Wed, Aug 13, 2014 at 10:17:06AM +0200, Arturo Borrero Gonzalez wrote:
> >> > This patch adds options to choose set optimization mechanisms.
> >> >
> >> > The syntax is one of:
> >> >
> >> >  nft add set filter set1 { type ipv4_addr size 1024 ; }
> >> >  nft add set filter set1 { type ipv4_addr policy memory ; }
> >> >  nft add set filter set1 { type ipv4_addr policy performance ; }
> >> >  nft add set filter set1 { type ipv4_addr policy memory size 1024 ; }
> >> >  nft add set filter set1 { type ipv4_addr size 1024 policy memory ; }
> >> >  nft add set filter set1 { type ipv4_addr policy performance size 1024 ; }
> >> >  nft add set filter set1 { type ipv4_addr size 1024 policy performance ; }
> >>
> >> @Patrick: Does this syntax look reasonable to you?
> >
> > I think I would prefer having statements instead of everything combined.
> >
> 
> Could you please elaborate on this?

Something like this:

{
	type ipve_addr
	size 1024
	policy performance
}

or seperate by colons in case they are on a single line.

> >> > Also valid for maps:
> >> >
> >> >  nft add map filter map1 { type ipv4_addr : verdict policy performace ; }

This gets a bit unreadable so { type ipv4_addr : verdict; policy performance; }
seems better to me.

> > This is what I have in my patchset:
> >
> > +struct set_desc {
> > +       unsigned int            size;
> > +       struct expr             *range;
> > +};
> >
> > Range is another way to express the maximum size and at the same time a
> > common prefix.
> >
> > I can dust off my patch and send it later so we combine what we have.
> 
> Would you send that patch?

Yep, just started to work on my tree five minutes ago. I'll forward-port
everything and will send the patch once I'm done.
