From: Harald Welte <laforge@gnumonks.org>
Subject: Re: problem with iplimit
Date: Wed, 30 Oct 2002 09:46:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030094636.O8635@sunbeam.de.gnumonks.org>
References: <03c501c27ad4$9e5ac740$060110ac@localdomain> <Pine.LNX.4.43.0210261122460.1050-100000@nuhkija.sise>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oqiVxqbeHx5cy56u"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Romp <romp@siil.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.43.0210261122460.1050-100000@nuhkija.sise>; from romp@siil.net on Sat, Oct 26, 2002 at 11:26:53AM +0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oqiVxqbeHx5cy56u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2002 at 11:26:53AM +0300, Romp wrote:
> > The problem appears every time I try to use this module.
> > if I set --limit-above to 2 and try to open third connection, system wi=
ll drop it (ok).
> > But if I try to open this connection again (while previous 2 connection=
s are still active), system will accept it (!).
> > Since, almost every connection will be accepted (!).
> > Note that if I close all connections, and try to make described test ag=
ain, all will happen again.
> >
>=20
> the problem (and fix) is also described at
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-May/007818.html

interesting. I will add this issue to the TODO list.

> unfortunately, the patch provided does not solve the problem (at least for
> me)

even more interesting...

I have some higher-priority stuff to do right now, but I will try to get
back to this issue ASAP.

> romp

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--oqiVxqbeHx5cy56u
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5xsXaXGVTD0i/8RAoVcAJ9Y4ePc4I2r522WCINzhXm/qj86PgCffaDJ
dOj2qt8UYSLweXxzDbNz/78=
=Ff82
-----END PGP SIGNATURE-----

--oqiVxqbeHx5cy56u--
