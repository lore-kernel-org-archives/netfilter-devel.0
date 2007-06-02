From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH] iptables gateway match
Date: Sat, 02 Jun 2007 13:38:43 +0200
Message-ID: <1180784323.27259.42.camel@henriknordstrom.net>
References: <46604D8B.7030507@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-eVwvNS6Q9VstpQrtMpK7"
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46604D8B.7030507@ufomechanic.net>
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


--=-eVwvNS6Q9VstpQrtMpK7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-06-01 klockan 17:47 +0100 skrev Amin Azez:
> This adds a gateway match to iptables that lets you match against the
> routed ipv4 gateway, it's very useful for SNAT if you want to avoid
> replicating your routing in your SNAT table.
>=20
> e.g.
>=20
> iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 -j SNAT
> --to-address 172.16.1.5
> iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 -j SNAT
> --to-address 192.168.1.25

Cool. Been needing something like this many times in complex
environments with multiple links needing NAT based on the link and not
source/destination.. Helps keeping NAT table nice and clean with a
direct mapping to the network infrastructure rather than addresses..

Regards
Henrik

--=-eVwvNS6Q9VstpQrtMpK7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARmFWwENPQ5Kbx8daAQI9lwQAjgHuB50dg/mDLvcquTCOAtc/tGfB/tP0
GP0ADd0VBpi5vUXCFVOJtkk1E4DaXd3ssjK2dxoWf4z7ZvFlS+usptv1B9hpsTl4
yt6UEn1r2PnIsU5h4VmE2eDq94Hs75YiO7KYqut435vZZ8fDwvWvKrp0VEOGHN3s
yfuZ+v568N0=
=Soz8
-----END PGP SIGNATURE-----

--=-eVwvNS6Q9VstpQrtMpK7--
