From: Harald Welte <laforge@netfilter.org>
Subject: Re: Nat Code Confusion
Date: Tue, 24 Jun 2003 18:26:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624162612.GT2645@sunbeam.de.gnumonks.org>
References: <Sea2-F67MARCtZoFK8o000663ae@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ulNsWUvGrZAj8PMr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F67MARCtZoFK8o000663ae@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ulNsWUvGrZAj8PMr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2003 at 03:51:03AM +0000, Ricky Foo wrote:

> The confused one is back. As usual, a couple of grey areas:
>=20
> 1.  Under the data_fixup section for nat, e.g. amanda, there's this line:
>=20
>         newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
>=20
>     What's the rationale for selecting the direction to use?
>=20
> 2.  Under the nat_expected similar for amanda, the following lines:
>=20
> 	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
> 	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
>=20
>     Again, what's the rationale for selecting the direction and in each=
=20
> case, ct or master to use?

A connection tracking entry is directed, the same way the TCP/UDP
session was established (DIR_ORIGINAL is the direction of the first
packte in the connection).  =20

In the conntrack helper you need to carefully chose the right direction,
since the REPLY tuples get modified by the nat code.

> 3. Just a wild observation. Is the Harald the official spokesman for=20
> netfilter as it seems he's the only guy answering all the questions.

Well, it's not really true that I answer all questions.  I jus read
through this list every couple of days and catch up with all unreplied
stuff.

Answering to lots of questons on the mailinglists was one of the reasons
why I was invited to the coreteam some three years ago, so it seems to
be some kind of 'tradition'.

Apart from that, I'm the only core team member who gets (partially)
sponsored by a company to work on netfilter/iptables, so I'm likely to
have the most time of all of us to spend on the project.

> Ok, that's it.
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

--ulNsWUvGrZAj8PMr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++HukXaXGVTD0i/8RAsVXAJ9E598imMidJch0NCfecqvI1my+XgCfcj0I
F/jCxVJNsJDWWZQ9DlZ56y4=
=+Fzg
-----END PGP SIGNATURE-----

--ulNsWUvGrZAj8PMr--
