From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: set errno correctly in
 iptcc_chain_index_alloc
Date: Thu, 4 Jul 2013 09:42:22 +0200
Message-ID: <20130704074222.GC2351@breakpoint.cc>
References: <20130704011610.GA9791@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52792 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab3GDHmY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:42:24 -0400
Content-Disposition: inline
In-Reply-To: <20130704011610.GA9791@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> As reported by Robert Barnhardt, iptcc_chain_index_alloc does not populate
> errno with the appropriate ENOMEM on allocation failures.  This causes
> incorrect error messages to be passed back to user such as "can't initialize
> iptables table 'X'" even if the issue was caused by OOM condition.  Fix
> this by passing back ENOMEM if allocation failure occurs.

Personally I think libraries should not change errno at all.

> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index f0f7815..004b0ec 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -502,7 +502,8 @@ static int iptcc_chain_index_alloc(struct xtc_handle *h)
>  	h->chain_index = malloc(array_mem);
>  	if (h->chain_index == NULL && array_mem > 0) {
>  		h->chain_index_sz = 0;
> -		return -ENOMEM;
> +		errno = ENOMEM;
> +		return -1;
>  	}

I don't understand how this changes anything?

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
int main(void) { errno = EINVAL;
	        void *v = malloc(0xffffffffffffffff);
		        if (v == 0) perror("malloc"); }

Yields "Cannot allocate memory", not "Invalid argument".
