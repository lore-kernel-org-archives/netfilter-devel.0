From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] [PATCH] Null pointer access in nf_queue()
Date: Mon, 7 Nov 2005 09:55:56 +0100
Message-ID: <20051107085555.GF26843@sunbeam.de.gnumonks.org>
References: <E1EYW7S-0000uH-00@master.debian.org>
	<20051107083953.GA8420@verge.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Cc: Patrick McHardy <kaber@coreworks.de>, netfilter-devel@lists.netfilter.org,
	coreteam@netfilter.org, 337713@bugs.debian.org,
	Torok Edwin <edwintorok@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Horms <horms@debian.org>
Content-Disposition: inline
In-Reply-To: <20051107083953.GA8420@verge.net.au>
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


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2005 at 05:39:53PM +0900, Horms wrote:

> I did some disasembling fun and games, and I'm pretty sure the patch
> below will fix your problem. I'll fire of a build, I'd be greateful if
> you could test it.

Sorry, Horms, you must have missed my previos fix (that does exactly the
same).  I've already posted it to netdev, and IIRC, Arnaldo has merged
it for net-2.6.15.

Sorry for not Cc'ing you with the fix, it seems like I only reported
back to bugzilla :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbxabXaXGVTD0i/8RAlvVAJ9DmIfnB1ILtzOdlJkRZoy2iyo53wCfaa9w
DDAGT+Zhm6odRyBVKJWK3IQ=
=eXOp
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
