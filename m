From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] New ipt_TTL target
Date: Sat, 27 Aug 2005 13:07:58 +0200
Message-ID: <20050827110758.GB4407@rama.de.gnumonks.org>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
	<20050826.123018.21840974.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050826.123018.21840974.davem@davemloft.net>
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


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2005 at 12:30:18PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Fri, 26 Aug 2005 20:31:51 +0200
>=20
> > +config IP_NF_TARGET_TTL_INC
> > +	bool  'TTL incrementing support (DANGEROUS)'
> > +	depends on IP_NF_TARGET_TTL
> > +	help
> > +	  This option enables functionality to increment and set the TTL
> > +	  value of the IP header to arbitrary values.  This is EXTREMELY
> > +	  DANGEROUS since you can easily create immortal packets that loop
> > +	  forever on the network.  Please only enable if you really know
> > +	  that you will need it.
> > +
>=20
> I think it's best to kill this option.  Just put the "this is
> DANGEROUS" comment into the help text for IP_NF_TARGET_TTL, ok?

ok, I thought you would consider this as a "quality of implementation
issue" ;)

I'll re-send without the #ifdef and config option later today.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEEmNXaXGVTD0i/8RAlWWAJwMjxwZPLTaOLMb4D7CsC2CGjBM0ACfcQka
EHwYvF90PeeQIWdJw2iWe20=
=c+JQ
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
