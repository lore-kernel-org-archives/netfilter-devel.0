From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ip_set: remove extraneous log message
Date: Tue, 4 Mar 2014 21:47:26 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1403042145590.17684@blackhole.kfki.hu>
References: <1393794424-1887-1-git-send-email-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53417 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbaCDUra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:47:30 -0500
In-Reply-To: <1393794424-1887-1-git-send-email-Jason@zx2c4.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2 Mar 2014, Jason A. Donenfeld wrote:

> This code path is hit everytime a new network namespace is created,
> which means it runs everytime I start Chromium, resulting in needless
> noise in my logs. This message doesn't add very much at all, and isn't
> triggered at the correct place anyway, so this patch simply removes it.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/netfilter/ipset/ip_set_core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index de770ec..283f197 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1945,7 +1945,6 @@ ip_set_net_init(struct net *net)
>  		return -ENOMEM;
>  	inst->is_deleted = 0;
>  	rcu_assign_pointer(inst->ip_set_list, list);
> -	pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
>  	return 0;
>  }

A similar patch has already been applied to the ipset git tree and going 
to be submitted this week. Thanks your patch anyway.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
