From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: minor bug in iptables 1.2.9
Date: Sat, 31 Jan 2004 16:35:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075563344.22658.8.camel@tux.rsn.bth.se>
References: <20040130084832.GA5527@sit0.ifup.net>
	 <1075555394.22658.0.camel@tux.rsn.bth.se>
	 <20040131142932.GB11570@soohrt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sxPvGSIByvhdGoErEp8Y"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karsten Desler <kdesler@soohrt.org>
In-Reply-To: <20040131142932.GB11570@soohrt.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-sxPvGSIByvhdGoErEp8Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-01-31 at 15:29, Karsten Desler wrote:
> Hi,
>=20
> And a couple more.
>=20
> Attached are three patches.
> iptables.patch    - fixes for similar bugs in ip6tables,
>                     iptables- and ip6tables-restore
> extensions.patch  - fixes for similar bugs in the extensions/
>                     directory
> libiptc.patch     - simiar fix for libiptc

Applied slightly modified, you introduced some memory-corruption, arrays
start at 0...

Thanks for all these fixes.

--=20
/Martin

--=-sxPvGSIByvhdGoErEp8Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAG8tQWm2vlfa207ERAgu7AJ413M+fbOQag5ECqHqg0groD/PPIgCfQQhv
XFjVxiX4vh1ZNZY+/AFV6M4=
=BIts
-----END PGP SIGNATURE-----

--=-sxPvGSIByvhdGoErEp8Y--
