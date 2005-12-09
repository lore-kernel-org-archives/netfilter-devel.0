From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip_nat_tftp: Fix expectation NAT.
Date: Fri, 9 Dec 2005 10:25:20 +0530
Message-ID: <20051209045520.GB4244@rama.exocore.com>
References: <43980FAA.6060608@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <43980FAA.6060608@ingate.com>
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


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2005 at 11:49:14AM +0100, Marcus Sundberg wrote:
> Hi,
>=20
> this patch fixes the case where the port in an initial TFTP packet
> is SNATed. Previously the port was never DNATed back for the expected
> connection.

Thanks!

This is one of the cases where I'd really appreciate having a nfsim
test for the testsuite to=20
1) help understanding the problem
2) prevent further regressions

Would you be willing to provide us with a testcase for nfsim-testsuite?
Unfortunately we cannot offer anything but bonus points ;)

Patrick: I'm still not back from Bangalore, so I'm still relying on you
picking up all the patches ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDmQ44XaXGVTD0i/8RAjMKAKCgDyc41jguoZV1Aq88i2KuOM9PiQCfY46v
ktsYA/UnE23TDEQI+5SWd74=
=HAd1
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
