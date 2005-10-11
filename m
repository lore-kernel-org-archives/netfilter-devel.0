From: Harald Welte <laforge@netfilter.org>
Subject: Re: num_possible_cpus() usage in iptables
Date: Tue, 11 Oct 2005 16:35:54 +0200
Message-ID: <20051011143554.GD4756@rama.de.gnumonks.org>
References: <20051009.204734.30319051.davem@davemloft.net>
	<434A08DF.5090402@cosmosbay.com>
	<20051010.172728.72244069.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net, dada1@cosmosbay.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051010.172728.72244069.davem@davemloft.net>
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


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 05:27:28PM -0700, David S. Miller wrote:
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 10 Oct 2005 08:23:27 +0200
>=20
> > My previous patch ([PATCH 3/3] netfilter : 3 patches to boost ip_tables=
=20
> > performance) addressed this problem.
> >=20
> > http://marc.theaimsgroup.com/?l=3Dlinux-netdev&m=3D112733887410796&w=3D2
>=20
> Long term this is the kind of thing we should be doing.
>=20
> But for 2.6.14, I would like to suggest that we revert back
> to using NR_CPUS as that is the simplest fix for this bug.
>=20
> I even spent part of this afternoon investigating other kinds of
> fixes, and all of them have possible non-trivial regressions.
>=20
> Yes, using NR_CPUS wastes a lot of ram, but it fixes this
> bug in a straightforward and easy to verify fashion.

Mh.  The problem is that I know a number of people who were running out
of RAM with moderate ruleset sizes (in the tens of thousands rules), and
the sole reason for switching from 2.4.x to 2.6.x  was the NR_CPU to cpu
number change.

However, given that 2.6.14 seems close (and I cannot do testing on SMP
while on the road), it might be an interim solution.

OTOTH, how many users of systmes with discontiguous processor id space
are there vs. users with large rulesets on 2cpu machines that now have a
factor of 16 increased rule size (which can easily be a couple of 100mb
non-swappable kernel memory).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS83KXaXGVTD0i/8RAmTNAJ0VXzX9R0OvftRnV0i2yvZ2+9fiWgCfbtQ9
uOYF1ubhTn4R2hkRfR/rtU4=
=nfC5
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
