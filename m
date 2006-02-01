From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink expect dumping bug
Date: Wed, 1 Feb 2006 10:10:28 +0100
Message-ID: <20060201091028.GB31060@sunbeam.de.gnumonks.org>
References: <20060129180700.GA5490@rama.intranet.astaro.de>
	<43E01980.6090506@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43E01980.6090506@eurodev.net>
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


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2006 at 03:14:24AM +0100, Pablo Neira Ayuso wrote:

> > From looking at the code, it seems the bug also exists in
> > ip_conntrack_netlink, but I didn't really test it.
>=20
> No problem, ip_conntrack doesn't have the l3num field.

the same problem exists with the 'proto' field.

> > Pablo, would you please prepare a fix for this, and confirm it by having
> > helpers create expectations inside the kernel while running 'conntrack
> > -E' ?
>=20
> I did, we're still discussing :). Anyway Patrick have workaround for
> this but it still remains a bit tricky. Please have a look at:

ok, I'll look at it.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD4HsEXaXGVTD0i/8RAm59AJ9A7KB02Z6kkyg/cprhmzbI+Cq3sQCfZbyM
HrlFuN3px4Z/1uOoOMLVX6M=
=dtu9
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
