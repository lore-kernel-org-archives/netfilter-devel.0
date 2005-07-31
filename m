From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.* [PATCH]
Date: Sun, 31 Jul 2005 08:48:21 +0200
Message-ID: <20050731064821.GC3835@rama.de.gnumonks.org>
References: <9927912d05072704113d7e8707@mail.gmail.com>
	<e756d62eb5442015@mayday.cix.co.uk>
	<20050729105834.GD7063@rama.de.gnumonks.org>
	<df9eaa1431a9e102@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
Content-Disposition: inline
In-Reply-To: <df9eaa1431a9e102@mayday.cix.co.uk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 30, 2005 at 08:12:31AM +0100, Robert de Bath wrote:

> >If the fix is non-intrusive and doesn't reaquire a lot of additional
> >computational complexity, I would accept such a patch.  Otherwise I
> >don't really think it's worth supporting such a setup.  Usually you have
> >one version of iptables installed, not multiple.
>=20
> <grin> The change was a _lot_ easier than I thought, looks like it's a
> real bug too. [attached]

thanks,
Committed revision 4207.

Unfortunately too late for 1.3.3 :(
I don't think it's serious enough to justify an early 1.3.4 release.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7HQ0XaXGVTD0i/8RAmEoAJ9y1+80jWykll2DWtyisTabN8PkugCeOsak
kMEs1MRGtqLQQk4DCzpsLKI=
=6vdS
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
