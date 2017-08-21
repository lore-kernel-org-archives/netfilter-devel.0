From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Mon, 21 Aug 2017 21:21:06 +0200
Message-ID: <1503343266.9868.11.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-6-eric@regit.org> <20170821082344.GE2982@salvia>
         <20170821084520.GA3433@salvia> <1503306379.17531.3.camel@regit.org>
         <20170821094432.GA3932@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:52810 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753557AbdHUTVX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 15:21:23 -0400
In-Reply-To: <20170821094432.GA3932@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-08-21 at 11:44 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 21, 2017 at 11:06:19AM +0200, Eric Leblond wrote:
> > Hi,
> > 
> > On Mon, 2017-08-21 at 10:45 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Aug 21, 2017 at 10:23:44AM +0200, Pablo Neira Ayuso
> > > wrote:
> > > > On Sat, Aug 19, 2017 at 05:24:07PM +0200, Eric Leblond wrote:
> > > > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > > > ---
> > > > >  include/nftables/nftables.h |  3 +++
> > > > >  src/libnftables.c           | 26 +++++++++++++++++++++++++-
> > > > >  src/main.c                  | 19 ++++++++-----------
> > > > >  3 files changed, 36 insertions(+), 12 deletions(-)
> > > > > 
> > > > > diff --git a/include/nftables/nftables.h
> > > > > b/include/nftables/nftables.h
> > > > > index cfa60fe..63150ba 100644
> > > > > --- a/include/nftables/nftables.h
> > > > > +++ b/include/nftables/nftables.h
> > > > > @@ -20,4 +20,7 @@ void nft_global_deinit(void);
> > > > >  struct nft_ctx *nft_context_new(void);
> > > > >  void nft_context_free(struct nft_ctx *nft);
> > > > >  
> > > > > +int nft_run_command_from_buffer(struct nft_ctx *nft, struct
> > > > > nft_cache *cache,
> > > > > +				char *buf, size_t buflen);
> > > > 
> > > > Can we probably have something like:
> > > > 
> > > > nft_import_from_buffer(ctx, ...)
> > > > nft_import_from_file(ctx, ...)
> > > > 
> > > > That initializes the context structure. Then, a generic:
> > > > 
> > > > nft_run(ctx)
> > > > 
> > > > I suggest you make a patch to add these to nftables in first
> > > > place.
> > > > I mean, just send a patch that adds these functions as static
> > > > to
> > > > src/main.c to start with it. Just as a cleanup to prepare
> > > > thing, we
> > > > can integrate this asap meanwhile we keep discussing library
> > > > details,
> > > > so we reduce the size/burden of your patchset as we iterate
> > > > over
> > > > it.
> > > > To integrate things more quickly.
> > > 
> > > Actually, every nft_import_xyz() would just provide the batch
> > > support
> > > we need, ie. it should be possible to call nft_import_xyz()
> > > several
> > > times before we call nft_run().
> > > 
> > > The nft_import_xyz() calls would to the scanner, parsing and
> > > evaluation phases.
> > > 
> > > The nft_run(nlsock, ...) would just push this into the kernel -
> > > so
> > > this function would be wrapping the netlink layer handling...
> > 
> > I like the idea to hide the batch inside nft_import function. But I
> > still don't like the idea of having the user handling 2 things
> > (nft_ctx
> > and netlink socket) to be able to send a simple command to the
> > kernel.
> > 
> > I understand your problem with netlink handling. What I would
> > suggest
> > is to add a flag to nft_context_new function so user can specify
> > "I'm
> > handling the nf socket".
> > 
> > Then we can have something like
> > 
> > nft_commit(context, ...)
> > 
> > OR for advanced users:
> > 
> > nft_run(nf_sock, context, ...) 
> > 
> > I don't like the naming but I think you get the idea.
> 
> I'm fine if you want to provide a 'shortcut' function that does it
> all
> in one go, but it should be a composite of the _advanced functions_.
> 
> In a nutshell: we provide a simple API for people that don't want to
> deal with IO at all, that's good. Then, an API that allows people to
> deal with IO themselves - advanced stuff. Simple API functions would
> be made of composites of the advance ones.

OK, I'm good with this approach and it will please the "I'm afraid of
netlink" club ;)

> Everytime I see IO hidding underneath layers of abstractions, it just
> means problems. In terms of maintainance, you end up with complex
> codebase with lots of switches/toggles that users can turn on and
> off,
> then the library code needs to handle all of those combinations...
> 
> If the IO logic is placed on the side of client for advanced stuff,
> we
> simply don't have to maintain all that complexity. At least, until it
> is proven that some specific IO handling is good enough to be
> generalized to be placed in the library.
> 
> So we expose a simple API that does it all in one shot for people
> that
> don't care about netlink, but you have to promise me it will always
> stay simple forever. No room to extend the _simple API_ with
> flags/knobs that users can turn on/off to slightly change the
> behaviour in some aspect, OK? :-)

I think we can all have as a guideline for libnftables that all
advanced things are going to the advanced functions. The simple
functions must provide something appealing in term of features but have
to remain really simple.

This make me think I still don't know how to deal with sets. I'm not
planning to work on it but I think it is a feature that should be
available in the simple functions. But we are dealing with possibly
complex object so this can be really messy.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
