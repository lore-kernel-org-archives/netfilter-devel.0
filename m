From: Harald Welte <laforge@netfilter.org>
Subject: Re: Conntrack Entries
Date: Fri, 13 Jun 2003 17:19:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030613151957.GF32593@sunbeam.de.gnumonks.org>
References: <Sea2-F465SpDz9vUkUq0000c036@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ewN61DNRuNLc83n"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F465SpDz9vUkUq0000c036@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4ewN61DNRuNLc83n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 08:45:01AM +0000, Ricky Foo wrote:
> Hi all,
>=20
> I have written a netbios conntrack module for port 139. However when I=20
> tested it, it shows several entries because the source port on my side=20
> keeps changing.....e.g. 32900, then 32901, 32902.... in this case, there=
=20
> will be 3 lines as if there are 3 different connections are going on. Is=
=20
> this the correct expected behaviour or should they just go into 1 line?

I have no idea about the netbios protocol, so I don't know what the
expected behaviour is.  Is it really only one connection?  Then you
should probably make the 2nd an 3rd connection be siblings
(ip_conntrack_expect_related()) of the master connection. =20

> What does the "use" field mean?

It's an internal reference counter indicating how many other objects in
the kernel are still referencing this conntrack.

>    Ricky

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4ewN61DNRuNLc83n
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+6eudXaXGVTD0i/8RAn1dAJ4xwcVjT87m5CHC7jPMT7dRpr6lPACfSpRL
7rGlhDCxR7j0Nv+bnIJwB+o=
=gwwI
-----END PGP SIGNATURE-----

--4ewN61DNRuNLc83n--
