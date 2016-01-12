From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] ipset: allow a 0 netmask with hash_netiface type
Date: Tue, 12 Jan 2016 20:51:22 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1601122046240.19324@blackhole.kfki.hu>
References: <1452614825-19749-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54751 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbcALTvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 14:51:08 -0500
In-Reply-To: <1452614825-19749-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, 12 Jan 2016, Florian Westphal wrote:

> Jozsef says:
>  The correct behaviour is that if we have
>  ipset create test1 hash:net,iface
>  ipset add test1 0.0.0.0/0,eth0
>  iptables -A INPUT -m set --match-set test1 src,src
> 
>  then the rule should match for any traffic coming in through eth0.
> 
> This removes the -EINVAL runtime test to make matching work
> in case packet arrived via the specified interface.

No, the patch actually would break the set type. In order to support /0 
prefixes, cidr + 1 is stored internally. Zero value means "empty 
slot/bucket".

> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1297092

>From the bugreport we neither know the kernel version nor the exact 
iptables command. It might be that the rule is added to a chain from where 
the input interface is not available.

Best regards,
Jozsef

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
> index 43d8c98..f0f688d 100644
> --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> @@ -164,8 +164,6 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
>  	};
>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
>  
> -	if (e.cidr == 0)
> -		return -EINVAL;
>  	if (adt == IPSET_TEST)
>  		e.cidr = HOST_MASK;
>  
> @@ -377,8 +375,6 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
>  	};
>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
>  
> -	if (e.cidr == 0)
> -		return -EINVAL;
>  	if (adt == IPSET_TEST)
>  		e.cidr = HOST_MASK;
>  
> -- 
> 2.4.10
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
