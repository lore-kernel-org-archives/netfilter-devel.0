From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 6/7] libnftables: Provide an API for include path
 handling
Date: Fri, 20 Oct 2017 23:12:51 +0200
Message-ID: <20171020211251.GL32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-7-phil@nwl.cc>
 <20171020121700.GE4068@salvia>
 <20171020171620.GI32305@orbyte.nwl.cc>
 <20171020191643.GC1600@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53816 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbdJTVMx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 17:12:53 -0400
Content-Disposition: inline
In-Reply-To: <20171020191643.GC1600@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:16:43PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 20, 2017 at 07:16:20PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Fri, Oct 20, 2017 at 02:17:00PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 19, 2017 at 10:18:46AM +0200, Phil Sutter wrote:
> > [...]
> > > > +int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
> > > 
> > > Do we want to accept runtime addition/removal of include paths?
> > 
> > Not necessarily, but src/main.c does just that: It calls nft_ctx_new()
> > first, then adds include paths as it parses them from command line.
> 
> So it's more like a one time call to set up the include path, right?
> So I think semantically this is just another setter. This _add_ name
> made me think you can keep adding including path one after another
> anytime.

Yes, the API (or specifically, nft_ctx_add_include_path()) allows that.
The only alternative I could think of would be to introduce something
like:

| int nft_ctx_set_include_paths(struct nft_ctx *ctx, const char **paths)

Which means src/main.c would have to take care of populating the char **
array itself in order to later pass it in one go to the setter. Fine
with me, you decide! :)

> > > I mean, I would just make it nft_ctx_set_include_path(), then add an
> > > unsetter, so we simplify this.
> > 
> > The counterpart to nft_ctx_add_include_path() is
> > nft_ctx_clear_include_paths(), which just drops all the previously set
> > ones. Does that meet your understanding of an unsetter, or am I missing
> > something?
> 
> Do we have a usecase for nft_ctx_clear_include_paths(). If we don't
> - I don't see any at least from my side - I'd prefer, to keep it back.

It's only used in nft_ctx_free() for now, just because it's convenient.
If you don't want to export it (yet), I can make it static so code
readability is kept but it won't be available to applications.

> > The reason why this patch is a bit more complicated is because I wanted
> > to get rid of the hard upper limit of include paths to avoid introducing
> > a getter for number of set include paths or to make it necessary for
> > applications (read: src/main.c) to check what return code
> > nft_ctx_add_include_path() returned to print a reasonable error message.
> 
> I'm fine with removing the upper limit, but that is a different thing.
> My only concerns are related to the API we provide to set include
> paths.

OK, cool. So we only have to agree about above items.

Cheers, Phil
