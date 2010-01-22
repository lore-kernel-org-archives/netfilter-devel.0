From: Tom Eastep <teastep@shorewall.net>
Subject: Re: ipset problem.
Date: Fri, 22 Jan 2010 10:05:44 -0800
Message-ID: <4B59E8F8.1060401@shorewall.net>
References: <4B5991E2.4090700@metu.edu.tr> <alpine.DEB.2.00.1001221419550.13886@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE1BCC9D0540E03A4798D2D9"
Cc: Husnu Demir <hdemir@metu.edu.tr>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([206.124.146.177]:53201 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0AVSON (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:14:13 -0500
In-Reply-To: <alpine.DEB.2.00.1001221419550.13886@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE1BCC9D0540E03A4798D2D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jozsef Kadlecsik wrote:

>> nl# ipset -v
>> ipset v4.1, protocol version 4.
>> Kernel module protocol version 4.
>=20
> I'll try to reproduce and find the reason for the difference in the=20
> listing.
>=20

I can add another data point.

A similar issue can be seen when xtables-addons 1.21 is installed on
Debian Lenny, kernel 2.6.26-openvz-am64. In that case, extra /31
networks show up whether a set name is supplied or not; they are
different in the two cases, however.

gateway:~# ipset -L dshield -n
Name: dshield
Type: nethash
References: 1
Header: hashsize: 1024 probes: 4 resize: 50
Members:
74.63.225.0/24
218.206.128.0/24
210.212.152.0/24
77.254.150.0/24
116.55.199.0/24
118.160.213.0/24
70.38.64.0/24
91.144.92.0/24
58.221.42.0/24
174.129.75.0/24
88.163.67.0/24
219.139.40.0/24
88.79.127.0/24
194.165.153.0/24
75.101.178.0/24
222.45.112.0/24
202.155.202.0/24
89.149.204.0/24
118.161.234.0/24
122.200.121.0/24
116.114.111.222/31
0.112.97.216/31
0.1.0.0/31
97.109.111.218/31
0.0.108.208/31
97.104.112.208/31
0.0.104.228/31

gateway:~# ipset -L -n
=2E..
Name: dshield
Type: nethash
References: 1
Header: hashsize: 1024 probes: 4 resize: 50
Members:
74.63.225.0/24
218.206.128.0/24
210.212.152.0/24
77.254.150.0/24
116.55.199.0/24
118.160.213.0/24
70.38.64.0/24
91.144.92.0/24
58.221.42.0/24
174.129.75.0/24
88.163.67.0/24
219.139.40.0/24
88.79.127.0/24
194.165.153.0/24
75.101.178.0/24
222.45.112.0/24
202.155.202.0/24
89.149.204.0/24
118.161.234.0/24
122.200.121.0/24
48.116.105.228/31
97.104.112.208/31
0.0.104.228/31
0.5.0.8/31
95.116.101.218/31
101.114.105.198/31
0.0.116.196/31
=2E..

All of the /31 nets are bogus.

When installed on a Lenny system running kernel 2.6.26-686, things seem
to work as expected.

-Tom
--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________



--------------enigBE1BCC9D0540E03A4798D2D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAktZ6QoACgkQO/MAbZfjDLLFvgCfbUnYL2/Y7CNxLrcXSeosmoB6
9YMAoMpoSUgnzIsSX1UCYl2iYxYcwdOk
=4D+f
-----END PGP SIGNATURE-----

--------------enigBE1BCC9D0540E03A4798D2D9--
