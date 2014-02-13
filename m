From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset 2/2] lib: don't segfault when ipset_data_get returns
 NULL
Date: Thu, 13 Feb 2014 11:14:34 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402131110080.16734@blackhole.kfki.hu>
References: <1392197240-9389-1-git-send-email-fw@strlen.de> <1392197240-9389-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39244 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbaBMKOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:14:37 -0500
In-Reply-To: <1392197240-9389-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, 12 Feb 2014, Florian Westphal wrote:

> ipset_data_get returns NULL if the attribute is not available, causes when
> running 'ipset list':
> 
> $ ipset -N foo hash:ip
> $ ipset list
> Segmentation fault (core dumped)

I'm unable to reproduce it. Please give me more information on the 
environment: architecture, kernel, ipset userspace versions, compiler 
version.
 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Not sure about this patch, the missing attr is IPSET_OPT_MEMSIZE.
>  Is the kernel supposed to send it along (i am on latest nf tree)?

How do you know which attr is missing? IPSET_OPT_MEMSIZE should always be
sent by the kernel, look at mtype_head in ip_set_hash_gen.h.

> 
> diff --git a/lib/print.c b/lib/print.c
> index f81c074..9ad4bab 100644
> --- a/lib/print.c
> +++ b/lib/print.c
> @@ -378,6 +378,8 @@ ipset_print_number(char *buf, unsigned int len,
>  	assert(data);
>  
>  	number = ipset_data_get(data, opt);
> +	if (!number)
> +		return 0;
>  	maxsize = ipset_data_sizeof(opt, AF_INET);
>  	D("opt: %u, maxsize %zu", opt, maxsize);
>  	if (maxsize == sizeof(uint8_t))
> -- 
> 1.8.1.5

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
