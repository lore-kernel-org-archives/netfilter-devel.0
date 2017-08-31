From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 13/18] libnftables: add nft_context_set_print
Date: Thu, 31 Aug 2017 12:09:25 +0200
Message-ID: <20170831100925.GA702@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-14-eric@regit.org>
 <20170825095929.GA3192@salvia>
 <1503661796.31357.22.camel@regit.org>
 <20170830104617.GA30477@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36954 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdHaKJu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2017 06:09:50 -0400
Content-Disposition: inline
In-Reply-To: <20170830104617.GA30477@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 30, 2017 at 12:46:17PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 25, 2017 at 01:49:56PM +0200, Eric Leblond wrote:
> > On Fri, 2017-08-25 at 11:59 +0200, Pablo Neira Ayuso wrote:
> > > On Sat, Aug 19, 2017 at 05:24:15PM +0200, Eric Leblond wrote:
> > > > diff --git a/src/libnftables.c b/src/libnftables.c
> > > > index 7209885..f0decae 100644
> > > > --- a/src/libnftables.c
> > > > +++ b/src/libnftables.c
> > > > @@ -86,6 +86,15 @@ struct nft_ctx *nft_context_new(void)
> > > >  	return ctx;
> > > >  }
> > > >  
> > > > +void nft_context_set_print_func(struct nft_ctx *nft,
> > > > +				int (*print)(void *ctx, const char
> > > > *fmt, ...),
> > > > +				void *ctx)
> > > 
> > > Can we have a strict type here instead of void *ctx? I mean, if ctx
> > > is
> > > always going to be a file descriptor, I would prefer this is a
> > > specific type.
> > > 
> > > Or are you envisioning any real use of this generic type? If we
> > > cannot
> > > forecast anything reasonable, then a strict type is the way to go
> > > IMO.
> > 
> > Yes, it can be any internal structure from the user application. For
> > instance, it can be a structure storing logging information, that
> > accumulate the buffer and do a line by line output in a GUI.
> 
> I don't think we can do snprintf() with this interface, or any other
> printing to buffer with this approach.
> 
> We would need to update the libnftables codebase to keep track of
> offsets and so on.

Forget this. We can indeed use this API to implement buffer like
printing.

But I would prefer strict typing for this API, so we provide to
functions, one to print to buffer and another to print to descriptors,
if this is what you need.

Otherwise, just provide a function that does exactly what you need
right now, with strict typing. If someone else needs a new function to
do something else, then let's wait for them to come and ask for it.

OK?
