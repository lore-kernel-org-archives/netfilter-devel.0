From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Possible iptables 4.4.11 issues
Date: Sun, 29 May 2011 07:52:05 -0700
Message-ID: <4DE25D95.8060201@shorewall.net>
References: <4DE2593E.7000208@shorewall.net> <alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBDCE21929A4758CBFD248DA9"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Steven Jan Springl <steven@springl.ukfsn.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:34069 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1E2OwG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 10:52:06 -0400
In-Reply-To: <alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBDCE21929A4758CBFD248DA9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/29/11 7:48 AM, Jan Engelhardt wrote:
>=20
> On Sunday 2011-05-29 16:33, Tom Eastep wrote:
>> After upgrading iptables to 1.4.11 the following iptables-restore erro=
r
>> is produced:
>>
>> iptables-restore v1.4.11: owner: option "--uid-owner" cannot be invert=
ed.
>=20
> Bug, fix will be submitted.
>=20
>=20
>> -A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
>> dst --and-mask -1 --or-mask -64 --shift 0
>> After upgrading to iptables 1.4.11 the following iptables-restore erro=
r is
>> produced:
>>
>> iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1=
"
>=20
> This is intentional. Bitwise operations work best when fed unsigned num=
bers
> only.

Thanks, Jan -- I've sent Steven a Shorewall patch for this one.

-Tom
--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--------------enigBDCE21929A4758CBFD248DA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3iXZUACgkQO/MAbZfjDLJ+9ACfdY7wfFgxSDS9H6fzWlCOVrne
IjgAoLDx2JIJqnlcO2eW/jmj18tW64eH
=ehry
-----END PGP SIGNATURE-----

--------------enigBDCE21929A4758CBFD248DA9--
