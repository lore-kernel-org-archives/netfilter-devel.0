From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH 1/4] RFC: fast string matching infrastrure for netfilter
Date: Mon, 10 Jan 2005 09:49:39 +0100
Message-ID: <20050110084939.GA11194@zion.homelinux.com>
References: <41E1AECD.6020209@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41E1AECD.6020209@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Pablo,

On Sun, Jan 09, 2005 at 11:23:09PM +0100, Pablo Neira told us:
> --- /dev/null	2004-09-23 01:18:13.000000000 +0200
> +++ linux-2.5/net/ipv4/netfilter/nf_string_match.c	2005-01-09 21:54:04.00=
0000000 +0100
=2E...
> +struct nf_string_match *
> +nf_string_match_create(const char *pat, int patlen)
> +{
> +	struct nf_string_match *sm;
> +
> +	sm =3D kmalloc(sizeof(struct nf_string_match), GFP_KERNEL);
> +	if (!sm)
> +		return NULL;
> +	memset(sm, 0, sizeof(struct nf_string_match));
> +
> +	sm->goodshift =3D (int *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
> +	if (!sm->goodshift)
> +		return NULL;
> +	memset(sm->goodshift, 0, sizeof(int) * patlen);
> +=09
> +	sm->pat =3D (char *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
> +	if (!sm->pat) {
> +		kfree(sm->goodshift);
> +		return NULL;
> +	}
> +	memset(sm->pat, patlen, sizeof(char) * patlen);

is there any intention behind kmalloc()ing the pattern using sizeof(int)
and then memset()ting it using sizeof(char)?


Sven

> +=09
> +	strcpy(sm->pat, pat);
> +	sm->patlen =3D patlen;
> +
> +	/* Preprocess the pattern */
> +	sm_preprocess(sm);
> +
> +	return sm;
> +}
> +

--=20
Linux zion 2.6.10-bk7 #0 Fri Jan 7 19:08:39 CET 2005 i686 athlon i386 GNU/L=
inux
 09:42:02 up 2 days, 14:19,  1 user,  load average: 0.09, 0.08, 0.03

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFB4kGjo4FAdB2PneQRAg4mAJ0Un3xI4njBAXhZYsynF/J8K04uoACcDNLg
N9R6chPLyUJuErjH5GfBDoI=
=t5Mc
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
