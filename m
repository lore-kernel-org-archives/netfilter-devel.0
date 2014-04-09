From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 23:27:14 +0200
Message-ID: <20140409212714.GA19579@breakpoint.cc>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
 <20140409095143.GA12361@breakpoint.cc>
 <20140409123126.GA7102@localhost>
 <20140409152949.GB12361@breakpoint.cc>
 <20140409184418.GA4093@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Nazim Wahid Djafar <nwd.dev@gmail.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55053 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933342AbaDIV1R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:27:17 -0400
Content-Disposition: inline
In-Reply-To: <20140409184418.GA4093@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Apr 09, 2014 at 05:29:49PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > src/scanner.o: In function `nft_realloc':
> > > > > /home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
> > > > > reference to `rpl_realloc'
> > > > 
> > > > This happens when configure thinks malloc/realloc are missing.
> > > > 
> > > > Any objetions wrt. removing AC_FUNC_MALLOC/AC_FUNC_REALLOC from
> > > > nftables configure.ac?
> > > 
> > > If that resolves the problem, please go ahead, thanks Florian.
> > 
> > The problem is two-fold.  When libnftnl has just been installed and
> > is not yet in linker path, the malloc/realloc test will fail:
> > 
> > configure:4557: gcc -o conftest -I/usr/local/libnftnl/include
> > -L/usr/local/libnftnl/lib conftest.c -lreadline -lgmp -lnftnl -lmnl  >&5
> > configure:4557: $? = 0
> > configure:4557: ./conftest
> > ./conftest: error while loading shared libraries: libnftnl.so.0: cannot
> > open shared object file: No such file or directory
> >
> > That error is only in config.log, and config.h redefines malloc/realloc
> > with rpl_ prefix, which then yields the mysterious
> > 'undefined reference to `rpl_realloc'' error when compiling nftables.
> > 
> > The 2nd problem is that the macro executes the built program, which has
> > the usual cross-compiling issue.
> > 
> > AFAIU these macros are only useful to check if malloc(0) returns
> > non-NULL and that realloc(NULL, .. works, hence the question if these
> > should just be removed.
> 
> OK, so if we remove the macros, we may still hit the first problem,
> right?

No, since no "#define malloc rpl_malloc" will be done nft things will
compile/link.  You won't be able to run src/nft without fixing ld library
path, but at least then you'll get a clear message as to where the
problem is :-)

> Patrick has some build updates in his queue, not sure if this removal
> may clash with his changes.

I see, I'll leave it alone then (at least until his changes are in).

Thanks for the heads-up.
