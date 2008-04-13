From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Sun, 13 Apr 2008 09:03:25 +0200
Message-ID: <20080413070324.GK20469@bayen.regit.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr> <47F79683.8070801@netfilter.org> <20080405191512.GJ5333@bayen.regit.org> <47FAB4C4.8050908@netfilter.org> <20080410045648.GA5526@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:33650 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYDMHD3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:03:29 -0400
Content-Disposition: inline
In-Reply-To: <20080410045648.GA5526@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 April 10 at  6:56:48 +0200, Eric Leblond wrote:
> Hello,
>=20
> On Tuesday, 2008 April  8 at  1:56:52 +0200, Pablo Neira Ayuso wrote:
> > Eric Leblond wrote:
> > > On Saturday, 2008 April  5 at 17:10:59 +0200, Pablo Neira Ayuso wrote:
> > >> Eric Leblond wrote:
> > > 'decision' keyword is not really a good choice.
> >=20
> > I see, however, why isn't --nflog-prefix enough to label the logs from
> > iptables?
>=20
> Yes, but it forces user to define a system to be able to know if
> decision is DROP or ACCEPT. For example, all prefix have to be labelled
> like [DA]:$MYSTRING. Well, it works but it overload prefix which is less
> human readable. Furthermore, it steals some bits in the prefix field
> which is in ULOG rather small.

Not receiving a response to this mail make me thing about what I will
need to do to have the same feature without the 'state' flag:

A standard logging packet logging table contains packet that have been
dropped or accepted. One of the most relevant question for an
administrator is: "Which packet have been dropped with this criteria ?".
Thus, we need an easy and *fast* mean to differentiate dropped and
aceepted packet. IMHO, a 'state' flag is one of the easiest and cleanest
solution. The computation overload is really small compares to a parsing
of the prefix. Furthermore, this approach is not disruptive with
firewall rules generator who already have their log prefix.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAbA8nxA7CdMWjzIRAo6XAJ4k2eYq7D+YRzOglhjbBr8kIGHpVwCdFfBc
nPI/xdcHzJQlXMRy1pDteuY=
=gXD9
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
