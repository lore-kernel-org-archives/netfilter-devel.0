From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 12 Jul 2006 15:41:35 -0700
Message-ID: <44B57A9F.9000403@shorewall.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net> <44B40B4E.6080206@shorewall.net>
	<44B4183E.7010905@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig377CC30D0902551723E9F4EA"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44B4183E.7010905@trash.net>
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
--------------enig377CC30D0902551723E9F4EA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Tom Eastep wrote:
>> Patrick McHardy wrote:
>>
>>> But you can do your iptables matching, mark matching packets
>>> and filter on the mark within ebtables.
>>
>> I was afraid that's what you were going to suggest. If Shorewall was a=
n
>> appliance that only supported a limited set of configurations, I could=
 entertain
>> that approach; as it is, I'm not sure.
>>
>> I'm going to issue a warning to my users that Shorewall support for
>> bridge/firewalls may be discontinued in the future. If in the next six=
 months, I
>> can come up with code that is clean enough to go forward with, I'll re=
scind the
>> announcement.
>=20
> That sounds overly dramatic to me.

Probably ... my apologies.

>=20
>> So that I understand the playing field, --physdev-out will no longer b=
e
>> supported out of the FORWARD and OUTPUT chains (all tables); is that c=
orrect?
>=20
> For locally generated traffic (-o br0), yes. This feature is going to
> be removed, but I think it might be more useful to gather some data
> among your users who actually needs this. I did some google-research
> myself, and I wasn't able to find more then a handful of examples
> of people actually using it this way. I certainly would be interested
> in this data, if it really is needed by a significant larger amount
> than I thought I will consider migation strategies stronger than
> before. So far I'm not convinced that this really will pose a problem.

I copied you privately on the survey that I sent out to Shorewall users -=
- so
far, two out of four responders filter traffic from the firewall to the b=
ridge
based on egress port and three out of four filter outbound bridge traffic=
 routed
from an unbridged interface based on egress port.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key



--------------enig377CC30D0902551723E9F4EA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEtXqkO/MAbZfjDLIRAlDIAJ9Ydc2c9Z9UoOhfR+bbwNL7ZrsEwgCgllee
BokMdRRO69Xs4Lb5n16zpVA=
=QXEe
-----END PGP SIGNATURE-----

--------------enig377CC30D0902551723E9F4EA--
