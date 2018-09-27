From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] netfilter: check if the socket netns is correct.
Date: Thu, 27 Sep 2018 16:08:13 -0700
Message-ID: <20180927230813.GB29261@roeck-us.net>
References: <20180927204629.GA4680@roeck-us.net>
 <20180927225824.GT2702@plex.lan>
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
In-Reply-To: <20180927225824.GT2702@plex.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 27, 2018 at 07:58:24PM -0300, Flavio Leitner wrote:
> On Thu, Sep 27, 2018 at 01:46:29PM -0700, Guenter Roeck wrote:
> > Hi Flavio,
> > 
> > On Wed, Jun 27, 2018 at 10:34:25AM -0300, Flavio Leitner wrote:
> > > Netfilter assumes that if the socket is present in the skb, then
> > > it can be used because that reference is cleaned up while the skb
> > > is crossing netns.
> > > 
> > > We want to change that to preserve the socket reference in a future
> > > patch, so this is a preparation updating netfilter to check if the
> > > socket netns matches before use it.
> > > 
> > > Signed-off-by: Flavio Leitner <fbl@redhat.com>
> > > Acked-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > ---
> > ...
> > > --- a/net/netfilter/xt_socket.c
> > > +++ b/net/netfilter/xt_socket.c
> > > @@ -56,8 +56,12 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
> > >  	struct sk_buff *pskb = (struct sk_buff *)skb;
> > >  	struct sock *sk = skb->sk;
> > >  
> > > +	if (!net_eq(xt_net(par), sock_net(sk)))
> > > +		sk = NULL;
> > > +
> > 
> > I am having trouble with this code. With CONFIG_NET_NS enabled, it crashes
> > for me in read_pnet() because sk is NULL.
> > 
> > >  	if (!sk)
> > >  		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));
> > 
> > The old code seems to suggest that sk == NULL was possible.
> > 
> > I see the problem with the Chrome OS kernel rebased to v4.19-rc5, so I
> > can not guarantee that this really an upstream problem. The change seems
> > odd, though. Are you sure that it is not (or, rather, no longer) necessary
> > to check if sk == NULL before dereferencing it in sock_net() ?
> 
> Oops, it is necessary but if it's not and the netns doesn't match, we need
> do the lookup. So, could you check if this fixes the problem for you?
> 
> From a5f927e7f1368d753f87cb978d630d786d5adb62 Mon Sep 17 00:00:00 2001
> From: Flavio Leitner <fbl@redhat.com>
> Date: Thu, 27 Sep 2018 19:36:28 -0300
> Subject: [PATCH] xt_socket: check sk before checking for netns.
> 
> Only check for the network namespace if the socket is available.
> 
> Fixes: f564650106a6 ("netfilter: check if the socket netns is correct.")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Flavio Leitner <fbl@redhat.com>

This fixes the problem for me.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ---
>  net/netfilter/xt_socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 0472f3472842..ada144e5645b 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -56,7 +56,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
>  	struct sk_buff *pskb = (struct sk_buff *)skb;
>  	struct sock *sk = skb->sk;
>  
> -	if (!net_eq(xt_net(par), sock_net(sk)))
> +	if (sk && !net_eq(xt_net(par), sock_net(sk)))
>  		sk = NULL;
>  
>  	if (!sk)
> @@ -117,7 +117,7 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
>  	struct sk_buff *pskb = (struct sk_buff *)skb;
>  	struct sock *sk = skb->sk;
>  
> -	if (!net_eq(xt_net(par), sock_net(sk)))
> +	if (sk && !net_eq(xt_net(par), sock_net(sk)))
>  		sk = NULL;
>  
>  	if (!sk)
> -- 
> 2.14.4
> 
