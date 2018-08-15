From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the
 netfilter tree
Date: Thu, 16 Aug 2018 09:47:23 +1000
Message-ID: <20180816094723.07452406@canb.auug.org.au>
References: <20180807124932.73422224@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g0YZMO5jvaCY_ec_kDH7s38"; protocol="application/pgp-signature"
Cc: David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>, Julian Anastasov <ja@ssi.bg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807124932.73422224@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/g0YZMO5jvaCY_ec_kDH7s38
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 7 Aug 2018 12:49:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   net/netfilter/ipvs/ip_vs_conn.c
>=20
> between commit:
>=20
>   16e98cec49a4 ("ipvs: don't show negative times in ip_vs_conn")
>=20
> from the netfilter tree and commit:
>=20
>   ec1b28ca9674 ("ipvs: provide just conn to ip_vs_state_name")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc net/netfilter/ipvs/ip_vs_conn.c
> index 615286dcf4c0,0edc62910ebf..000000000000
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@@ -1107,10 -1122,8 +1122,10 @@@ static int ip_vs_conn_seq_show(struct s
>   				&cp->caddr.in6, ntohs(cp->cport),
>   				&cp->vaddr.in6, ntohs(cp->vport),
>   				dbuf, ntohs(cp->dport),
> - 				ip_vs_state_name(cp->protocol, cp->state),
> + 				ip_vs_state_name(cp),
>  -				(cp->timer.expires-jiffies)/HZ, pe_data);
>  +				jiffies_delta_to_msecs(cp->timer.expires -
>  +						       jiffies) / 1000,
>  +				pe_data);
>   		else
>   #endif
>   			seq_printf(seq,
> @@@ -1120,10 -1133,8 +1135,10 @@@
>   				ntohl(cp->caddr.ip), ntohs(cp->cport),
>   				ntohl(cp->vaddr.ip), ntohs(cp->vport),
>   				dbuf, ntohs(cp->dport),
> - 				ip_vs_state_name(cp->protocol, cp->state),
> + 				ip_vs_state_name(cp),
>  -				(cp->timer.expires-jiffies)/HZ, pe_data);
>  +				jiffies_delta_to_msecs(cp->timer.expires -
>  +						       jiffies) / 1000,
>  +				pe_data);
>   	}
>   	return 0;
>   }
> @@@ -1173,10 -1184,9 +1188,10 @@@ static int ip_vs_conn_sync_seq_show(str
>   				&cp->caddr.in6, ntohs(cp->cport),
>   				&cp->vaddr.in6, ntohs(cp->vport),
>   				dbuf, ntohs(cp->dport),
> - 				ip_vs_state_name(cp->protocol, cp->state),
> + 				ip_vs_state_name(cp),
>   				ip_vs_origin_name(cp->flags),
>  -				(cp->timer.expires-jiffies)/HZ);
>  +				jiffies_delta_to_msecs(cp->timer.expires -
>  +						       jiffies) / 1000);
>   		else
>   #endif
>   			seq_printf(seq,
> @@@ -1186,10 -1196,9 +1201,10 @@@
>   				ntohl(cp->caddr.ip), ntohs(cp->cport),
>   				ntohl(cp->vaddr.ip), ntohs(cp->vport),
>   				dbuf, ntohs(cp->dport),
> - 				ip_vs_state_name(cp->protocol, cp->state),
> + 				ip_vs_state_name(cp),
>   				ip_vs_origin_name(cp->flags),
>  -				(cp->timer.expires-jiffies)/HZ);
>  +				jiffies_delta_to_msecs(cp->timer.expires -
>  +						       jiffies) / 1000);
>   	}
>   	return 0;
>   }

This is now a conflict between Linus' tree and the netfilter tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/g0YZMO5jvaCY_ec_kDH7s38
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlt0u4sACgkQAVBC80lX
0Gxa/ggAiYjYiiKScMfhGCtvWCIDZ/4e9xlpIa0XAxGvaGRtuc/WXC0D/+bFXFkf
ArQqXC/cni5NLfPckJBSy0QqP0D9m+74bVFf6tB7rq4XV/PVvj1UlotTl6PIfQXo
prnqqA7hqDSN8QignxF+n8D8SuRSr7kwavBl/RdlcCrLFzkVJWRp/yO/YdpWxhgG
fYg9O1XtCr3kagGquSZl8sn/wmsTHIfnuAeXMQCuBflQTByicsbBuSOrkupDnHCr
76ePXH5FUDQeJNPFROjbFrMyoFoUqCoqJ0lkK6duEcmql7V2QkyA2sUkyfE7nJFr
QIjjkFTjS45uJ9a3xC66FMcOZy+q9w==
=VZut
-----END PGP SIGNATURE-----

--Sig_/g0YZMO5jvaCY_ec_kDH7s38--
