From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: src: add redirect support
Date: Fri, 12 Dec 2014 19:51:56 +0100
Message-ID: <20141212185156.GA3311@salvia>
References: <20141212152929.GJ8013@acer.localdomain>
 <CAOkSjBg6GomwWz1z-9GK_Lw8ELTfXwrXkDTc7XsLrCwGSTAvRQ@mail.gmail.com>
 <DB870481-09D6-4A54-BC23-1D0045ADEB5C@trash.net>
 <20141212183317.GA3129@salvia>
 <20141212183612.GA3177@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaLLSuS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:50:18 -0500
Content-Disposition: inline
In-Reply-To: <20141212183612.GA3177@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 12, 2014 at 06:36:13PM +0000, Patrick McHardy wrote:
> On 12.12, Pablo Neira Ayuso wrote:
> > On Fri, Dec 12, 2014 at 05:27:03PM +0000, Patrick McHardy wrote:
> > > Am 12. Dezember 2014 17:02:04 GMT+00:00, schrieb Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> > > >
> > > >Do you want me to change the syntax? I can do it this weekend. Just
> > > >let me know :-)
> > > 
> > > Well, I don't think the colon is really bad, however it suggests an
> > > address can be put in front of it. I guess the reason is an
> > > ambiguity in the grammar with following expressions otherwise. Even
> > > though redirect is terminal the grammar so far doesn't know about
> > > it. From a readability POV I like a simple "to".
> > 
> > I also like "to". Patch attached to address this.
> > 
> > > >If you are going to change it yourself, I would suggest to also update
> > > >regression tests [0], which BTW seems broken due to the
> > > >random-fully/fully-random change.
> > > 
> > > I missed that, will fix it up later.
> > 
> > No problem, just fixed it here, will push it now.
> 
> Great, thanks.
> 
> I'll push my concat changes soon unless I hear objections :)

Thanks Patrick.

Let's release 0.4, OK?

Do you want to include your concat changes already in this release?

P.S: It's great to see concat extension finally landing, that's a
killer feature :-).
