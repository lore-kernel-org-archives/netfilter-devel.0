From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 3/3] netfilter: sysctl support of logger choice.
Date: Wed, 18 Mar 2009 00:15:56 +0100
Message-ID: <1237331756.2708.41.camel@ice-age>
References: <499DD499.50704@inl.fr>
	 <1235080458-6623-3-git-send-email-eric@inl.fr> <49BE5B1A.6040407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xbKSLiOrE/myrhMjDPoU"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:41122 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZCQXZh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:25:37 -0400
In-Reply-To: <49BE5B1A.6040407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-xbKSLiOrE/myrhMjDPoU
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 16 mars 2009 =E0 14:58 +0100, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > +static int netfilter_log_sysctl_init(void)
> > +{
> > +	int i;
> > +
> > +	for (i =3D NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
> > +		char *pr_name =3D kmalloc(3, GFP_KERNEL);
>=20
> This needs to check for allocation errors.
>=20
> > +		/* FIXME free at deinit but there is currently no deinit */
>=20
> And this needs to be fixed as well. If you want to simplify this, I'd
> suggest to just use static storage.

Thanks for your remarks and your patience, updated patch will follow
this mail.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-xbKSLiOrE/myrhMjDPoU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJwC8onxA7CdMWjzIRAoYbAJsH1pTib64hQcYNU9yPuy/sP+fayQCfQmux
u8kUK5EuWQ21UC6GCE1Amnc=
=/Gsf
-----END PGP SIGNATURE-----

--=-xbKSLiOrE/myrhMjDPoU--

