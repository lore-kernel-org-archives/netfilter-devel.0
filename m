From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Thu, 25 Jan 2007 16:59:08 +0100
Message-ID: <20070125155908.GU16563@prithivi.gnumonks.org>
References: <1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
	<45B80BFB.2060203@netfilter.org>
	<65031.80.214.249.17.1169727081.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RCcFxJ34+mAtH0DM"
Cc: Vincent Deffontaines <vincent@inl.fr>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <65031.80.214.249.17.1169727081.squirrel@mail.inl.fr>
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


--RCcFxJ34+mAtH0DM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2007 at 01:11:21PM +0100, Eric Leblond wrote:
> Hi Pablo,
>=20
> Excellent remarks as usual...
>=20
> Here's the modified patch.

There's only some really cosmetic point that I wnat to make: I believe
it's not always within 80 characters wide lines (or is that just in the
patch due to different tab expansion?).  But we can do that even after
the commit ;)

Technically, I'm happy with the changes.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RCcFxJ34+mAtH0DM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFuNPMXaXGVTD0i/8RAmY/AKC1AU24a2ri7F+bYmrhWnLVexQffQCaAiOP
pZsMaoP8ncIq2goz1JIWsSM=
=Ke/k
-----END PGP SIGNATURE-----

--RCcFxJ34+mAtH0DM--
