From: Harald Welte <laforge@gnumonks.org>
Subject: Re: splitting the libs
Date: Thu, 5 Sep 2002 11:44:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905094453.GF1064@naboo.lincon.Uni-Koeln.DE>
References: <20020902202834.GB29667@vialibre.org.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Lenton <john@vialibre.org.ar>
Content-Disposition: inline
In-Reply-To: <20020902202834.GB29667@vialibre.org.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 02, 2002 at 05:28:35PM -0300, John Lenton wrote:
> I compiled netfilter 1.2.6a against uclibc, and I found that
> iptables, iptables-save and iptables-restore were all about the
> same size, and while ~300k for the three of them was more or less
> ok, 300k _each_ was out of the question. I looked a bit more and
> found I could split all the functionality into .so files, and
> have the same three binaries (plus these .sos) in the same size.
>=20
> Is there any reason this later config isn't done by default? or
> at last enableable via the makefile?

The reason is that nobody implemented it yet and send a non-intrusive
patch :)

So if you have done it, please contribute it!

> John Lenton (john@vialibre.org.ar) -- Random fortune:

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

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9dyeVXaXGVTD0i/8RAmb+AJ49E9sIZhcNxhhcJ5HrMs9ZJbfanQCglwhQ
507s6ZeqaZrFssME04P6Mdw=
=+hqP
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
