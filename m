From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: actually allow allowable CIDR 0 in
 hash:net,port,net
Date: Thu, 30 Aug 2018 10:23:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1808301022280.588@blackhole.kfki.hu>
References: <a3d786d6-3608-8575-9901-afcf3a52693a@westbrook.io>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Netfilter Core Team <coreteam@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trivial Patch Monkey <trivial@kernel.org>
To: Eric Westbrook <eric@westbrook.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a3d786d6-3608-8575-9901-afcf3a52693a@westbrook.io>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Aug 2018, Eric Westbrook wrote:

> Allow /0 as advertised for hash:net,port,net sets.
> 
> For "hash:net,port,net", ipset(8) says that "either subnet
> is permitted to be a /0 should you wish to match port
> between all destinations."
> 
> Make that statement true.
> 
> Before:
> 
>     # ipset create cidrzero hash:net,port,net
>     # ipset add cidrzero 0.0.0.0/0,12345,0.0.0.0/0
>     ipset v6.34: The value of the CIDR parameter of the IP address is invalid
> 
>     # ipset create cidrzero6 hash:net,port,net family inet6
>     # ipset add cidrzero6 ::/0,12345,::/0
>     ipset v6.34: The value of the CIDR parameter of the IP address is invalid
> 
> After:
> 
>     # ipset create cidrzero hash:net,port,net
>     # ipset add cidrzero 0.0.0.0/0,12345,0.0.0.0/0
>     # ipset test cidrzero 192.168.205.129,12345,172.16.205.129
>     192.168.205.129,tcp:12345,172.16.205.129 is in set cidrzero.
> 
>     # ipset create cidrzero6 hash:net,port,net family inet6
>     # ipset add cidrzero6 ::/0,12345,::/0
>     # ipset test cidrzero6 fe80::1,12345,ff00::1
>     fe80::1,tcp:12345,ff00::1 is in set cidrzero6.
> 
> See also:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=200897
>   https://github.com/ewestbrook/linux/commit/df7ff6efb0934ab6acc11f003ff1a7580d6c1d9c
> 
> Signed-off-by: Eric Westbrook <linux@westbrook.io>

Patch is applied, thank you.

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_hash_netportnet.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
> index d391485a6acd..613e18e720a4 100644
> --- a/net/netfilter/ipset/ip_set_hash_netportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
> @@ -213,13 +213,13 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
> 
>  	if (tb[IPSET_ATTR_CIDR]) {
>  		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> -		if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
> +		if (e.cidr[0] > HOST_MASK)
>  			return -IPSET_ERR_INVALID_CIDR;
>  	}
> 
>  	if (tb[IPSET_ATTR_CIDR2]) {
>  		e.cidr[1] = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> -		if (!e.cidr[1] || e.cidr[1] > HOST_MASK)
> +		if (e.cidr[1] > HOST_MASK)
>  			return -IPSET_ERR_INVALID_CIDR;
>  	}
> 
> @@ -493,13 +493,13 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
> 
>  	if (tb[IPSET_ATTR_CIDR]) {
>  		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> -		if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
> +		if (e.cidr[0] > HOST_MASK)
>  			return -IPSET_ERR_INVALID_CIDR;
>  	}
> 
>  	if (tb[IPSET_ATTR_CIDR2]) {
>  		e.cidr[1] = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> -		if (!e.cidr[1] || e.cidr[1] > HOST_MASK)
> +		if (e.cidr[1] > HOST_MASK)
>  			return -IPSET_ERR_INVALID_CIDR;
>  	}
> 
> -- 
> 2.18.0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
