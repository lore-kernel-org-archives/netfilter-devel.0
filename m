From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] [2.6 patch] net/ipv4/netfilter/: misc possible
	cleanups
Date: Thu, 16 Dec 2004 08:40:17 +0100
Message-ID: <20041216074017.GL2862@sunbeam.de.gnumonks.org>
References: <20041215011931.GD12937@stusta.de>
	<20041215090322.GA2862@sunbeam.de.gnumonks.org>
	<1103161248.2200.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKkMM/tm2Mk6Yn/s"
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1103161248.2200.7.camel@localhost.localdomain>
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


--AKkMM/tm2Mk6Yn/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Removed some Cc's]

On Thu, Dec 16, 2004 at 12:40:48PM +1100, Rusty Russell wrote:
> On Wed, 2004-12-15 at 10:03 +0100, Harald Welte wrote:
> > On Wed, Dec 15, 2004 at 02:19:31AM +0100, Adrian Bunk wrote:
> > > The patch below contains the following possible cleanups:
> ...
> > As you might be aware, netfilter/iptables has an enormously large
> > codebase (I'd say even larger than what is in the tree) in the so-called
> > patch-o-matic subsystem.  The abovementioned exports facilitate those
> > modulse, and A certain amount of those new modules (especially the ones
> > requiring the functions above) are scheduled for mainline inclusion over
> > the next couple of months.
>=20
> True, but some of these cleanups are genuine.  Deleting code also
> increases the coverage of the testsuite: I've put this in my patch set
> and will merge them in pieces.  At the rate I work, those that are
> needed in the next few months won't be deleted.  If patches are not due
> to be merged in that timeframe, it'd be nice if they contained the
> exports etc. that they need rather than relying on long-term unused
> features of the tree.

Then different patches need different exports, and you have your patches
again clashing :(  We've been through this...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AKkMM/tm2Mk6Yn/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwTvgXaXGVTD0i/8RArosAJ4q1V6rRYDbzNLjpODYgfuZGcyVZACgo2iy
gN0KdkQH5aLWZW43e4rKjbs=
=CNJ6
-----END PGP SIGNATURE-----

--AKkMM/tm2Mk6Yn/s--
