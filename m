From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Sun, 23 Jan 2011 14:53:54 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101231446550.13261@blackhole.kfki.hu>
References: <1295705432-2588-1-git-send-email-jacob@internet24.de> <1295705432-2588-2-git-send-email-jacob@internet24.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:40900 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1AWNx4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:53:56 -0500
In-Reply-To: <1295705432-2588-2-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thomas,

On Sat, 22 Jan 2011, Thomas Jacob wrote:

> iprange_ipv6_sub was substracting 2 unsigned ints and then casting
> the result to int to find out whether they are lt, eq or gt each
> other, this doesn't work if the full 32 bits of each part
> can be used in IPv6 addresses. Patch should remedy that without
> significant performance penalties.
> 
> Signed-off-by: Thomas Jacob <jacob@internet24.de>
> ---
>  net/netfilter/xt_iprange.c |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
> index 4b5741b..3cc5d21 100644
> --- a/net/netfilter/xt_iprange.c
> +++ b/net/netfilter/xt_iprange.c
> @@ -96,15 +96,13 @@ iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
>  }
>  
>  static inline int
> -iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
> +iprange_ipv6_lt(const struct in6_addr *a, const struct in6_addr *b)
>  {
>  	unsigned int i;
> -	int r;
>  
>  	for (i = 0; i < 4; ++i) {
> -		r = ntohl(a->s6_addr32[i]) - ntohl(b->s6_addr32[i]);
> -		if (r != 0)
> -			return r;
> +		if(ntohl(a->s6_addr32[i]) != ntohl(b->s6_addr32[i]))
> +			return ntohl(a->s6_addr32[i]) < ntohl(b->s6_addr32[i]);
>  	}

Why do you convert to host order in the inequality test? It could be left 
out.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
