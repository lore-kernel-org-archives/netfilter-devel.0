From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Thu, 10 Apr 2008 06:56:48 +0200
Message-ID: <20080410045648.GA5526@bayen.regit.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr> <47F79683.8070801@netfilter.org> <20080405191512.GJ5333@bayen.regit.org> <47FAB4C4.8050908@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:34560 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDJE44 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 00:56:56 -0400
Content-Disposition: inline
In-Reply-To: <47FAB4C4.8050908@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tuesday, 2008 April  8 at  1:56:52 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > On Saturday, 2008 April  5 at 17:10:59 +0200, Pablo Neira Ayuso wrote:
> >> Eric Leblond wrote:
> >>> This patch adds support for "state" option to the NFLOG plugin. For e=
xample, it
> >>> can be used by another module to determine if the packet has been dro=
pped,
> >>> rejected or accepted.
> >> What is the exact purpose of the "state" option? The use of the term
> >> "state" for this seems to me a bit confusing as users may think that it
> >>  is related with "stateful filtering". Please, develop the idea a bit =
more.
> >=20
> > Hmm, you are quiet right, 'state' may be a bad choice. In fact, the ide=
a is to
> > be able to give a context relative to the logging. For example, I
> > planned to use it with:
> >  if state =3D 0 then packet has been dropped (typical -j NFLOG followed=
 by -j DROP)
> >  if state =3D 1 then this is -j NFLOG followed by -j ACCEPT
> > With that usage choice, the word 'decision' would be better than 'state=
'.
> >=20
> > I think other people may think to other usage. For example, it could be
> > used to indicate the severity of the logged "attack". In this case, the
> > 'decision' keyword is not really a good choice.
>=20
> I see, however, why isn't --nflog-prefix enough to label the logs from
> iptables?

Yes, but it forces user to define a system to be able to know if
decision is DROP or ACCEPT. For example, all prefix have to be labelled
like [DA]:$MYSTRING. Well, it works but it overload prefix which is less
human readable. Furthermore, it steals some bits in the prefix field
which is in ULOG rather small.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/Z4QnxA7CdMWjzIRAoIDAJ9dJvU676UMCo9yc2nm7tyGx2x5GQCdF9X5
xaLFSXxKZAotxvEpMtGQUa4=
=ItaM
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
