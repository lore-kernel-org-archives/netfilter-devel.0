From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] trivial: fix email address in MODULE_AUTHOR
Date: Tue, 2 Sep 2003 21:43:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030902194330.GI1055@obroa-skai.de.gnumonks.org>
References: <20030830200504.GP17715@sunbeam.de.gnumonks.org> <20030902064215.B286E2C0C9@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QDd5rp1wjxlDmy9q"
Cc: David Miller <davem@redhat.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030902064215.B286E2C0C9@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QDd5rp1wjxlDmy9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2003 at 03:16:57PM +1000, Rusty Russell wrote:
> In message <20030830200504.GP17715@sunbeam.de.gnumonks.org> you write:
> > -MODULE_AUTHOR("Bart De Schuymer <bdschuy@pandora.be>");
> > +MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
> >  MODULE_DESCRIPTION("iptables bridge physical device match module");
>=20
> There's no MODULE_AUTHOR at all in my tree..

Then davem hasn't pushed that change to linus yet. (or your tree is not
based on linus' bk)

> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QDd5rp1wjxlDmy9q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/VPLhXaXGVTD0i/8RAn6DAJ0cOBE6aayefth6lFStRnulQ6N3TACfY/Dk
vj6XpdDie2H38CHoZ1jwtqk=
=ZmCT
-----END PGP SIGNATURE-----

--QDd5rp1wjxlDmy9q--
