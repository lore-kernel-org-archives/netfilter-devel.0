From: Harald Welte <laforge@netfilter.org>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Thu, 19 Aug 2004 12:55:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819105533.GI3921@sunbeam.de.gnumonks.org>
References: <E1BwO5M-000718-NF@giant.mindlink.net> <1092692707.22731.1687.camel@marx.mindlink.net> <41213777.9050701@trash.net> <1092703243.22731.1778.camel@marx.mindlink.net> <4121E082.6050602@trash.net> <1092775215.22731.1958.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uBaQ+BsiqpBBIRFI"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>
Content-Disposition: inline
In-Reply-To: <1092775215.22731.1958.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--uBaQ+BsiqpBBIRFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2004 at 01:40:15PM -0700, Matt Walters wrote:
> Thanks Patrick-
>=20
> 	A quick test shows that unaltered packets being passed back from
> userspace no longer cause kernel panics (yay) but also that they are not
> being responded to (boo).  I'll have a look deeper into it later on.

Patrkick, do you think we should push your make_writable fix to davem
yet?

> -Matt

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--uBaQ+BsiqpBBIRFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJIclXaXGVTD0i/8RAh/EAJwNc83R4cL566H236xZ4LDva/W83wCgq/mx
7aDY5PSjASuE3/VBIsR6PNk=
=DLP9
-----END PGP SIGNATURE-----

--uBaQ+BsiqpBBIRFI--
