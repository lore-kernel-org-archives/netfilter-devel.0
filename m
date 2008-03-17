From: Eric Leblond <eric@inl.fr>
Subject: Re: interface based conntrack entry
Date: Tue, 18 Mar 2008 00:25:44 +0100
Message-ID: <20080317232543.GB4003@bayen.regit.org>
References: <CAC6870A2B8FE846AD24D7E75B05F90A3F1960@moe.nextone.local> <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Paritosh Tyagi <ptyagi@nextpointnetworks.com>
To: Sohan Shetty <sshetty@nextpointnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:35491 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYCQXZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:25:48 -0400
Content-Disposition: inline
In-Reply-To: <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday, 2008 March 17 at 16:13:45 -0400, Sohan Shetty wrote:
> Forwarding query from Paritosh Tyagi to Netfilter mailing list.
>=20
>=20
> --------------------------------------------------------------------
> Hello,
>=20
> We are using 2.6.18 version of the kernel and we have following issue rel=
ated to conntrack module and Vlan interfaces.
> =A0=A0=A0=A0=A0 Here, our box is connected to two distinct networks 192.1=
68.1/24 via a different vlan. Our application is exposing the same ip addre=
ss (192.168.1.1) on both the vlans. On eth1.100 internal ip address 169.254=
=2E16.1 =A0is configured and on eth1.101 internal ip address 169.254.16.2 i=
s configured.=20
> =A0=A0=A0=A0 Ep1 and ep2 talk to 192.168.1.1 on the two vlans.
> =A0=A0=A0=A0 Iptables and arptables rules are added to map incoming/outgo=
ing ip/arp packets on eth1.100 to/from 169.254.16.1 and on eth1.101 to/from=
 169.254.16.2.=20
> =A0
> =A0=A0=A0 The problem we are seeing is, that when an incoming packet come=
s in from ep1 a conntrack entry is created for=20
> Proto=3Dudp, srcip=3D192.168.1.100, dstip=3D192.168.1.1, sport=3D5060, dp=
ort=3D5060, this packet is DNAT'ed to 169.254.16.1 =A0and our application r=
eceives it on the socket bound to that ip. However, when ep2 sends a packet=
, it seems that the conntrack entry matches it and the ip table NAT rule (w=
hich should map this packet to 169.254.16.2) is ignored and because of the =
4-tuple match with existing udp conntrack entry, the packet is sent to 169.=
254.16.1.=20
>=20
> =A0 =A0Is there a patch to support the in-interface and out-interface or =
mark in the conntrack module? So, we can have two entries in there where th=
e 4 tuple is the same only the interface is different?=20

There is no such patch. A similar question was asked some time ago and
if I remember well, the conclusion was the setup was too weird from a=20
firewall point-of-view.
Suggestion was made to use some virtualization solution.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH3v33nxA7CdMWjzIRAs77AJ9fj6eYEjcPf3WhEtIFVUIlBRBShgCfYAyE
4piQbR/PZjcpCWgr2BAZhZo=
=eFYo
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
