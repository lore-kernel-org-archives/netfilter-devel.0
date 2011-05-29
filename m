From: Tom Eastep <teastep@shorewall.net>
Subject: Possible iptables 4.4.11 issues
Date: Sun, 29 May 2011 07:33:34 -0700
Message-ID: <4DE2593E.7000208@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5C78079159D4ECB9AAF0790D"
Cc: Steven Jan Springl <steven@springl.ukfsn.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:49948 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1E2Okh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 10:40:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5C78079159D4ECB9AAF0790D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

One of the Shorewall Beta testers just installed iptables 1.4.11 and is
seeing a couple of anomalies. Before I run off and change Shorewall, I
would like to confirm that these are intentional changes in iptables
behavior and not bugs:

-------- Original Message --------
Subject: Re: [Shorewall-devel] Shorewall 4.4.20 Beta 5
Date: Sun, 29 May 2011 15:01:09 +0100
From: Steven Jan Springl <steven@springl.ukfsn.org>
Reply-To: shorewall-devel@lists.sourceforge.net
To: shorewall-devel@lists.sourceforge.net

Using kernel 2.6.39, iptables 1.4.10 and xtables-addons 1.35

The following rules file entry:

ACCEPT  $FW  lan  tcp  22  -  -  -  !root:root

produces the following iptables rule:

-A fw2lan -p 6 --dport 22 -m owner ! --uid-owner root ! --gid-owner root =
-j
ACCEPT

Which works.

After upgrading iptables to 1.4.11 the following iptables-restore error
is produced:

iptables-restore v1.4.11: owner: option "--uid-owner" cannot be inverted.=



The following tcrules file entry:

IPMARK(dst,-1,-64)  $FW  eth1  tcp  888

produces the following iptables rule:

-A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
dst --and-mask -1 --or-mask -64 --shift 0

Which works.
After upgrading to iptables 1.4.11 the following iptables-restore error i=
s
produced:

iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1"

---------------------------------
Thanks,
-Tom


--------------enig5C78079159D4ECB9AAF0790D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3iWUMACgkQO/MAbZfjDLIfnwCfbzbR7QePIdF6t6T6ARsXQXKJ
DUcAoJgYc/2ZUBxuoPFkq8EpThpFWi33
=hAIj
-----END PGP SIGNATURE-----

--------------enig5C78079159D4ECB9AAF0790D--
