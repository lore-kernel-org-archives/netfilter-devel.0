From: Harald Welte <laforge@netfilter.org>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Sat, 22 Jan 2005 00:33:28 +0100
Message-ID: <20050121233328.GU14460@sunbeam.de.gnumonks.org>
References: <200501220013.56429.sov.rbsec@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KS5V1uDxmEcBh2BA"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Oleg V. Sapon" <sov.rbsec@gmail.com>
Content-Disposition: inline
In-Reply-To: <200501220013.56429.sov.rbsec@gmail.com>
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


--KS5V1uDxmEcBh2BA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 22, 2005 at 12:13:56AM +0300, Oleg V. Sapon wrote:
>  Can you help locate unclean module for 2.6.x kernel or we must use
>  source files from 2.6.0-test4?

I fear nobody did that port to recent 2.6.x and put it into
patch-o-matic :(

I just did that with the old code from 2.6.0-testX.  I didn't have the
time to give it any runtime testing, but at least it compiled (after
fixing up some includes).

> 	Our company can test patches and even (if I can) sponsor this work.

Please test the code that is now (Version 3605) in patch-o-matic-ng.

> Oleg V. Sapon.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KS5V1uDxmEcBh2BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB8ZFIXaXGVTD0i/8RAvT2AKCrIT/yBDuhe93BQiIlJRZarpY7cQCgsXBs
N7KC6tf7NqglWt72r9vn/GU=
=fFQk
-----END PGP SIGNATURE-----

--KS5V1uDxmEcBh2BA--
