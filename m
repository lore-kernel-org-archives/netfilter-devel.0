From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 23:46:19 +0200
Message-ID: <20051010214619.GJ5627@rama>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051010.141518.60492651.davem@davemloft.net>
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


--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 02:15:18PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Mon, 10 Oct 2005 18:41:41 +0200
>=20
> > This is my proposed patch for the problem you've described.  Please test
> > and submit.  If it works, I'll also prepare a patch for {arp,ip6}_table=
s.
>=20
> Ebtables needs it too.  "git grep num_possible_cpus" shows all
> of the users in the whole tree, %80 of which are the netfilter
> cases we're fixing here :-)
>=20
> Why don't any of the existing interfaces on cpumasks and numbers
> provide what you need here? =20

I don't know why they are incomplete ;)  My guess is that they're mostly
targeted to per_cpu users.  Basically to solve the 'iptables' problem,
there are two ways:

1) allocate one copy of the ruleset per cpu that actually exists,
   independent of their smp_processor_id().  This means that for every
   packet traversing the ruleset, we need to resolve the logical "cpu
   number" from the physical smp_processor_id().  Since there is no
   apparent mapping between them, we'd need to iterate over the=20
   cpu_possible bitmask and find "how many bits are set between 0 and
   smp_processor_id()".  I'm not sure how expensive such calculations
   are, but I'd rather not additional code to the per-packet path.
   Advantage of this solution is that there is only one copy of the
   ruleset per physical cpu.

2) allocate one copy of the ruleset for every "possible
   smp_processor_id()", which is what the patch that I sent in my last
   email implements.

> Perhaps this routine you are adding (highest_processor_id()) belongs
> in linux/cpumask.h?  Perhaps named something like
> "highest_possible_processor_id()" to be consistent with the
> "num_possible_cpus()" naming?

I thought it was too specific for the generic code, but since we'll need
it from all the foobar_tables, it's probably best in cpumask.h

> Otherwise the patch looks fine, thanks for following up on this
> Harald.  I'll push the rest of the netfilter fixes once you cook
> up the final patch for this, thanks.

ok.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSuErXaXGVTD0i/8RAlgJAJ4oLwVRA7wd1wpS2InSMttkKfBPbwCbBiV0
OsGuy/JJimV0bb7ys2hXc2A=
=bjGY
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
