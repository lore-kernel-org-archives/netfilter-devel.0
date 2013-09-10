From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Tue, 10 Sep 2013 23:55:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309102351170.26446@blackhole.kfki.hu>
References: <1378847564-35416-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:52557 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab3IJVzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:55:16 -0400
In-Reply-To: <1378847564-35416-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 10 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This fixes a serious bug affecting all hash types with a net element -
> specifically, if a CIDR value is deleted such that none of the same size
> exist any more, all larger (less-specific) values will then fail to
> match. Adding back any prefix with a CIDR equal to or more specific than
> the one deleted will fix it.
> 
> Steps to reproduce:
> ipset -N test hash:net
> ipset -A test 1.1.0.0/16
> ipset -A test 2.2.2.0/24
> ipset -T test 1.1.1.1		#1.1.1.1 IS in set
> ipset -D test 2.2.2.0/24
> ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set
> 
> This is due to the fact that the nets counter was unconditionally
> decremented prior to the iteration that shifts up the entries. Now, we
> first check if there is a proceeding entry and if not, decrement it and
> return. Otherwise, we proceed to iterate and then clean up the last
> element afterwards.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Good catch! But unconditionally checking the next entry may point over the 
array.

> ---
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 7a5b776..f0f0c8d 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -311,15 +311,17 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
>  
>  	for (i = 0; i < nets_length - 1 && h->nets[i].cidr[n] != cidr; i++)
>  		;
> -	h->nets[i].nets[n]--;
> -
> -	if (h->nets[i].nets[n] != 0)
> +	if (h->nets[i+1].nets[n] == 0) {

Here the checking of i+1 is missing.

> +		h->nets[i].nets[n]--;
>  		return;
> +	}
>  
>  	for (j = i; j < nets_length - 1 && h->nets[j].nets[n]; j++) {
>  		h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
>  		h->nets[j].nets[n] = h->nets[j + 1].nets[n];
>  	}
> +	h->nets[j].cidr[n] = 0;
> +	h->nets[j].nets[n] = 0;
>  }
>  #endif
>  
> -- 
> 1.8.3.2

Please resubmit a fixed patch and I'll apply it. Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
