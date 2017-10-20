From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 6/7] libnftables: Provide an API for include path
 handling
Date: Fri, 20 Oct 2017 21:16:43 +0200
Message-ID: <20171020191643.GC1600@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-7-phil@nwl.cc>
 <20171020121700.GE4068@salvia>
 <20171020171620.GI32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752590AbdJTTQs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 15:16:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E44BAC9EC2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:16:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D09CBDA848
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:16:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171020171620.GI32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 07:16:20PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Oct 20, 2017 at 02:17:00PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 19, 2017 at 10:18:46AM +0200, Phil Sutter wrote:
> [...]
> > > +int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
> > 
> > Do we want to accept runtime addition/removal of include paths?
> 
> Not necessarily, but src/main.c does just that: It calls nft_ctx_new()
> first, then adds include paths as it parses them from command line.

So it's more like a one time call to set up the include path, right?
So I think semantically this is just another setter. This _add_ name
made me think you can keep adding including path one after another
anytime.

> > I mean, I would just make it nft_ctx_set_include_path(), then add an
> > unsetter, so we simplify this.
> 
> The counterpart to nft_ctx_add_include_path() is
> nft_ctx_clear_include_paths(), which just drops all the previously set
> ones. Does that meet your understanding of an unsetter, or am I missing
> something?

Do we have a usecase for nft_ctx_clear_include_paths(). If we don't
- I don't see any at least from my side - I'd prefer, to keep it back.

> The reason why this patch is a bit more complicated is because I wanted
> to get rid of the hard upper limit of include paths to avoid introducing
> a getter for number of set include paths or to make it necessary for
> applications (read: src/main.c) to check what return code
> nft_ctx_add_include_path() returned to print a reasonable error message.

I'm fine with removing the upper limit, but that is a different thing.
My only concerns are related to the API we provide to set include
paths.
