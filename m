From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 17:29:49 +0200
Message-ID: <20140409152949.GB12361@breakpoint.cc>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
 <20140409095143.GA12361@breakpoint.cc>
 <20140409123126.GA7102@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Nazim Wahid Djafar <nwd.dev@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53755 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933372AbaDIP3w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:29:52 -0400
Content-Disposition: inline
In-Reply-To: <20140409123126.GA7102@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > src/scanner.o: In function `nft_realloc':
> > > /home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
> > > reference to `rpl_realloc'
> > 
> > This happens when configure thinks malloc/realloc are missing.
> > 
> > Any objetions wrt. removing AC_FUNC_MALLOC/AC_FUNC_REALLOC from
> > nftables configure.ac?
> 
> If that resolves the problem, please go ahead, thanks Florian.

The problem is two-fold.  When libnftnl has just been installed and
is not yet in linker path, the malloc/realloc test will fail:

configure:4557: gcc -o conftest -I/usr/local/libnftnl/include
-L/usr/local/libnftnl/lib conftest.c -lreadline -lgmp -lnftnl -lmnl  >&5
configure:4557: $? = 0
configure:4557: ./conftest
./conftest: error while loading shared libraries: libnftnl.so.0: cannot
open shared object file: No such file or directory

That error is only in config.log, and config.h redefines malloc/realloc
with rpl_ prefix, which then yields the mysterious
'undefined reference to `rpl_realloc'' error when compiling nftables.

The 2nd problem is that the macro executes the built program, which has
the usual cross-compiling issue.

AFAIU these macros are only useful to check if malloc(0) returns
non-NULL and that realloc(NULL, .. works, hence the question if these
should just be removed.
