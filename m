From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: set errno correctly in
 iptcc_chain_index_alloc
Date: Thu, 4 Jul 2013 18:33:25 +0200
Message-ID: <20130704163325.GD2351@breakpoint.cc>
References: <20130704011610.GA9791@linuxace.com>
 <20130704074222.GC2351@breakpoint.cc>
 <20130704161845.GA11465@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54188 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525Ab3GDQd1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:33:27 -0400
Content-Disposition: inline
In-Reply-To: <20130704161845.GA11465@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> Simulate an out of memory condition with this patch
> 
> @@ -500,9 +500,11 @@ static int iptcc_chain_index_alloc(struct xtc_handle *h)
>               array_elems, array_mem);
> 
>         h->chain_index = malloc(array_mem);
> -       if (h->chain_index == NULL && array_mem > 0) {
> +       //if (h->chain_index == NULL && array_mem > 0) {
> +       if (1) {
>                 h->chain_index_sz = 0;
> With the patch, the error message returned to user:
> 
>    ...can't initialize iptables table `filter': Memory allocation problem
> 
> without the patch:
> 
>    ...can't initialize iptables table `filter': Incompatible with this kernel
> 
> The former seems better, no?

Yes, but malloc didn't fail, so malloc didn't set errno.

My point is, that we should not muck with errno, especially
after libc functions that usually already set it on error.
