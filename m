From: Harald Welte <laforge@gnumonks.org>
Subject: Re: design-feature of nat?
Date: Sat, 2 Nov 2002 15:34:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102153451.N8635@sunbeam.de.gnumonks.org>
References: <200211012254.ERB510IOAA@gate.tbc.sub.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qPRehgwKaTVCe+gW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jb@is-kassel.de
Content-Disposition: inline
In-Reply-To: <200211012254.ERB510IOAA@gate.tbc.sub.de>; from jb@moenia.de on Fri, Nov 01, 2002 at 11:52:45PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qPRehgwKaTVCe+gW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2002 at 11:52:45PM +0100, juergen baumann wrote:

Hi Juergen.

> possible design-problem within snat.
>=20
> connecting with certain source-port to any destination.
> normal stop of this connection.
>=20
> establishing a snat-rule which replaces the address used by the connection
> before.
>=20
> conencting again with same source-port to same destination.
>=20
> neither the established snat-rule will be used, nor any further
> packet-counter will be increased.
>=20
> problem will not occure, if the corresponding conntrack-entry is deleted
> before.

I don't really understand the problem.  Are you talking about SNAT not
occurring as long as the old conntrack entry is still in TIME_WAIT state?

Please describe it a bit more verbose (you can also write directly to me
and use german language, if you want to).

> maybe you can fix a small bug in iptables-user, too:
>=20
> in iptables.c (iptables6.c)
>=20
> the long-option "rename-chain" should have a second arg of '1', not '2', =
or
> the option will fail.  short option 'E' does work normally.

thanks, fixed.

> greetings
> jb

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--qPRehgwKaTVCe+gW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9w+KLXaXGVTD0i/8RAhvNAJ0aPXXLy6j0DqA5eNtojn+AjRtlDACbBwYA
n6lps9HABEhwaTA3IsevdHE=
=lTB1
-----END PGP SIGNATURE-----

--qPRehgwKaTVCe+gW--
