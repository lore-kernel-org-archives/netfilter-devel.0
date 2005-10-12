From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 09:00:03 +0200
Message-ID: <20051012070002.GG4237@rama.de.gnumonks.org>
References: <Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
	<434BC86F.3090506@cosmosbay.com>
	<20051011174556.GA13415@rama.de.gnumonks.org>
	<20051011.155733.05623834.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Cc: netfilter-devel@lists.netfilter.org, hno@marasystems.com,
	dada1@cosmosbay.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051011.155733.05623834.davem@davemloft.net>
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


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 03:57:33PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Tue, 11 Oct 2005 19:45:56 +0200
>=20
> > Eric, I still have your patches on hold and hope that vmalloc_node will
> > eventually appear.  I don't really like the idea of adding code to
> > iptables that has to go knee-deep into the vm code....  So once
> > vmalloc_node() is there, I'm open to merging your changes.
>=20
> After thinking about this a bit, what I'm trying to do now is
> champion getting the vmalloc_node() patch into 2.6.14 so we
> can use Eric's approach to fix this bug cleanly.

Ok, seems fine withe me.

> If this fails, I'm afraid we might need to go with the NR_CPUS
> option for now as much as I'd really really hate to do that.

Also fine with me, we should probably document it somewhere for 2.6.14
and get it finally fixed in 2.6.15

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD4DBQFDTLRyXaXGVTD0i/8RArLWAJwPOQKV+jL/yrT9KzZFV3HUtL+b9wCY9iK3
/jKnophwvVLAzJzKIhjDYQ==
=WGac
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
