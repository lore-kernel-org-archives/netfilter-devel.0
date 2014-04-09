From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 14:31:26 +0200
Message-ID: <20140409123126.GA7102@localhost>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
 <20140409095143.GA12361@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nazim Wahid Djafar <nwd.dev@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46998 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032AbaDIMbg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:31:36 -0400
Content-Disposition: inline
In-Reply-To: <20140409095143.GA12361@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:51:43AM +0200, Florian Westphal wrote:
> Nazim Wahid Djafar <nwd.dev@gmail.com> wrote:
> > There is an error of compilation of nftables-20140407 on Debian 7.0
> > Wheezy (eglibc 2.13 )
> 
> > src/scanner.o: In function `nft_realloc':
> > /home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
> > reference to `rpl_realloc'
> 
> This happens when configure thinks malloc/realloc are missing.
> 
> Any objetions wrt. removing AC_FUNC_MALLOC/AC_FUNC_REALLOC from
> nftables configure.ac?

If that resolves the problem, please go ahead, thanks Florian.
