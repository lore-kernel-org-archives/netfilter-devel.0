From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 13/18] libnftables: add nft_context_set_print
Date: Wed, 30 Aug 2017 12:46:17 +0200
Message-ID: <20170830104617.GA30477@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-14-eric@regit.org>
 <20170825095929.GA3192@salvia>
 <1503661796.31357.22.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55767 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdH3Kql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2017 06:46:41 -0400
Content-Disposition: inline
In-Reply-To: <1503661796.31357.22.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 25, 2017 at 01:49:56PM +0200, Eric Leblond wrote:
> Hi,
> 
> On Fri, 2017-08-25 at 11:59 +0200, Pablo Neira Ayuso wrote:
> > On Sat, Aug 19, 2017 at 05:24:15PM +0200, Eric Leblond wrote:
> > > This function allows user to set his own printing function. It is
> > > still dependant of the format used by nft but at least it can be
> > > redirected easily.
> > 
> > I'm looking at this patch...
> > 
> > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > ---
> > >  include/nftables/nftables.h | 3 +++
> > >  src/libnftables.c           | 9 +++++++++
> > >  2 files changed, 12 insertions(+)
> > > 
> > > diff --git a/include/nftables/nftables.h
> > > b/include/nftables/nftables.h
> > > index b902cbd..935d0db 100644
> > > --- a/include/nftables/nftables.h
> > > +++ b/include/nftables/nftables.h
> > > @@ -26,6 +26,9 @@ void nft_global_deinit(void);
> > >  
> > >  struct nft_ctx *nft_context_new(void);
> > >  void nft_context_free(struct nft_ctx *nft);
> > > +void nft_context_set_print_func(struct nft_ctx *nft,
> > > +				int (*print)(void *ctx, const char
> > > *fmt, ...),
> > > +				void *ctx);
> > >  
> > >  int nft_run_command_from_buffer(struct nft_ctx *nft,
> > >  				char *buf, size_t buflen);
> > > diff --git a/src/libnftables.c b/src/libnftables.c
> > > index 7209885..f0decae 100644
> > > --- a/src/libnftables.c
> > > +++ b/src/libnftables.c
> > > @@ -86,6 +86,15 @@ struct nft_ctx *nft_context_new(void)
> > >  	return ctx;
> > >  }
> > >  
> > > +void nft_context_set_print_func(struct nft_ctx *nft,
> > > +				int (*print)(void *ctx, const char
> > > *fmt, ...),
> > > +				void *ctx)
> > 
> > Can we have a strict type here instead of void *ctx? I mean, if ctx
> > is
> > always going to be a file descriptor, I would prefer this is a
> > specific type.
> > 
> > Or are you envisioning any real use of this generic type? If we
> > cannot
> > forecast anything reasonable, then a strict type is the way to go
> > IMO.
> 
> Yes, it can be any internal structure from the user application. For
> instance, it can be a structure storing logging information, that
> accumulate the buffer and do a line by line output in a GUI.

I don't think we can do snprintf() with this interface, or any other
printing to buffer with this approach.

We would need to update the libnftables codebase to keep track of
offsets and so on.

> Writing that I realize that it would be better at least for high level
> function to provide a complete buffer containing the error to the user
> instead of that. Maybe it could be the default function and we provide
> that function for some corner cases ?

I'd suggest we start with something simple that suit your specific
needs, and at the same make sure we can extend such API to cover the
buffer like and file description printing, which are the two common
cases I can think of.
