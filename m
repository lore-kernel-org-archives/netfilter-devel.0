From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 00:51:31 +0200
Message-ID: <20050916225131.GS8413@sunbeam.de.gnumonks.org>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5M2fOMh7RWu7idz2"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050916.154556.116608678.davem@davemloft.net>
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


--5M2fOMh7RWu7idz2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2005 at 03:45:56PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Fri, 16 Sep 2005 11:15:48 +0200
>=20
> > On Fri, Sep 16, 2005 at 12:44:30AM +0200, Patrick McHardy wrote:
> > > Harald Welte wrote:
> > > >NETFILTER: Add new PPTP conntrack and NAT helper
> > >=20
> > > I noticed a number of problems, this first batch of patches
> > > fixes the worst ones I hope. There's also one or two small
> > > cleanup patches. I can't test them here, please review and
> > > ACK/NACK for Dave.
> >=20
> > Ok, I'm at the moment hunting down some strange linux-2.6.13 <-> solaris
> > 9 TCP window scaling problems.  Will look into your patches later today.
>=20
> Since Linus GIT doesn't have the PPTP addition changes yet, I think
> I'm going to hold off on merging it for now.

ok, that's fine.

> Why don't you guys work together to integrate all of the fixes, and
> then resubmit PPTP as one changeset with all the bug fixes already
> applied?  I think that would work best and prevent changeset bloat.

yes, ideally that would be the way for it to happen.  Unfortuantely the
PPTP helper has been around for many years (patch-o-matic-ng, latest
version in my git tree, ...) and it apparently still didn't receive the
kind of review it required.

I'll test and resubmit PPTP on saturday or sunday.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5M2fOMh7RWu7idz2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDK0xzXaXGVTD0i/8RAlrzAJ0VYP3C9UdTXN18hBLWROB+m+71fQCgh70a
TppW+7//Bg9eL2V58E5oo8s=
=tPvD
-----END PGP SIGNATURE-----

--5M2fOMh7RWu7idz2--
