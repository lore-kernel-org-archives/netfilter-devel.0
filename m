From: Harald Welte <laforge@gnumonks.org>
Subject: Re: xdmcp
Date: Sat, 9 Nov 2002 22:03:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021109210318.GA8951@naboo.de.gnumonks.org>
References: <E131E9F1848D0148813EAF06A846608FD776F0@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Cc: Min Li <li9@expert.ics.purdue.edu>, linux96@netsarang.com,
	netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sneppe Filip <Filip.Sneppe@cronos.be>
Content-Disposition: inline
In-Reply-To: <E131E9F1848D0148813EAF06A846608FD776F0@w2ks-e2k.iconos.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 09, 2002 at 02:35:42PM +0100, Sneppe Filip wrote:
> Hi Min,
>=20
> I think the problem is that the xdmcp protocol requires a special
> helper module to add the necessary connection expectations, since
> it appears to open random connections, like ftp for instance.

true.

> This raises an interesting question: Here:
> http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter-extensions/helpers/xdmc=
p/
> is some work on a conntrack helper/nat module by Hojae Lee, apparently.

yes. It is a module written by Hojae Lee, and while it apparently seems
to work, it raises a couple of fundamental security problems.

I didn't want to put this code in netfilter patch-o-matic, since it
definitely would introduce security vulnerabilities.

Unfortunately I didn't get around fixing that code yet, so it remains
unchanged in CVS for now.

> I've never heard any noise about this, the code is not available in
> standard patch-o-matic, and I am also wondering what the whole
> /netfilter-extensions CVS directory is all about ?
> Perhaps Harald knows more about this...

the netfilter-extensions CVS directory has been discussed on
netfilter-devel before.  The idea is to have the _real_ code in CVS, not
the patches.   From netfilter-extensions the patches are generated,
which will then be put into patch-o-matic.

CVS is meant for source code, not for patches.

> Regards,
> Filip

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

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9zXgWXaXGVTD0i/8RAhFJAJ95mNPTcOhwm1qeM8bFEegZyRnPgACgqiUL
mnj3vRFcMioSvCsHf4NcbKk=
=bWGa
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
