From: Harald Welte <laforge@netfilter.org>
Subject: Re: patch-o-matic updated
Date: Sun, 13 Apr 2003 18:17:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413161709.GU1922@sunbeam.de.gnumonks.org>
References: <1049730816.26440.150.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vIXBmblrD40XNCy4"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1049730816.26440.150.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vIXBmblrD40XNCy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 07, 2003 at 05:53:36PM +0200, Martin Josefsson wrote:
> Hi all,
>=20
> Now patch-o-matic has support for dependencies thanks to Jozsef,
> great work!
>=20
>=20
> Modifications I've done:
> [..]

thanks a lot.

However, before we do more and more of this complicated (and IMHO evil)
shell scripting: is anybody considering a clean reimplementation in
perl?

> All changes are in cvs and they _seem_ to work just fine. Can some
> people please grab p-o-m from cvs and try applying all the patches you
> usually use and report success or failure to me?

I'm planning to release a new version of the patch-o-matic package soon.
Please inform me if there are any known problems with your changes.

> I've started working a little on a script to test p-o-m and report any
> failures with diffrent patch combinations. I have the easy stuff
> finished, will work a bit more on it before I release it.

great.  I hope we then can also test if the p-o-m applies against a
given set of kernel versions (i.e. 2.4.18 to 2.4.20-pre7) in an
automatic manner.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vIXBmblrD40XNCy4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mY2FXaXGVTD0i/8RArtWAJkBCgCtb13jkfIsCCKe5/0qrkTbwwCgnaTu
0ztkoUqhodB0L6gmg6f7ZEA=
=QqTW
-----END PGP SIGNATURE-----

--vIXBmblrD40XNCy4--
