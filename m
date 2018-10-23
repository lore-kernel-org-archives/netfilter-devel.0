From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH nf] netfilter: ipv6: fix oops when defragmenting locally
 generated fragments
Date: Tue, 23 Oct 2018 14:04:18 -0700
Message-ID: <CANP3RGfCDumc40Tr2gr0KHenQ6x29tWAjhnM+8yk7nK5nNHRFA@mail.gmail.com>
References: <CANP3RGeX5=c=Lb+Pkg89zD7zQ_Z1T8oPJRCkorNCdghmofYXxg@mail.gmail.com>
 <20181023144716.19746-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181023144716.19746-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 23, 2018 at 7:47 AM, Florian Westphal <fw@strlen.de> wrote:
> Unlike ipv4 and normal ipv6 defrag, netfilter ipv6 defragmentation did
> not save/restore skb->dst.
>
> This causes oops when handling locally generated ipv6 fragments, as
> output path needs a valid dst.
>
> Reported-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
> Fixes: 84379c9afe01 ("netfilter: ipv6: nf_defrag: drop skb dst before que=
ueing")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter=
/nf_conntrack_reasm.c
> index 8f68a518d9db..f76bd4d15704 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -587,11 +587,16 @@ int nf_ct_frag6_gather(struct net *net, struct sk_b=
uff *skb, u32 user)
>          */
>         ret =3D -EINPROGRESS;
>         if (fq->q.flags =3D=3D (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &=
&
> -           fq->q.meat =3D=3D fq->q.len &&
> -           nf_ct_frag6_reasm(fq, skb, dev))
> -               ret =3D 0;
> -       else
> +           fq->q.meat =3D=3D fq->q.len) {
> +               unsigned long orefdst =3D skb->_skb_refdst;
> +
> +               skb->_skb_refdst =3D 0UL;
> +               if (nf_ct_frag6_reasm(fq, skb, dev))
> +                       ret =3D 0;
> +               skb->_skb_refdst =3D orefdst;
> +       } else {
>                 skb_dst_drop(skb);
> +       }
>
>  out_unlock:
>         spin_unlock_bh(&fq->q.lock);
> --
> 2.18.1
>

I don't quite follow how this fixes things, but I'll trust you on it.
(nor do I understand why only 4.9 LTS appears to crash with a null ptr dere=
f)

Thanks for the fix.
