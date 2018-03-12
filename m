From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] netfilter: cttimeout: remove VLA usage
Date: Mon, 12 Mar 2018 16:58:38 -0700
Message-ID: <1520899118.2049.24.camel@perches.com>
References: <20180312231442.GA22071@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180312231442.GA22071@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2018-03-12 at 18:14 -0500, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wvla, remove VLA and replace it
> with dynamic memory allocation.
> 
> From a security viewpoint, the use of Variable Length Arrays can be
> a vector for stack overflow attacks. Also, in general, as the code
> evolves it is easy to lose track of how big a VLA can get. Thus, we
> can end up having segfaults that are hard to debug.
> 
> Also, fixed as part of the directive to remove all VLAs from
[]
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
[]
> @@ -51,19 +51,27 @@ ctnl_timeout_parse_policy(void *timeouts,
>  			  const struct nf_conntrack_l4proto *l4proto,
>  			  struct net *net, const struct nlattr *attr)
>  {
> +	struct nlattr **tb;
>  	int ret = 0;
>  
> -	if (likely(l4proto->ctnl_timeout.nlattr_to_obj)) {
> -		struct nlattr *tb[l4proto->ctnl_timeout.nlattr_max+1];
> +	if (!l4proto->ctnl_timeout.nlattr_to_obj)
> +		return 0;

Why not
	if unlikely(!...)
	
>  
> -		ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max,
> -				       attr, l4proto->ctnl_timeout.nla_policy,
> -				       NULL);
> -		if (ret < 0)
> -			return ret;
> +	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
> +		     GFP_KERNEL);

kmalloc_array?

>  
> -		ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
> -	}
> +	if (!tb)
> +		return -ENOMEM;
> +
> +	ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max, attr,
> +			       l4proto->ctnl_timeout.nla_policy, NULL);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
> +
> +err:
> +	kfree(tb);
>  	return ret;
>  }
>  
