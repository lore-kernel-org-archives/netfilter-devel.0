From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 08:31:39 -0700
Message-ID: <44B6675B.6030000@shorewall.net>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net>
	<Pine.LNX.4.64.0607130933380.15827@x2>
	<44B65492.3040506@shorewall.net>
	<Pine.LNX.4.64.0607131638180.15827@x2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE82DBCC5867264287DB76CCF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.64.0607131638180.15827@x2>
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
--------------enigE82DBCC5867264287DB76CCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
>=20
> On Thu, 13 Jul 2006, Tom Eastep wrote:
>=20
>> Patrick McHardy wrote:
>>
>>>
>>> Thanks. I'm currently travelling, I'll look at this on Sunday when I =
get
>>> back home (haven't received it yet I think). Do you know on which
>>> criteria
>>> they filter in addition to the bridge port?
>>>
>>
>> Typically, they will also filter on protocol and the destination port
>> (if the
>> protocol is TCP or UDP).
>=20
>=20
> And the really differentiate between different bridge ports for this, i=
=2Ee.
> port eth0 may receive packets on port 80, port eth1 may not?

That's correct.

>=20
> I don't really see why this can't be done purely within ebtables, it to=
o
> can filter based on protocol and port numbers. Do you also know of
> examples where its really necessary to filter on bridge port and use
> iptables' capabilities?
>=20

In Shorewall, filtering on bridge port is usually done *first* to select =
the
appropriate rule chain. In that rule chain, the user has access to more o=
r less
the full box of iptables tools (at least those that are supported by kern=
els
from kernel.org). To what extent those tools are actually used, I don't k=
now.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enigE82DBCC5867264287DB76CCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEtmdcO/MAbZfjDLIRAvXnAKCoS8eAylnG1ZztKO8wjbfzi+trUwCfV7b1
8PyeA0pyfVlNTavynme/QlA=
=/Qlx
-----END PGP SIGNATURE-----

--------------enigE82DBCC5867264287DB76CCF--
