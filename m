From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Sat, 15 Jul 2006 07:32:32 -0700
Message-ID: <1152973952.10593.16.camel@localhost.localdomain>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net> <Pine.LNX.4.64.0607130933380.15827@x2>
	<44B65492.3040506@shorewall.net> <Pine.LNX.4.64.0607131638180.15827@x2>
	<44B6675B.6030000@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5Z2lL7R1D5rBCmZWr7TD"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44B6675B.6030000@shorewall.net>
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


--=-5Z2lL7R1D5rBCmZWr7TD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-07-13 at 08:31 -0700, Tom Eastep wrote:

>=20
> In Shorewall, filtering on bridge port is usually done *first* to select =
the
> appropriate rule chain. In that rule chain, the user has access to more o=
r less
> the full box of iptables tools (at least those that are supported by kern=
els
> from kernel.org). To what extent those tools are actually used, I don't k=
now.
>=20

=46rom my quick survey, most Shorewall bridge users are filtering OUTPUT
traffic and/or routed traffic based on egress port; where additional
filtering is being used, it is most commonly based on source IP,
protocol and destination port. One respondent is also using ipt_recent.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--=-5Z2lL7R1D5rBCmZWr7TD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBEuPyAO/MAbZfjDLIRAvvjAJwMOK/N52Fo8L81mmnYBRNJW4tdggCeMjbH
B3vxBEXaw37lMMNnwKW7Kr0=
=R1Gt
-----END PGP SIGNATURE-----

--=-5Z2lL7R1D5rBCmZWr7TD--
