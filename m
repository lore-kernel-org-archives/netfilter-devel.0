From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
	[nf|ct]netlink and event API]
Date: Mon, 11 Jul 2005 19:11:16 +0200
Message-ID: <20050711171116.GH16728@sunbeam.de.gnumonks.org>
References: <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net> <42C426B2.6030907@eurodev.net>
	<42D29EC0.9050707@ufomechanic.net>
	<Pine.LNX.4.61.0507111849360.28440@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg/E/yN4pR4or5qL"
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507111849360.28440@yvahk01.tjqt.qr>
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


--bg/E/yN4pR4or5qL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2005 at 06:50:20PM +0200, Jan Engelhardt wrote:
> >I'm interested in adding MAC addr attributes and CTA_TUPLE_MAC; not just
> >because of my fixation with MAC addresses but also to use conntrack to
> >record flow data for non IP-related protocols.
>=20
> Can't this be done with ebtables?
>=20
> On another note, how about bringing ebt and ipt closer together, maybe me=
rge=20
> them?

yes, the good old pkttables idea.  Unfortunately the ever growing number
of gpl infringing companies keeps me from tackling this rater large
project :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bg/E/yN4pR4or5qL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0qg0XaXGVTD0i/8RAnkLAJ9SllL308U9o/zMaXKhWonOm6nf5wCdF+Sf
2iN1ucHUtqn5fF86AFcI4BA=
=U2pm
-----END PGP SIGNATURE-----

--bg/E/yN4pR4or5qL--
