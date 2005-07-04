From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip6tables: check for valid init prior to calling
Date: Mon, 4 Jul 2005 10:44:39 +0200
Message-ID: <20050704084439.GT3186@sunbeam.de.gnumonks.org>
References: <20050703170345.GA20892@linuxace.com>
	<42C8C122.40007@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4wKa0rmtotUGtIt6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <42C8C122.40007@outerspace.dyndns.org>
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


--4wKa0rmtotUGtIt6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2005 at 04:54:58AM +0000, Jonas Berlin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Quoting Phil Oester on 2005-07-03 17:03 UTC:
> > Unlike iptables, ip6tables does not check that match|target->init
> > is !NULL prior to calling, leading to problems in those extensions
> > which don't define init, like owner:
> >=20
> > # ip6tables -m owner
> > Segmentation fault
> >=20
> > The below patch copies iptables checks.
> >=20
> > Phil
>=20
> Hmm, I already fixed this three months ago :)

seems like we should be doing a 1.3.2 release.  So everyone who still
has pending bugs/issues with current svn iptables, please raise your
voice _now_.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4wKa0rmtotUGtIt6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCyPb3XaXGVTD0i/8RAuAeAJ9CvK9PlPsCeJ8x+kQVplozSJlzDwCfdrOp
5lwIDY3vd9yjK6shaOQOswY=
=u7ol
-----END PGP SIGNATURE-----

--4wKa0rmtotUGtIt6--
