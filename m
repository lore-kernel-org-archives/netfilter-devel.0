From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Sat, 11 Jan 2003 20:16:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030111191647.GD24488@naboo.de.gnumonks.org>
References: <3E1D7419.1060502@fugmann.dhs.org> <20030110140024.GU1353@sunbeam.de.gnumonks.org> <3E1EE68C.7030004@fugmann.dhs.org> <3E1EF712.8000100@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1EF712.8000100@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2003 at 05:38:42PM +0100, Anders Fugmann wrote:
> Looking at bit further, this seems non-trivial as I guess that the=20
> userspace should compile no matter kernel-headers version - no?

yes, exactly. This would be the ideal case.

If this is not possible (or at least not feasible), we have a set of
kernel headers inside the iptables package itself.
(CVS:userspace/include/linux/...)

The current include path order makes 'real' kernel headers precede the
iptables-supplied headers.  If necessarry, we could change this order,
making the iptables-supplied headers precede.

> Are defines tolerated? Something like:
> #define MARK_BITOPS
>=20
> and then in the userspace do a:
> #ifdef MARK_BITOPS
> Whenever the new fileds in the structure is used.

I don't understand how this could solve the problem.  #defines are about
compile time.  We need one runtime iptables that copes with old and new
kernels (and vice-versa).

> But IMHO this clutters the code up and I would rather avoid that.
> Do you know of modules that had the same problem, or do you regard it as=
=20
> unresolvable to add an extra field to a structure in the stable series?

We have quite a couple of other cases where we have the same problem -
without any solution :((  But during a stable kernel series, we cannot
put compatibility aside.  People are not supposed to upgrade their
iptables after they upgraded their kernel...

> Regards
> Anders Fugmann

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

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD4DBQE+IG2fXaXGVTD0i/8RAuybAJ9h9qo5fjks+q2Pnn2TUj63q4D2jQCWIVdJ
qLEZ0EW459Woq+Ft8roOkQ==
=rbVD
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
