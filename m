From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 12 Jul 2006 17:45:05 -0700
Message-ID: <44B59791.9090105@shorewall.net>
References: <44AF200F.9000204@trash.net>	<44B493BC.5010302@snapgear.com>	<44B591C5.8080604@shorewall.net>
	<20060712.174227.126763959.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig5D45C9A46318BF169B1BE92D"
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be,
	philipc@snapgear.com, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20060712.174227.126763959.davem@davemloft.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D45C9A46318BF169B1BE92D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Miller wrote:
> From: Tom Eastep <teastep@shorewall.net>
> Date: Wed, 12 Jul 2006 17:20:21 -0700
>=20
>> From what I gather, ebtables doesn't support ULOG so that
>> form of logging won't be available.
>=20
> See net/bridge/netfilter/ebt_ulog.c, it does support this.

Thanks, David -- I stand corrected.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enig5D45C9A46318BF169B1BE92D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEtZeRO/MAbZfjDLIRAnnLAKC4iTYAl8zf8jQaImDkUUOZmPy/igCeLhcL
RaKx9VotmQgzy3i+FDiWUzc=
=vv6w
-----END PGP SIGNATURE-----

--------------enig5D45C9A46318BF169B1BE92D--
