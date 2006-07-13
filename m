From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 12 Jul 2006 17:20:21 -0700
Message-ID: <44B591C5.8080604@shorewall.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net> <44B493BC.5010302@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig921A5C39461E4F1BB2835BD3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <44B493BC.5010302@snapgear.com>
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
--------------enig921A5C39461E4F1BB2835BD3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Philip Craig wrote:
> Patrick McHardy wrote:

>=20
>> But you can do your iptables matching, mark matching packets
>> and filter on the mark within ebtables.
>=20
> I haven't thought about this too much, but for a high-level tool,
> the rules can theoretically be too complicated for this to be feasible.=

> The worst case will be to perform all the possible matches that are
> supported by iptables but not ebtables, and encode the result of all
> of these into the mark.  And even if this can be optimized, I can
> imagine the code to do it being quite complex.
>=20

The proposed solution requires high-level tools to have two completely
different paradigms for filtering traffic; one for when the output
device is a bridge and the packet is locally-generated (and possibly
when the input device is not the same bridge -- I'm still not clear on
that point) and the other is applied everywhere else. In one case,
filtering rules are contained in the filter table and use standard
filter targets -- in the other case, they must be placed in the mangle
table and use the MARK target. That, in and of itself, is a ugly change
for Shorewall which has a nice uniform structure for generating
filtering rules.

I think that the mark values can be optimized down to two fwmark bits
per Shorewall zone. If the first bit is set, traffic is allowed to the
zone; if the other bit is set, the traffic is not allowed (our users
lose the ability to use the REJECT target since ebtables can only ACCEPT
or DROP). Two separate bits are required so that Shorewall can detect
packets that don't match any rules and hence are subject to the
applicable user-specified policy (MARK isn't terminating).

In Shorewall, there needs to be a few more fwmark bits reserved to
indicate if and at what level the packet should be logged if it is
dropped and a similar number of bits to indicate if and at what level
the packet should be logged if it is accepted. And finally, a few more
fwmark bits will need to be allocated to indicate the contents of the
log-prefix. From what I gather, ebtables doesn't support ULOG so that
form of logging won't be available.

Shorewall supports 'actions' which are essentially user-defined filter
chains; actions can be invoked in other filtering rules (a --jump to the
action chain results). With --physdev-out limited as proposed, actions
must generate either a filter table chain or a mangle table chain or
both (the mangle table chains must be tailored for each destination zone
in the rules where the action is invoked since the mark values are
dependent on the destination zone in the invoking rule). Shorewall today
needs to tailor the chain based on the invoking context and that part of
the code is complex and error prone.

The original support for bridge-port based filtering was added to
Shorewall in a weekend, including the documentation (I can only work on
Shorewall off hours). To maintain even reduced support for this feature
will require considerably more effort and will result, I fear, in a less
maintainable product.

In summary, I think that the complexity is probably manageable but this
is really ugly ...

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key




--------------enig921A5C39461E4F1BB2835BD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEtZHMO/MAbZfjDLIRAs4xAJ9tUTm4CDN6QsfCWWceid+lgxTUagCgpxXI
VWp2XE52FEb+A2JqY9zHbSY=
=ZSjb
-----END PGP SIGNATURE-----

--------------enig921A5C39461E4F1BB2835BD3--
