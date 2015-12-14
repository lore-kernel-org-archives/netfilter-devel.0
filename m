From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH -stable] netfilter: ipt_rpfilter: remove the nh_scope
 test in rpfilter_lookup_reverse
Date: Mon, 14 Dec 2015 17:12:56 +0000
Message-ID: <20151214171256.GD3120@ares>
References: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
 <1450095436-24855-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450095436-24855-4-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 14, 2015 at 01:17:14PM +0100, Pablo Neira Ayuso wrote:
> From: lucien <lucien.xin@gmail.com>
>=20
> [ upstream commit cc4998febd567d1c671684abce5595344bd4e8b2 ]
>=20
> --accept-local  option works for res.type =3D=3D RTN_LOCAL, which sho=
uld be
> from the local table, but there, the fib_info's nh->nh_scope =3D
> RT_SCOPE_NOWHERE ( > RT_SCOPE_HOST). in fib_create_info().
>=20
> 	if (cfg->fc_scope =3D=3D RT_SCOPE_HOST) {
> 		struct fib_nh *nh =3D fi->fib_nh;
>=20
> 		/* Local address is added. */
> 		if (nhs !=3D 1 || nh->nh_gw)
> 			goto err_inval;
> 		nh->nh_scope =3D RT_SCOPE_NOWHERE;   <=3D=3D=3D
> 		nh->nh_dev =3D dev_get_by_index(net, fi->fib_nh->nh_oif);
> 		err =3D -ENODEV;
> 		if (!nh->nh_dev)
> 			goto failure;
>=20
> but in our rpfilter_lookup_reverse():
>=20
> 	if (dev_match || flags & XT_RPFILTER_LOOSE)
> 		return FIB_RES_NH(res).nh_scope <=3D RT_SCOPE_HOST;
>=20
> if nh->nh_scope > RT_SCOPE_HOST, it will fail. --accept-local option
> will never be passed.
>=20
> it seems the test is bogus and can be removed to fix this issue.
>=20
> 	if (dev_match || flags & XT_RPFILTER_LOOSE)
> 		return FIB_RES_NH(res).nh_scope <=3D RT_SCOPE_HOST;
>=20
> ipv6 does not have this issue.
>=20
> Cc: <stable@vger.kernel.org> # 3.14.x
> Cc: <stable@vger.kernel.org> # 3.18.x
> Cc: <stable@vger.kernel.org> # 4.1.x
> Cc: <stable@vger.kernel.org> # 4.2.x

Thanks, I'm queuing this one and the next 2 to the 3.16 kernel as well
(some of the other patches had already been included).

Cheers,
--
Lu=EDs


> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/ipv4/netfilter/ipt_rpfilter.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/i=
pt_rpfilter.c
> index 8618fd1..c4ffc9d 100644
> --- a/net/ipv4/netfilter/ipt_rpfilter.c
> +++ b/net/ipv4/netfilter/ipt_rpfilter.c
> @@ -61,9 +61,7 @@ static bool rpfilter_lookup_reverse(struct flowi4 *=
fl4,
>  	if (FIB_RES_DEV(res) =3D=3D dev)
>  		dev_match =3D true;
>  #endif
> -	if (dev_match || flags & XT_RPFILTER_LOOSE)
> -		return FIB_RES_NH(res).nh_scope <=3D RT_SCOPE_HOST;
> -	return dev_match;
> +	return dev_match || flags & XT_RPFILTER_LOOSE;
>  }
> =20
>  static bool rpfilter_is_local(const struct sk_buff *skb)
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
