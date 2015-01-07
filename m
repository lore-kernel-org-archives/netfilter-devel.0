From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCHv2 0/4] support for mini-gmp / embedded friendliness
Date: Wed, 7 Jan 2015 13:52:41 +0100
Message-ID: <20150107125241.GA26629@salvia>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
 <20150107122218.GA15735@salvia>
 <54AD268E.8020702@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbbAGMuF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:50:05 -0500
Content-Disposition: inline
In-Reply-To: <54AD268E.8020702@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 07, 2015 at 01:29:02PM +0100, Steven Barth wrote:
> 
> On 07.01.2015 13:22, Pablo Neira Ayuso wrote:
> >
> >I think you mentioned to me already but
> >
> >  configure: error: --with-mini-gmp MUST be used with --disable-debug
> >
> >any reason to enforce this?
> 
> The problem here is that pr_debug expands to gmp_printf which is not
> part of mini-gmp and the little replacement mpz_printf I added only
> allows for formatting a single mpz_t (which is enough for all the
> non-debug cases).
> 
> So there are 3 options basically.
> 1. Try to make gmp_printf standalone and port it from libgmp to mini-gmp.
>     This looked like a huge and complicated effort and would likely
> blow up stuff considerably again.
> 2. Replace pr_debug's gmp_printf with regular printf and rewrite all
> the debug-calls to mpz_get_str()
>     and free() which sounds painful.
> 3. Simply disabling debugging with mini-gmp.
>     Easy way out without obstructing things too much otherwise.

I see. pr_debug() seems to be only relevant in sec/segtree.c, other
spots can be replaced by printf in src/proto.c

I think it would be good for us to have the debugging option enabled
in embedded builds at this stage, at least as much as we can get in
some easy way. We can ask people to run commands with --debug and
paste the result of it.

We can probably have something like:

#ifdef DEBUG && !MINIGMP
#define pr_debug(fmt, arg...) gmp_printf(fmt, ##arg)
#else
#define pr_debug(fmt, arg...) ({ if (false) {}; 0; })
#endif

so only segtree debugging is turned off and document this in the
INSTALL file.
