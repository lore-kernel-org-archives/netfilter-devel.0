From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: nfnetlink warnings
Date: Mon, 23 Nov 2015 10:49:34 +0100
Message-ID: <5652E12E.3070500@profitbricks.com>
References: <20151123093607.GA5134@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Borislav Petkov <bp@alien8.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151123093607.GA5134@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi, Borislav

Why not just initialized it as NULL, or mark it as uninitialized_var()?

Regards,
Michael Wang

On 11/23/2015 10:36 AM, Borislav Petkov wrote:
> Hey,
>=20
> so I keep getting those since recently:
>=20
> net/netfilter/nfnetlink_queue.c:519:19: warning: =E2=80=98nfnl_ct=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
>   if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < =
0)
>                    ^
> net/netfilter/nfnetlink_queue.c:316:23: note: =E2=80=98nfnl_ct=E2=80=99=
 was declared here
>   struct nfnl_ct_hook *nfnl_ct;
>                        ^
> net/netfilter/nfnetlink_queue.c: In function =E2=80=98nfqnl_recv_verd=
ict=E2=80=99:
> net/netfilter/nfnetlink_queue.c:1083:11: warning: =E2=80=98nfnl_ct=E2=
=80=99 may be used uninitialized in this function [-Wmaybe-uninitialize=
d]
>     nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
>            ^
>=20
> and was thinking can we shut them up like this? I know, it is ugly :-=
\
>=20
> I mean, it is obvious in both cases that nfnl_ct won't be used if ct =
is
> not set but apparently gcc can't see that far...
>=20
> ---
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlin=
k_queue.c
> index 7d81d280cb4f..cd61b0b5c413 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -372,6 +372,8 @@ nfqnl_build_packet_message(struct net *net, struc=
t nfqnl_instance *queue,
>  			if (ct !=3D NULL)
>  				size +=3D nfnl_ct->build_size(ct);
>  		}
> +	} else {
> +		nfnl_ct =3D NULL;
>  	}
> =20
>  	if (queue->flags & NFQA_CFG_F_UID_GID) {
> @@ -1069,6 +1071,8 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk=
_buff *skb,
>  		nfnl_ct =3D rcu_dereference(nfnl_ct_hook);
>  		if (nfnl_ct !=3D NULL)
>  			ct =3D nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
> +	} else {
> +		nfnl_ct =3D NULL;
>  	}
> =20
>  	if (nfqa[NFQA_PAYLOAD]) {
>=20
