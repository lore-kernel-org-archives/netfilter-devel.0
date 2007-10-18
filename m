From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Find address type on a specific or on any interface
Date: Thu, 18 Oct 2007 11:13:21 +0200
Message-ID: <471723B1.2080804@trash.net>
References: <470F7EB1.2080309@balabit.hu> <11921980402340-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763101AbXJRJNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:13:45 -0400
In-Reply-To: <11921980402340-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> +/*
> + * Find address type as if only "on_dev" was present in the system. If
> + * on_dev is NULL then all interfaces are taken into consideration.
> + */
> +static inline unsigned __inet_addr_type_on_dev(__be32 addr, const struct net_device *on_dev)

I would prefer the name "__inet_dev_addr_type" or "__dev_inet_addr_type"

>  {
>  	struct flowi		fl = { .nl_u = { .ip4_u = { .daddr = addr } } };
>  	struct fib_result	res;
> @@ -164,13 +168,25 @@ unsigned inet_addr_type(__be32 addr)
>  		ret = RTN_UNICAST;
>  		if (!ip_fib_local_table->tb_lookup(ip_fib_local_table,
>  						   &fl, &res)) {
> -			ret = res.type;
> +			if ((!on_dev || on_dev == res.fi->fib_dev)) {
> +			        ret = res.type;
> +			}

No braces around single statements that fit on one line please.

>  			fib_res_put(&res);
>  		}
>  	}
>  	return ret;
>  }
>  
> +unsigned inet_addr_type(__be32 addr)
> +{
> +  return __inet_addr_type_on_dev(addr, NULL);

Use tabs for indenting.
