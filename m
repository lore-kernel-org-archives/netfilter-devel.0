From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] [2.6 patch] net/ipv4/netfilter/: misc possible
	cleanups
Date: Thu, 16 Dec 2004 12:01:46 +0100
Message-ID: <20041216110146.GR2862@sunbeam.de.gnumonks.org>
References: <20041215011931.GD12937@stusta.de>
	<20041215090322.GA2862@sunbeam.de.gnumonks.org>
	<1103161248.2200.7.camel@localhost.localdomain>
	<20041216074017.GL2862@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0412160942150.28214@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yg/4YF7t1SayoUom"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0412160942150.28214@filer.marasystems.com>
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


--Yg/4YF7t1SayoUom
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 16, 2004 at 09:43:32AM +0100, Henrik Nordstrom wrote:
> On Thu, 16 Dec 2004, Harald Welte wrote:
>=20
> >Then different patches need different exports, and you have your patches
> >again clashing :(  We've been through this...
>=20
> Shouldn't be to hard to make pom deal with this in a manner similar to th=
e=20
> ladd files, or perhaps simply by the ladd mechanism skipping the add if=
=20
> the line is there already..

I'd rather not add another of these ugly kludges.  For me personally,
patch-o-matic has largely failed for anything that is not very
self-contained like a new match/target.=20

And why shouldn't stuff like conntrack/nat_register_protocol be
exported?  That's the whole purpose of those functions ;)

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Yg/4YF7t1SayoUom
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwWsaXaXGVTD0i/8RArs6AJ4sZrrU/5gFcFfzHC9fhp03pMN+GwCeIlVx
79/RtbqBNpLP5FZ6rGhU7Lw=
=7NDR
-----END PGP SIGNATURE-----

--Yg/4YF7t1SayoUom--
