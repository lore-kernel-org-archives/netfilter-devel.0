From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 6/7] libnftables: Provide an API for include path
 handling
Date: Fri, 20 Oct 2017 19:16:20 +0200
Message-ID: <20171020171620.GI32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-7-phil@nwl.cc>
 <20171020121700.GE4068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53348 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751698AbdJTRQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 13:16:21 -0400
Content-Disposition: inline
In-Reply-To: <20171020121700.GE4068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Oct 20, 2017 at 02:17:00PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 19, 2017 at 10:18:46AM +0200, Phil Sutter wrote:
[...]
> > +int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
> 
> Do we want to accept runtime addition/removal of include paths?

Not necessarily, but src/main.c does just that: It calls nft_ctx_new()
first, then adds include paths as it parses them from command line.

> I mean, I would just make it nft_ctx_set_include_path(), then add an
> unsetter, so we simplify this.

The counterpart to nft_ctx_add_include_path() is
nft_ctx_clear_include_paths(), which just drops all the previously set
ones. Does that meet your understanding of an unsetter, or am I missing
something?

The reason why this patch is a bit more complicated is because I wanted
to get rid of the hard upper limit of include paths to avoid introducing
a getter for number of set include paths or to make it necessary for
applications (read: src/main.c) to check what return code
nft_ctx_add_include_path() returned to print a reasonable error message.

Cheers, Phil
