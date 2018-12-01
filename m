From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: do not call ipset_nest_end after
 nla_nest_cancel
Date: Sat, 1 Dec 2018 17:40:01 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1812011738550.19565@blackhole.kfki.hu>
References: <1543228930-103509-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543228930-103509-1-git-send-email-bianpan2016@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 26 Nov 2018, Pan Bian wrote:

> In the error handling block, nla_nest_cancel(skb, atd) is called to
> cancel the nest operation. But then, ipset_nest_end(skb, atd) is
> unexpected called to end the nest operation. This patch calls the
> ipset_nest_end only on the branch that nla_nest_cancel is
> not called.
> 
> Fixes: 45040978c89("netfilter: ipset: Fix set:list type crash when
> flush/dump set in parallel")

Good catch, thank you. Patch is applied in ipset git tree.

Best regards,
Jozsef

> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  net/netfilter/ipset/ip_set_list_set.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index 4eef55d..8da228d 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -531,8 +531,8 @@ list_set_list(const struct ip_set *set,
>  		ret = -EMSGSIZE;
>  	} else {
>  		cb->args[IPSET_CB_ARG0] = i;
> +		ipset_nest_end(skb, atd);
>  	}
> -	ipset_nest_end(skb, atd);
>  out:
>  	rcu_read_unlock();
>  	return ret;
> -- 
> 2.7.4
> 
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
