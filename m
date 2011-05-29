From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Possible iptables 4.4.11 issues
Date: Sun, 29 May 2011 07:43:52 -0700
Message-ID: <4DE25BA8.3070709@shorewall.net>
References: <4DE2593E.7000208@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE0962F256413A55066756C1"
Cc: Steven Jan Springl <steven@springl.ukfsn.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:56946 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1E2Onx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 10:43:53 -0400
In-Reply-To: <4DE2593E.7000208@shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE0962F256413A55066756C1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/29/11 7:33 AM, Tom Eastep wrote:
> One of the Shorewall Beta testers just installed iptables 1.4.11 and is=

> seeing a couple of anomalies. Before I run off and change Shorewall, I
> would like to confirm that these are intentional changes in iptables
> behavior and not bugs:

=2E..

>=20
> IPMARK(dst,-1,-64)  $FW  eth1  tcp  888
>=20
> produces the following iptables rule:
>=20
> -A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
> dst --and-mask -1 --or-mask -64 --shift 0
>=20
> Which works.
> After upgrading to iptables 1.4.11 the following iptables-restore error=
 is
> produced:
>=20
> iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1"=


I apologize for responding to my own post, but this one looks like
inadequate edited by Shorewall. So this one is mine.

-Tom
--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--------------enigEE0962F256413A55066756C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3iW6gACgkQO/MAbZfjDLIYrACgoNfEc64febTrp587E/Koz4cG
13oAn2IvK34dHk46wWEuJZwLAKxppo5q
=R7ur
-----END PGP SIGNATURE-----

--------------enigEE0962F256413A55066756C1--
