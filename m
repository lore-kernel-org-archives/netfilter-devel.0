From: Harald Welte <laforge@gnumonks.org>
Subject: Re: problem compiling using uclibc
Date: Wed, 30 Oct 2002 09:36:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030093637.J8635@sunbeam.de.gnumonks.org>
References: <1035155254.3db33736a41e5@horde.survion.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LsnByradU3Ze6UwI"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: g_braad@survion.com
Content-Disposition: inline
In-Reply-To: <1035155254.3db33736a41e5@horde.survion.com>; from g_braad@survion.com on Mon, Oct 21, 2002 at 01:07:34AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LsnByradU3Ze6UwI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2002 at 01:07:34AM +0200, g_braad@survion.com wrote:
> Hello,
>=20
>=20
> i'm trying to build iptables against uclibc for use on a very small syste=
m.
> I'm using the 2.4.7 kernel.

you are using the 2.4.7 kernel and some patches (like the ipt_conntrack stu=
ff)
which is not supported in those old kernels.

I doubt that your problem is related to ulibc at all.

Try

a) building against glibc, just for testing
b) using a plain 2.4.7 kernel and iptables-ulibc
c) using a later kernel and iptables-ulibc

> Gerard

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--LsnByradU3Ze6UwI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5oUXaXGVTD0i/8RAq1sAJ9omA3eYcTznU54dfeYLWCwUJufdACfReor
JYmtOLo1yb22h9hOSt2iwlE=
=MWkT
-----END PGP SIGNATURE-----

--LsnByradU3Ze6UwI--
