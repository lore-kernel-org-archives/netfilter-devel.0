From: Harald Welte <laforge@netfilter.org>
Subject: Re: xdmcp nat module
Date: Wed, 28 Apr 2004 17:10:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040428151048.GI6345@sunbeam.de.gnumonks.org>
References: <1083160431.8039.3152.camel@TesterTop.tester.ca> <20040428140837.GG6345@sunbeam.de.gnumonks.org> <1083162239.8039.3156.camel@TesterTop.tester.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkqCAaSJIySsbD6j"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Olivier Crete <tester@tester.ca>
Content-Disposition: inline
In-Reply-To: <1083162239.8039.3156.camel@TesterTop.tester.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VkqCAaSJIySsbD6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2004 at 04:24:00PM +0200, Olivier Crete wrote:
> Hi,
>=20
> Is your 20020409 version the most recent? If not where I can find the
> author? Do I really need to patch the kernel sources? Also, is it hard
> to port it to a 2.6 kernel?

latest version at
http://cvs.netfilter.org/netfilter-extensions/helpers/xdmcp/

you can find the original author's email address in the source code.

Yes, porting it to 2.6.x without prior knowledge of conntrack helper
modules will be difficult.

> Olivier

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VkqCAaSJIySsbD6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAj8l4XaXGVTD0i/8RAvT1AKCidcb5CN4p9yMu5BpJYv/7D5QrPACdFSI/
oR9klmZe2vajqNvIN6Vzywk=
=DkYe
-----END PGP SIGNATURE-----

--VkqCAaSJIySsbD6j--
