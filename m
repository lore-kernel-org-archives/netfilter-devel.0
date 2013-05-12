From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 21:34:28 +0200
Message-ID: <1368387268.22387.52.camel@ice-age.regit.org>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
	 <1368291713-40132-3-git-send-email-bootc@bootc.net>
	 <20130511192150.GA10646@localhost> <518EA9B3.8050606@bootc.net>
	 <20130512004852.GA11205@localhost> <518F4EC7.1050403@bootc.net>
	 <20130512093405.GA12095@localhost> <518F6306.2090007@bootc.net>
	 <20130512105004.GA13219@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fBCqb2Gp9LklbMpYQQ5d"
Cc: Chris Boot <bootc@bootc.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:41565 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3ELTeh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 15:34:37 -0400
In-Reply-To: <20130512105004.GA13219@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-fBCqb2Gp9LklbMpYQQ5d
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le dimanche 12 mai 2013 =E0 12:50 +0200, Pablo Neira Ayuso a =E9crit :
> On Sun, May 12, 2013 at 10:38:14AM +0100, Chris Boot wrote:
> > On 12/05/2013 10:34, Pablo Neira Ayuso wrote:
> > > Hi Chris,
> > >
> > > On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
> > >> On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> > >>> On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> > >>> [...]
> > >>>> Hi Pablo,
...
> You're right, I overlooked that.
>=20
> > > But anyway, I suggest that that the standalone debian installation
> > > sticks to one single instance at the same time, that's just fine for
> > > most people.
> >=20
> > The init script is indeed sticking to just one instance as-shipped.
>=20
> Assuming that, you'll have one single instance and pidof would be just
> fine. But I leave final decision to Eric.

This kind of code has already saved me some huge time in other projects
I've worked on (mainly when debugging or on quick install). Furthermore,
it is not painful to maintain once this is correctly done. When Chris
patch is in a correct state, I will apply it.


BR,
--
Eric Leblond <eric@regit.org>

--=-fBCqb2Gp9LklbMpYQQ5d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRj+7EnxA7CdMWjzIRAuTKAKCGpJ5lW5o3YE8hYIQKUl6yMAIGVACeJmz3
1hWINICxHXSWfPb4mnhcqwg=
=36dA
-----END PGP SIGNATURE-----

--=-fBCqb2Gp9LklbMpYQQ5d--

