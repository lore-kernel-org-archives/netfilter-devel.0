From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Tue, 17 Aug 2010 10:30:17 +0200
Message-ID: <1282033817.2448.18.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46885 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0HQIaX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:30:23 -0400
In-Reply-To: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 17 ao=C3=BBt 2010 =C3=A0 15:16 +0800, Changli Gao a =C3=A9crit=
 :
> Since we don't change the tuple in the original direction, we can sav=
e it
> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_conf=
irm()
> use.
>=20
> __hash_conntrack() is split into two steps: ____hash_conntrack() is u=
sed
> to get the raw hash, and __hash_bucket() is used to get the bucket id=
=2E
>=20
> In SYN-flood case, early_drop() doesn't need to recompute the hash ag=
ain.
>=20
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  net/netfilter/nf_conntrack_core.c |  117 ++++++++++++++++++++++++++-=
-----------
>  1 file changed, 82 insertions(+), 35 deletions(-)
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_con=
ntrack_core.c
> index df3eedb..947f0a9 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -65,14 +65,23 @@ EXPORT_SYMBOL_GPL(nf_conntrack_max);
>  DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
>  EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
> =20
> -static int nf_conntrack_hash_rnd_initted;
> -static unsigned int nf_conntrack_hash_rnd;
> -
> -static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *t=
uple,
> -				  u16 zone, unsigned int size, unsigned int rnd)
> +static u32 ____hash_conntrack(const struct nf_conntrack_tuple *tuple=
, u16 zone)
>  {
>  	unsigned int n;
>  	u_int32_t h;
> +	static int rnd_initted;
> +	static unsigned int rnd;
> +	static DEFINE_SPINLOCK(rnd_lock);
> +
> +	if (unlikely(!rnd_initted)) {
> +		spin_lock_bh(&rnd_lock);
> +		if (!rnd_initted) {
> +			get_random_bytes(&rnd, sizeof(rnd));
> +			wmb();
> +			rnd_initted =3D 1;
> +		}
> +		spin_unlock_bh(&rnd_lock);
> +	}
> =20

Three variables ?

static atomic_t rnd __read_mostly;

if (unlikely(!atomic_read(&rnd))) {
	unsigned int val;

	get_random_bytes(&val, sizeof(val));
	if (!val)
		val =3D 1;
	atomic_cmpxchg(&rnd, 0, val);
}


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
