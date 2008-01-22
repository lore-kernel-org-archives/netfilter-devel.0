From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Introducing socket mark socket option
Date: Tue, 22 Jan 2008 15:38:38 +0100
Message-ID: <4795FFEE.8070400@trash.net>
References: <12010124971855-git-send-email->
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Laszlo Attila Toth <panther@balabit.hu>
To: laszlo@balabit.hu, attila@balabit.hu, Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50307 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYAVOjH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:39:07 -0500
In-Reply-To: <12010124971855-git-send-email->
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

laszlo@balabit.hu wrote:
> From: Laszlo Attila Toth <panther@balabit.hu>
> 
> If netfilter is enabled, a userspace program may wish to set the mark for
> each packets its send instead of using the MARK target.


Looks reasonable, but please CC netdev and linux-arch.

> diff --git a/include/net/route.h b/include/net/route.h
> index 5847e6f..70792e3 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -27,6 +27,7 @@
>  #include <net/dst.h>
>  #include <net/inetpeer.h>
>  #include <net/flow.h>
> +#include <net/sock.h>
>  #include <linux/in_route.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/route.h>
> @@ -148,9 +149,13 @@ static inline int ip_route_connect(struct rtable **rp, __be32 dst,
>  				   int flags)
>  {
>  	struct flowi fl = { .oif = oif,
> +#ifdef CONFIG_NETFILTER
> +			 .mark = sk->sk_mark,
> +#endif

Formatting is slightly inconsistent, but more importantly the mark
doesn't depend on CONFIG_NETFILTER anymore.

>  			    .nl_u = { .ip4_u = { .daddr = dst,
>  						 .saddr = src,
> -						 .tos   = tos } },
> +						 .tos   = tos,
> +                            } },
>  			    .proto = protocol,
>  			    .uli_u = { .ports =
>  				       { .sport = sport,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9023244..8e88a0e 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -252,6 +252,9 @@ struct sock {
>  	long			sk_rcvtimeo;
>  	long			sk_sndtimeo;
>  	struct sk_filter      	*sk_filter;
> +#ifdef CONFIG_NETFILTER
> +	__u32			sk_mark;
> +#endif

Please find a spot that doesn't add holes on 64 bit.

>  	void			*sk_protinfo;
