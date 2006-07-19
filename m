From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 19 Jul 2006 08:50:59 -0700
Message-ID: <1153324259.9763.29.camel@localhost.localdomain>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net>	<Pine.LNX.4.64.0607130933380.15827@x2>
	<44B65492.3040506@shorewall.net>	<Pine.LNX.4.64.0607131638180.15827@x2>
	<44B6675B.6030000@shorewall.net>  <44BE3FF5.4020503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-rbh5LIpPmxPgWR42Hv5u"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44BE3FF5.4020503@trash.net>
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


--=-rbh5LIpPmxPgWR42Hv5u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-07-19 at 16:21 +0200, Patrick McHardy wrote:
> Tom Eastep wrote:
> > Patrick McHardy wrote:
> >=20
> >>I don't really see why this can't be done purely within ebtables, it to=
o
> >>can filter based on protocol and port numbers. Do you also know of
> >>examples where its really necessary to filter on bridge port and use
> >>iptables' capabilities?
> >>
> >=20
> >=20
> > In Shorewall, filtering on bridge port is usually done *first* to selec=
t the
> > appropriate rule chain. In that rule chain, the user has access to more=
 or less
> > the full box of iptables tools (at least those that are supported by ke=
rnels
> > from kernel.org). To what extent those tools are actually used, I don't=
 know.
>=20
> It there anything preventing your users from you routing outgoing
> packets to the bridge ports directly? I assume if they use IP/port
> filters they should already have a pretty good idea of whats located
> behind a bridge port and don't really need the bridge to route the
> packets.
>=20

It is possible to define a Shorewall zone as a set of (interface,
network) pairs (where 'network' may be a single host) rather than a set
of (bridge, port) pairs. So instead of defining a bridged zone as 'all
hosts whose traffic goes in/out port P on bridge B', the user can define
the same zone as (B,net1),(B,net2),... where net1,net2,... defines the
same set of hosts (extra care must be taken when a default route goes
through a bridge port)

While this alternative definition is more cumbersome and error-prone for
the user to configure and maintain, it removes the need for filtering by
bridge port entirely. That approach is probably what I will recommend to
current users when --physdev-out is no longer available.

Shorewall also supports defining a zone as a set of (interface, ipset)
pairs which is a workable alternative for those users who have installed
ipset support.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--=-rbh5LIpPmxPgWR42Hv5u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBEvlTjO/MAbZfjDLIRAjX0AJ9AEyENzCPcbqNvQM8LaqZzl08PDwCcD1ih
KieCy2SRAAO7QcLY5sLpQu4=
=gdqC
-----END PGP SIGNATURE-----

--=-rbh5LIpPmxPgWR42Hv5u--
