From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 13/18] libnftables: add nft_context_set_print
Date: Fri, 25 Aug 2017 13:49:56 +0200
Message-ID: <1503661796.31357.22.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-14-eric@regit.org> <20170825095929.GA3192@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:42112 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755656AbdHYLt6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:49:58 -0400
In-Reply-To: <20170825095929.GA3192@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 2017-08-25 at 11:59 +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 19, 2017 at 05:24:15PM +0200, Eric Leblond wrote:
> > This function allows user to set his own printing function. It is
> > still dependant of the format used by nft but at least it can be
> > redirected easily.
> 
> I'm looking at this patch...
> 
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  include/nftables/nftables.h | 3 +++
> >  src/libnftables.c           | 9 +++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/include/nftables/nftables.h
> > b/include/nftables/nftables.h
> > index b902cbd..935d0db 100644
> > --- a/include/nftables/nftables.h
> > +++ b/include/nftables/nftables.h
> > @@ -26,6 +26,9 @@ void nft_global_deinit(void);
> >  
> >  struct nft_ctx *nft_context_new(void);
> >  void nft_context_free(struct nft_ctx *nft);
> > +void nft_context_set_print_func(struct nft_ctx *nft,
> > +				int (*print)(void *ctx, const char
> > *fmt, ...),
> > +				void *ctx);
> >  
> >  int nft_run_command_from_buffer(struct nft_ctx *nft,
> >  				char *buf, size_t buflen);
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 7209885..f0decae 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -86,6 +86,15 @@ struct nft_ctx *nft_context_new(void)
> >  	return ctx;
> >  }
> >  
> > +void nft_context_set_print_func(struct nft_ctx *nft,
> > +				int (*print)(void *ctx, const char
> > *fmt, ...),
> > +				void *ctx)
> 
> Can we have a strict type here instead of void *ctx? I mean, if ctx
> is
> always going to be a file descriptor, I would prefer this is a
> specific type.
> 
> Or are you envisioning any real use of this generic type? If we
> cannot
> forecast anything reasonable, then a strict type is the way to go
> IMO.

Yes, it can be any internal structure from the user application. For
instance, it can be a structure storing logging information, that
accumulate the buffer and do a line by line output in a GUI.

Writing that I realize that it would be better at least for high level
function to provide a complete buffer containing the error to the user
instead of that. Maybe it could be the default function and we provide
that function for some corner cases ?

++
-- 
Eric Leblond <eric@regit.org>
