From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ip_nat_mangle_udp_packet() updated
Date: Fri, 18 Oct 2002 16:52:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021018145259.GK2408@naboo.club.berlin.ccc.de>
References: <20021017163909.GO344@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021017163909.GO344@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2002 at 12:39:09PM -0400, netfilter@interlinx.bc.ca wrote:
> Hello Harald and all.
>=20
> Find attached an updated patch for my ip_nat_mangle_udp_packet().
> This function no longer gratuitously checkums the mangled UDP packet.
> It only calculated a UDP checksum when the pre-mangling checksum is
> non-zero.  It still pushes the packet up for IP checksum however.  I
> believe this to be the correct way to do this.

This patch looks fine to me. I will put it into the pending repository
of patch-o-matic.

> Thanx,

Thank you!

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9sCBLXaXGVTD0i/8RAp79AKCKwfaEo8G0QDApiFFTqGX8ohnIaQCgskp5
jMVRo+VOrUxsdpXDF6wWCvI=
=RCAb
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
