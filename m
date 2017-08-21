From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Mon, 21 Aug 2017 11:06:19 +0200
Message-ID: <1503306379.17531.3.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-6-eric@regit.org> <20170821082344.GE2982@salvia>
         <20170821084520.GA3433@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:42214 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753083AbdHUJGY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 05:06:24 -0400
In-Reply-To: <20170821084520.GA3433@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-08-21 at 10:45 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 21, 2017 at 10:23:44AM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Aug 19, 2017 at 05:24:07PM +0200, Eric Leblond wrote:
> > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > ---
> > >  include/nftables/nftables.h |  3 +++
> > >  src/libnftables.c           | 26 +++++++++++++++++++++++++-
> > >  src/main.c                  | 19 ++++++++-----------
> > >  3 files changed, 36 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/include/nftables/nftables.h
> > > b/include/nftables/nftables.h
> > > index cfa60fe..63150ba 100644
> > > --- a/include/nftables/nftables.h
> > > +++ b/include/nftables/nftables.h
> > > @@ -20,4 +20,7 @@ void nft_global_deinit(void);
> > >  struct nft_ctx *nft_context_new(void);
> > >  void nft_context_free(struct nft_ctx *nft);
> > >  
> > > +int nft_run_command_from_buffer(struct nft_ctx *nft, struct
> > > nft_cache *cache,
> > > +				char *buf, size_t buflen);
> > 
> > Can we probably have something like:
> > 
> > nft_import_from_buffer(ctx, ...)
> > nft_import_from_file(ctx, ...)
> > 
> > That initializes the context structure. Then, a generic:
> > 
> > nft_run(ctx)
> > 
> > I suggest you make a patch to add these to nftables in first place.
> > I mean, just send a patch that adds these functions as static to
> > src/main.c to start with it. Just as a cleanup to prepare thing, we
> > can integrate this asap meanwhile we keep discussing library
> > details,
> > so we reduce the size/burden of your patchset as we iterate over
> > it.
> > To integrate things more quickly.
> 
> Actually, every nft_import_xyz() would just provide the batch support
> we need, ie. it should be possible to call nft_import_xyz() several
> times before we call nft_run().
> 
> The nft_import_xyz() calls would to the scanner, parsing and
> evaluation phases.
> 
> The nft_run(nlsock, ...) would just push this into the kernel - so
> this function would be wrapping the netlink layer handling...

I like the idea to hide the batch inside nft_import function. But I
still don't like the idea of having the user handling 2 things (nft_ctx
and netlink socket) to be able to send a simple command to the kernel.

I understand your problem with netlink handling. What I would suggest
is to add a flag to nft_context_new function so user can specify "I'm
handling the nf socket".

Then we can have something like

nft_commit(context, ...)

OR for advanced users:

nft_run(nf_sock, context, ...) 

I don't like the naming but I think you get the idea.

> I would say this nft_run() become nft_compile() instead and we take
> the underneath netlink codebase to do the handling away from this...
> 
> Otherwise, we will have to add branches to deal with non-blocking IO.
> 
> Then, at some point to start looking like libnl... and that is not
> good ;-)
> 
> I can help with preparation patches, let's just agree on what needs
> to
> be done so we don't overlap each other.

OK sure, I'm busy at work and I'm gonna answers to your other mails
tonight. And then come to you to see how we can share the load.  

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
