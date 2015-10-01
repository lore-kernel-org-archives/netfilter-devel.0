From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net-next 4/6] ipv6: Pass struct net through ip6_fragment
Date: Thu, 1 Oct 2015 10:31:43 +0200
Message-ID: <560CEF6F.4030403@6wind.com>
References: <877fn7eh2f.fsf_-_@x220.int.ebiederm.org>
 <1443648336-31741-4-git-send-email-ebiederm@xmission.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>,
	David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1443648336-31741-4-git-send-email-ebiederm@xmission.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le 30/09/2015 23:25, Eric W. Biederman a =C3=A9crit :
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
[snip]
> diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
> index 0c3e9ffcf231..335066a64b45 100644
> --- a/net/ipv6/xfrm6_output.c
> +++ b/net/ipv6/xfrm6_output.c
> @@ -131,6 +131,12 @@ int xfrm6_output_finish(struct sock *sk, struct =
sk_buff *skb)
>   	return xfrm_output(sk, skb);
>   }
>
> +static int __xfrm6_output_finish(struct net *net, struct sock *sk, s=
truct sk_buff *skb)
> +{
> +	struct xfrm_state *x =3D skb_dst(skb)->xfrm;
nit: add an empty line after variables declaration.

> +	return x->outer_mode->afinfo->output_finish(sk, skb);
> +}
> +
[snip]
