From: Harald Welte <laforge@netfilter.org>
Subject: Re: [FWD][PATCH] ip6t-align
Date: Fri, 23 May 2003 22:26:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523202652.GX3077@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44L.0305191645580.32612-100000@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v6YRErhBvjoBjrPV"
Cc: netfilter-devel@lists.netfilter.org, Jakub Bogusz <qboosh@pld.org.pl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech Sas Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0305191645580.32612-100000@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--v6YRErhBvjoBjrPV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2003 at 04:47:59PM +0200, Wojciech Sas Cieciwa wrote:
> Hi,
>=20
> This is patch from my friend.

Hi, thanks a lot for this patch.

> but it's simpler to use gcc's aligned attribute through
> ____cacheline_aligned macro (just like in ipt_table_info struct in
> ip_tables module for ipv4/netfilter).

exactly.  I think somebody fixed this for ipv4, but forgot about ipv6 :(

I will put this into patch-o-matic/pending.

Thanks again.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--v6YRErhBvjoBjrPV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zoQMXaXGVTD0i/8RApj2AJ47xB6cQNjxVXJ2fllpWSDRXPe3nwCdFCNN
lIadQ7pj+IugXt2E71eLEzo=
=PyAX
-----END PGP SIGNATURE-----

--v6YRErhBvjoBjrPV--
