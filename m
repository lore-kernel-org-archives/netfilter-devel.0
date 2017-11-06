From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: use swap macro instead of _manually_
 swapping values
Date: Mon, 6 Nov 2017 09:41:55 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1711060940510.6547@blackhole.kfki.hu>
References: <20171030221925.GA28998@embeddedor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030221925.GA28998@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 30 Oct 2017, Gustavo A. R. Silva wrote:

> Make use of the swap macro and remove unnecessary variables tmp.
> This makes the code easier to read and maintain.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  net/netfilter/ipset/ip_set_bitmap_ip.c    | 8 ++------
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c | 8 ++------
>  net/netfilter/ipset/ip_set_bitmap_port.c  | 8 ++------
>  3 files changed, 6 insertions(+), 18 deletions(-)

Patch is applied in the ipset git tree and will be included in the next 
batch. Thanks!

Best regards,
Jozsef

> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index d8975a0..488d6d0 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -263,12 +263,8 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
>  		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &last_ip);
>  		if (ret)
>  			return ret;
> -		if (first_ip > last_ip) {
> -			u32 tmp = first_ip;
> -
> -			first_ip = last_ip;
> -			last_ip = tmp;
> -		}
> +		if (first_ip > last_ip)
> +			swap(first_ip, last_ip);
>  	} else if (tb[IPSET_ATTR_CIDR]) {
>  		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
>  
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index 4c279fb..c00b6a2 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@ -337,12 +337,8 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
>  		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &last_ip);
>  		if (ret)
>  			return ret;
> -		if (first_ip > last_ip) {
> -			u32 tmp = first_ip;
> -
> -			first_ip = last_ip;
> -			last_ip = tmp;
> -		}
> +		if (first_ip > last_ip)
> +			swap(first_ip, last_ip);
>  	} else if (tb[IPSET_ATTR_CIDR]) {
>  		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
>  
> diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
> index 7f9bbd7..b561ca8 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_port.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_port.c
> @@ -238,12 +238,8 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
>  
>  	first_port = ip_set_get_h16(tb[IPSET_ATTR_PORT]);
>  	last_port = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
> -	if (first_port > last_port) {
> -		u16 tmp = first_port;
> -
> -		first_port = last_port;
> -		last_port = tmp;
> -	}
> +	if (first_port > last_port)
> +		swap(first_port, last_port);
>  
>  	elements = last_port - first_port + 1;
>  	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
