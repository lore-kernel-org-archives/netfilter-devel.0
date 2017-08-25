From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 15/18] libnftables: set max_errors to 1 in library
Date: Fri, 25 Aug 2017 13:37:18 +0200
Message-ID: <1503661038.31357.20.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-16-eric@regit.org> <20170821083746.GI2982@salvia>
         <1503342769.9868.9.camel@regit.org> <20170824160208.GA29786@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41952 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755494AbdHYLhU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:37:20 -0400
In-Reply-To: <20170824160208.GA29786@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-24 at 18:02 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 21, 2017 at 09:12:49PM +0200, Eric Leblond wrote:
> [...]
> > On Mon, 2017-08-21 at 10:37 +0200, Pablo Neira Ayuso wrote:
> 
> [...]
> > > > diff --git a/src/libnftables.c b/src/libnftables.c
> > > > index 61ed4e5..15345ae 100644
> > > > --- a/src/libnftables.c
> > > > +++ b/src/libnftables.c
> > > > @@ -25,7 +25,7 @@
> > > >  #include <fcntl.h>
> > > >  
> > > >  
> > > > -unsigned int max_errors = 10;
> > > > +unsigned int max_errors = 1;
> > > 
> > > This is defeating all the work I've done - both in netlink and in
> > > userspace - in the past to allow printing several errors in one
> > > go.
> > > So
> > > you likely understand I'm reticent to take this as is :-)
> > 
> > For sure, I was just trying to get you excited so you decide to
> > cook a
> > patch fixing this :P
> 
> Not sure it's excitement exactly what I'm feeling here... but I'm
> trying to help, believe it or not... ;-)

I believe you :)

> I'm placing the nft_global_init() and nft_global_deinit() into
> nft_ctx_new() and nft_ctx_free() as we've been discussing.

OK.

> I'm going to stop here for a while. There are still a few pending
> issues, and I would like we don't release anything until we discuss
> all concerns.
> 
> You mentioned about some set issues, please us know. I also want to
> think what you would need for the simple API in the exportation and
> monitor cases.

Could you push the current patchset somewhere so I can get a look this
week end ?

PS: sorry for the delay in the answers

++
-- 
Eric Leblond <eric@regit.org>
