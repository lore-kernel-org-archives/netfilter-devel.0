From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: use printf() instead of pr_debug() whenever
 possible
Date: Thu, 8 Jan 2015 12:21:47 +0000
Message-ID: <20150108122146.GK13765@acer.localdomain>
References: <1420719226-5475-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60803 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbbAHMVv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:21:51 -0500
Content-Disposition: inline
In-Reply-To: <1420719226-5475-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.01, Pablo Neira Ayuso wrote:
> pr_debug() is disabled with --with-mini-gmp since it relies on the
> gmp_printf(), which is not available in the mini-gmp implementation.
> Use printf() instead of pr_debug() if no mpz_t types are used, so
> we get debugging information for proto-ctx as well.
> 
> This leaves the pr_debug() usage limited to src/segtree.c.

I don't think this patch is conceptually good. The intention of
pr_debug() is to be able to disable debugging at compile time
to avoid ifdefs everywhere.

We currently need them for external debugging functions like mnl,
but f.i. in proto_ctx_debug() the compiler should very well be able
to determine that the function is a NOP without debugging enabled.

I'd rather change pr_debug to a normal printf and adapt segtree to
use a pr_gmp_debug or something like that.
