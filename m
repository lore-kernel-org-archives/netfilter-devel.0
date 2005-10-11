From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 19:45:56 +0200
Message-ID: <20051011174556.GA13415@rama.de.gnumonks.org>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
	<20051010214619.GJ5627@rama>
	<Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
	<434BC86F.3090506@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Content-Disposition: inline
In-Reply-To: <434BC86F.3090506@cosmosbay.com>
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


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 04:13:03PM +0200, Eric Dumazet wrote:
> Henrik Nordstrom a =E9crit :
> >On Mon, 10 Oct 2005, Harald Welte wrote:
> >>I don't know why they are incomplete ;)  My guess is that they're mostly
> >>targeted to per_cpu users.  Basically to solve the 'iptables' problem,
> >>there are two ways:
> >Or three.
> >  3) Keep an NUM_CPUS array of pointers to the per-cpu tables, allocated=
 separately per=20
> >CPU instead of allocating a single large blob for all CPUs. These pointe=
rs are updated=20
> >using RCU, and indexed using the physical CPU id.
>=20
> Yes, this is what I suggested some weeks ago with a patch.
>=20
> As vmalloc_node() is not yet part of kernel, I even coded a substitute fo=
r it.
> (per_cpu/kmalloc are not an option since the allocations done in iptables=
 can be very large)

Eric, I still have your patches on hold and hope that vmalloc_node will
eventually appear.  I don't really like the idea of adding code to
iptables that has to go knee-deep into the vm code....  So once
vmalloc_node() is there, I'm open to merging your changes.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS/pUXaXGVTD0i/8RAv7ZAJ0SWMN9vX2W80GBzFsmJOw480cGygCfeemK
6a5OXUiefqj7AXiVeEDcINs=
=y/zF
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
