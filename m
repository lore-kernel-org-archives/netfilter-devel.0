From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp-conntrack-nat: ip_nat_proto_gre.c:gre_manip_pkt: can't nat
	GRE w/o key
Date: Mon, 4 Apr 2005 11:08:50 +0200
Message-ID: <20050404090850.GP9155@sunbeam.de.gnumonks.org>
References: <222203005.20050403135647@stud.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNpeiK4tTqhYOExY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Content-Disposition: inline
In-Reply-To: <222203005.20050403135647@stud.tue.nl>
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


--PNpeiK4tTqhYOExY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 03, 2005 at 01:56:47PM +0200, Sander Eikelenboom wrote:
> It seems pptp code is working now with 2.6.10, now the gre code needs some
> tweaks.=20

please see my reply in bugzilla at
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D319

Can you please test and report back? Thanks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PNpeiK4tTqhYOExY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCUQQiXaXGVTD0i/8RAqMEAKCTJxqSZ0QqNTrHEAdw/K95yHJiBgCgiZ+s
11VSC/GNh9wzOEYYfCKmLsQ=
=+yHG
-----END PGP SIGNATURE-----

--PNpeiK4tTqhYOExY--
