From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] netfilter: check if the socket netns is correct.
Date: Thu, 27 Sep 2018 13:46:29 -0700
Message-ID: <20180927204629.GA4680@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Flavio Leitner <fbl@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Flavio,

On Wed, Jun 27, 2018 at 10:34:25AM -0300, Flavio Leitner wrote:
> Netfilter assumes that if the socket is present in the skb, then
> it can be used because that reference is cleaned up while the skb
> is crossing netns.
> 
> We want to change that to preserve the socket reference in a future
> patch, so this is a preparation updating netfilter to check if the
> socket netns matches before use it.
> 
> Signed-off-by: Flavio Leitner <fbl@redhat.com>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
...
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -56,8 +56,12 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
>  	struct sk_buff *pskb = (struct sk_buff *)skb;
>  	struct sock *sk = skb->sk;
>  
> +	if (!net_eq(xt_net(par), sock_net(sk)))
> +		sk = NULL;
> +

I am having trouble with this code. With CONFIG_NET_NS enabled, it crashes
for me in read_pnet() because sk is NULL.

>  	if (!sk)
>  		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));

The old code seems to suggest that sk == NULL was possible.

I see the problem with the Chrome OS kernel rebased to v4.19-rc5, so I
can not guarantee that this really an upstream problem. The change seems
odd, though. Are you sure that it is not (or, rather, no longer) necessary
to check if sk == NULL before dereferencing it in sock_net() ?

> +
>  	if (sk) {
>  		bool wildcard;
>  		bool transparent = true;
> @@ -113,8 +117,12 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
>  	struct sk_buff *pskb = (struct sk_buff *)skb;
>  	struct sock *sk = skb->sk;
>  
> +	if (!net_eq(xt_net(par), sock_net(sk)))
> +		sk = NULL;
> +
Same here.

>  	if (!sk)
>  		sk = nf_sk_lookup_slow_v6(xt_net(par), skb, xt_in(par));
> +
>  	if (sk) {
>  		bool wildcard;
>  		bool transparent = true;

Thanks,
Guenter
