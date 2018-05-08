From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the netfilter-next
 tree
Date: Tue, 8 May 2018 10:21:01 +1000
Message-ID: <20180508102101.768d5c52@canb.auug.org.au>
References: <20180507105519.1d34f19e@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/DRyahoiRLh3pKKmFXe7CPkb"; protocol="application/pgp-signature"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507105519.1d34f19e@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/DRyahoiRLh3pKKmFXe7CPkb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 7 May 2018 10:55:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the netfilter-next tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> ./usr/include/linux/netfilter/nf_osf.h:25: found __[us]{8,16,32,64} type =
without #include <linux/types.h>
>=20
> Introduced by commit
>=20
>   bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure=
 from xt_osf")

This warning now occurs after the merge of the net-next tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/DRyahoiRLh3pKKmFXe7CPkb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrw7W0ACgkQAVBC80lX
0Gx8WwgAoQEm9540+l+yDdKza3hAvDXzRRnaA5Ie/W9ttfsz2xjbBgrV3nax1pZq
tfi5UmrnoBicN9bpCCQ8AWFXQhqim5KhePVU3LfCCyHSwcOlJbOSnda6aAQxVrhN
3LdEWFbLdQilRpJb7+FbacLmLTbU3y6vbwMe13pemB+m/F9lLH+sLdXBjW7ADWv5
/ZDI3TJ40ynmjBGOfjJHTuQaKktZDNuDQXOMcoOz110jK4LU1y1LSV743iB3CnCD
DZD1h8+bqaCCELhhtFsY13p5ESjRPixh2wd+QIIlJ66emH3nWr7sDYKohFd/f2h6
2y3EXvPS03/Rj4K+SsAlte2/liiEpg==
=t49L
-----END PGP SIGNATURE-----

--Sig_/DRyahoiRLh3pKKmFXe7CPkb--
