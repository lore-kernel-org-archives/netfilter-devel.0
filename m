From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 11:51:43 +0200
Message-ID: <20140409095143.GA12361@breakpoint.cc>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nazim Wahid Djafar <nwd.dev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52536 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758185AbaDIJvp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:51:45 -0400
Content-Disposition: inline
In-Reply-To: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nazim Wahid Djafar <nwd.dev@gmail.com> wrote:
> There is an error of compilation of nftables-20140407 on Debian 7.0
> Wheezy (eglibc 2.13 )

> src/scanner.o: In function `nft_realloc':
> /home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
> reference to `rpl_realloc'

This happens when configure thinks malloc/realloc are missing.

Any objetions wrt. removing AC_FUNC_MALLOC/AC_FUNC_REALLOC from
nftables configure.ac?
