From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 22:15:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226211545.GI15997@sunbeam.de.gnumonks.org>
References: <20030224051810.GB7523@pc.ilinx> <20030225044337.GA4113@pc.ilinx> <20030226174145.GN8883@sunbeam.de.gnumonks.org> <20030226204009.GA11142@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YQEH9CATo+4lan7A"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@interlinx.bc.ca
Content-Disposition: inline
In-Reply-To: <20030226204009.GA11142@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YQEH9CATo+4lan7A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2003 at 03:40:10PM -0500, netfilter@interlinx.bc.ca wrote:

> > > In any case, what makes me suspect that this is the wrong solution is
> > > that (back to the "use" counter) while the expectation does not seem
> > > to disappear on me (good) the use counter increments indefinately.  It
> > > is at:
> >=20
> > if you increment the use counter,
>=20
> I am not touching the counter, myself.  However, every time I repost
> the expectation with:
>=20
> static int gnutella_expectfn(struct ip_conntrack *ct)
> {
>=20
>     struct ip_conntrack *master;
>     master =3D master_ct(ct);
>     if (!master) {
>         DEBUGP(" no master!!!\n");
>         return 0;
>     }
>=20
>     ip_conntrack_expect_related(master, ct->master);
>=20
>     return 0;
> }

This was not what I was thinking about. You would try to put the same
struct onto the list again.  Bad things will happen.  You will need to
allocate a new struct ip_conntrack_expect, initialize it with tuple/mask
and then call expect_related on this newly-allocated struct.

I did mean 'the same expectation' on a logical level, not 'the same
piece of memory representing the expectation'.

> > the structure will never be deleted
> > from kernel memory and you will run out of memory.
>=20
> If I can trust that it's freed from kernel memory when it disappears
> in /proc/net/ip_conntrack,=20

No, please look at the code.  /proc/ip_conntrack lists _unfulfilled_
expectations.  once the 'slave' connection arrives and fulfills the
expectation, it will no longer appear in /proc/net/ip_conntrack.

In fact the structure will be allocated until the slave struct
ip_conntrack dies (and thus drops the 'use' count of the master struct=20
ip_conntrack_expect.

I've tried to describe this in documentation/newnat-summary.txt.

> b.
> Brian J. Murrell

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YQEH9CATo+4lan7A
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XS6BXaXGVTD0i/8RAjo2AJ9iGkMDb9lwzSy4iHnFSxvt1BYHyACgkrgR
aNwPabDRyMQJLAtCC/7+Mqo=
=iu8a
-----END PGP SIGNATURE-----

--YQEH9CATo+4lan7A--
