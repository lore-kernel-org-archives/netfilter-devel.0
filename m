From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Sat, 5 Apr 2008 21:15:12 +0200
Message-ID: <20080405191512.GJ5333@bayen.regit.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr> <47F79683.8070801@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:40091 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYDETPQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:15:16 -0400
Content-Disposition: inline
In-Reply-To: <47F79683.8070801@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Saturday, 2008 April  5 at 17:10:59 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch adds support for "state" option to the NFLOG plugin. For exa=
mple, it
> > can be used by another module to determine if the packet has been dropp=
ed,
> > rejected or accepted.
>=20
> What is the exact purpose of the "state" option? The use of the term
> "state" for this seems to me a bit confusing as users may think that it
>  is related with "stateful filtering". Please, develop the idea a bit mor=
e.

Hmm, you are quiet right, 'state' may be a bad choice. In fact, the idea is=
 to
be able to give a context relative to the logging. For example, I
planned to use it with:
 if state =3D 0 then packet has been dropped (typical -j NFLOG followed by =
-j DROP)
 if state =3D 1 then this is -j NFLOG followed by -j ACCEPT
With that usage choice, the word 'decision' would be better than 'state'.

I think other people may think to other usage. For example, it could be
used to indicate the severity of the logged "attack". In this case, the
'decision' keyword is not really a good choice.

The only words that came to my mind and that would be better than
'state' are 'flag' or 'context' but you may have a better idea.

> I have kept back patches 8/14 to 13/14 until we end discussing this.
>=20
> > This patch also fixes a bug in definition of seq_global_ce macro.
>=20
> Please, split this into two patches next time as they are not related.

Ok.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH98/AnxA7CdMWjzIRAtO0AKCQ023w0tZ0oz/EoxPMkIPX9toJRwCghAqB
xfDv4WRYZmA0yt4GR9058Fg=
=fVLL
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--
