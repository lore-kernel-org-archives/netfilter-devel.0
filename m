From: Harald Welte <laforge@netfilter.org>
Subject: Re: possible ipt_MASQUERADE.c bug
Date: Thu, 19 Feb 2004 21:26:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219202622.GH4797@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com> <Pine.LNX.4.44.0402171613120.26321-100000@sillypoint.zayanionline.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vineet Mehta <extreme@zayanionline.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402171613120.26321-100000@sillypoint.zayanionline.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 04:19:35PM +0300, Vineet Mehta wrote:
> while working on Fedora kernel version 2.4.22-1.2115.nptl code i found ou=
t=20
> that one of the DEBUGP(...) statement had problem with variable name.

thanks, i'll submit this fix with the next set of patches.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANRvuXaXGVTD0i/8RAkhfAKCnQAg+Y6Nh9t9LXPzCH7T7KpeI/QCdGs1y
+5ocnK8fVW8qwpiCDmqZWmQ=
=2DY5
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
