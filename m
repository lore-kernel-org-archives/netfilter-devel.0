From: Harald Welte <laforge@netfilter.org>
Subject: Re: can tcp stream reassembly be done in netfilter
Date: Sat, 30 Aug 2003 21:06:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830190613.GF17715@sunbeam.de.gnumonks.org>
References: <200308261011937.SM00856@zhengcb> <Pine.LNX.4.53.0308271030240.2748@oskar-lap.agatha>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MvEh5MSbieV/1Yst"
Cc: zhengchuanbo <zhengcb@netpower.com.cn>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Oskar Andreasson <blueflux@koffein.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0308271030240.2748@oskar-lap.agatha>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MvEh5MSbieV/1Yst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2003 at 10:35:10AM +0200, Oskar Andreasson wrote:
> On Tue, 26 Aug 2003, zhengchuanbo wrote:
>=20
> > 	Can netfilter do the tcp stream reassembly? I mean something like
> > what snort do in the stream process. I wish this could be done in the
> > kernel.
>=20
> No, netfilter is a packet filter. It works on a per packet basis, below
> the transport layer. Actually it does do some work on the transport layer,
> but not much, and definitely not a lot of work on the application layers.
>=20
> All of this comes down to one thing, netfilter simply doesnt care about
> streams. That's when you should use snort or proxy solutions of one sort
> or another.

Thanks for this excellent reply. =20

I have to add that there is a project for linux kernel stream reassembly
and pattern-matching:  libqsearch.  Try google :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MvEh5MSbieV/1Yst
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UPWlXaXGVTD0i/8RAvoPAKCNvzD4pLnyUcxL6y/08GU8cfvULQCfYPxF
fhHZTP+r1gkBSaEv3iDodH8=
=BQg0
-----END PGP SIGNATURE-----

--MvEh5MSbieV/1Yst--
