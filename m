From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MARK bit operations patch #2
Date: Tue, 14 Jan 2003 22:14:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030114211436.GL18686@sunbeam.de.gnumonks.org>
References: <3E240801.8080801@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuXIgs6JvY9hJs5C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E240801.8080801@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HuXIgs6JvY9hJs5C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2003 at 01:52:17PM +0100, Anders Fugmann wrote:
> Hi.
>=20
> I have tried to make the MARK target include
> two new operations '--or-mark' and '--and-mark'.
>=20
> The patch is compatible in the following ways:
>=20
> new kernel - old userspace: OK
> new kernel - old userspace: OK

twice the same?=20

> old kernel - new userspace: OK(*)
>=20
> * - Only if the new userspace is compiled against the old kernel.
>=20
> Please comment. I'm not use if the compatibility satifies the=20
> requirements needed for such a patch to go into the 2.4 series.

I think this is fine.  The major cases we have to think about are:

1) user updates kernel (new kernel, old userspace)
   The firewall should start up as expected without any changes in
   userspace

2) user has old kenel running and is updating iptables userspace
   In this case iptables userspace has to compile without any warnings.

> Attached: MARK_TARGET.patch - patch against 2.4 (applies to 2.5 aswell))
> Attached: MARK_operations.patch.userspace  - patch against iptables .1.2.=
7a)

Looks fine so far.  The only issue remaining is:

You are assuming that=20

IPT_ALIGN(sizeof(struct ipt_mark_target_info))=20
	!=3D IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info))

while this may be true on x86, I assume it is different on 64bit
plaforms. Do you have access to any ia64/sparc64/ppc64/mips64 machine
with linux?

> Regards
> Anders Fugmann

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--HuXIgs6JvY9hJs5C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JH28XaXGVTD0i/8RAqtKAJ9ip+HBiTYgs2lyf05enFjI2VeJMwCdGLrI
Wbh6WI0OTuynM29aKyzNHBY=
=FLdn
-----END PGP SIGNATURE-----

--HuXIgs6JvY9hJs5C--
