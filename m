From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Debian Bug#218837] limit match not working on sparc64
Date: Fri, 7 Nov 2003 14:54:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107135404.GL5741@sunbeam.de.gnumonks.org>
References: <20031106160055.GA25555@absolom.libra.net> <20031107000324.GC5741@sunbeam.de.gnumonks.org> <20031107014425.GB10258@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DMLl6fZPX8o7hGmc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Marshall <tommy@home.tig-grr.com>
Content-Disposition: inline
In-Reply-To: <20031107014425.GB10258@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DMLl6fZPX8o7hGmc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2003 at 05:44:25PM -0800, Tom Marshall wrote:
> On Fri, Nov 07, 2003 at 01:03:24AM +0100, Harald Welte wrote:
> > On Thu, Nov 06, 2003 at 11:00:56AM -0500, Laurence J. Lane wrote:
> > > I received a bug report [0] regarding the limit match not working
> > > on sparc64 with kernel 2.4.22. It references an earlier report [1]
> > > of the problem on this list. Harald Welete commented on it [2] and
> > > asked for additional information, but there is no clear resolution.
> > >=20
> > > Anyone?
> >=20
> > this is most likely never going to get fixed.   the problem is that the
> > limit match does an ugly hack: it stores a pointer in it's struct
> > matchinfo.  That pointer is 64bits in the kernel, but userspace is
> > 32bits, and thus the compilar only allocates 32bit for the pointer in
> > the structure: boom.
>=20
> Just a random thought -- is an intptr_t the same between kernel and userl=
and
> on all architectures?

I don't think so.   Actually, the processor is running in a different
mode, so it an integer pointer in user space should never be 64bits
wide.

we also cannot change the structure definition in a way that renders it
incompatible on other architectures.

Since the limit match is not a particularly useful or important piece of
iptables, I never though of it as a too important issue.  It'll be
solved with the mythical pkttables in 2.7.x ;)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DMLl6fZPX8o7hGmc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/q6P8XaXGVTD0i/8RAldlAKCjSgnRqoGY2VRIsXFOhOyTvmP0NACgjWcc
bFOShhbYNWShekvUgpQoXKQ=
=WtGw
-----END PGP SIGNATURE-----

--DMLl6fZPX8o7hGmc--
