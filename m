From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables-20140407 compilation error
Date: Thu, 10 Apr 2014 12:16:13 +0200
Message-ID: <20140410101613.GA20981@macbook.localnet>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
 <20140409095143.GA12361@breakpoint.cc>
 <20140409123126.GA7102@localhost>
 <20140409152949.GB12361@breakpoint.cc>
 <20140409184418.GA4093@localhost>
 <20140409212714.GA19579@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Nazim Wahid Djafar <nwd.dev@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55248 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542AbaDJKQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:16:17 -0400
Content-Disposition: inline
In-Reply-To: <20140409212714.GA19579@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:27:14PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> No, since no "#define malloc rpl_malloc" will be done nft things will
> compile/link.  You won't be able to run src/nft without fixing ld library
> path, but at least then you'll get a clear message as to where the
> problem is :-)
> 
> > Patrick has some build updates in his queue, not sure if this removal
> > may clash with his changes.
> 
> I see, I'll leave it alone then (at least until his changes are in).

Please go ahead, they're quite minimal and shouldn't be hard to merge
if any conflicts occur.
