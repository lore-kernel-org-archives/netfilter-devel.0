From: Harald Welte <laforge@netfilter.org>
Subject: use of vmalloc within netfilter (was Re: [ANNOUNCE] IP sets)
Date: Tue, 17 Feb 2004 15:18:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217141840.GJ981@sunbeam.de.gnumonks.org>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu> <20040217125710.GA981@sunbeam.de.gnumonks.org> <Pine.LNX.4.58.0402171449240.1089@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ztcJpsdPpsnnlAp8"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org, ak@suse.de
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402171449240.1089@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ztcJpsdPpsnnlAp8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Andi, to give us some clue ;)

On Tue, Feb 17, 2004 at 02:51:52PM +0100, Martin Josefsson wrote:
> On Tue, 17 Feb 2004, Harald Welte wrote:
>=20
> > I just added another use of vmalloc: dstlimit.  I have to fix that, too.
> >
> > It would be interesting though, to know how much of a performance
> > penalty it implies.
>=20
> According to Andi Kleen, some machines suffer from excessive TLB thrashing
> if you use vmalloc to allocate for example large arrays like the conntrack
> hashtable. I remember he said that the performance-problem got solved by
> using __get_free_pages() instead, that will only create one TLB-mapping
> for the entire thing iirc.

The question is:  Is the penalty only for allocationg of the memory
(then it would be no problem, since it's a one-time allocation when we
load the module).  If there also is a penalty during runtime (i.e.
accessing/updating the vmalloc'ed memory), we really should change our
code.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ztcJpsdPpsnnlAp8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMiLAXaXGVTD0i/8RAjeZAJ0RveowXqGxPfdHgdI3FZTW2beGLQCglKwE
QR7UwUoXW44oVbQS1JEaoLk=
=gDNE
-----END PGP SIGNATURE-----

--ztcJpsdPpsnnlAp8--
