From: "Christoph A." <casmls@gmail.com>
Subject: arbitrary address mask matching
Date: Mon, 10 Aug 2009 01:34:09 +0200
Message-ID: <4A7F5CF1.8030708@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6E64FAFB75E2B2764E3B8998"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56006 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZHIXgx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:36:53 -0400
Received: by bwz19 with SMTP id 19so2317687bwz.37
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Aug 2009 16:36:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E64FAFB75E2B2764E3B8998
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

the example in chapter 10.3 [1] seams to be a very handy thing, but I
couldn't reproduce it (testing it on the output chain).

I'm using v1.4.3.1/2.6.29.6 does this require v1.4.4/2.6.30?

[1] http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf
(btw: thanks for this wonderful paper)


iptables -A OUTPUT -d 10.10.97.1/255.255.255.253 -m iprange --dst-range
10.10.97.1-10.10.97.7 -j REJECT

this should match on 10.10.97.1,3,5,7 but matches only 1 and 3

iptables -A OUTPUT -m iprange --dst-range 10.10.97.1-10.10.97.7 -j LOG
--log-prefix "SKIPPED:  "


nmap -sP 10.10.97.1-7

log:
SKIPPED:  ... DST=3D10.10.97.2
SKIPPED:  ... DST=3D10.10.97.4
SKIPPED:  ... DST=3D10.10.97.7  <--
SKIPPED:  ... DST=3D10.10.97.5  <--
SKIPPED:  ... DST=3D10.10.97.6

best regards,
Christoph A.


--------------enig6E64FAFB75E2B2764E3B8998
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEAREKAAYFAkp/XP0ACgkQrq+riTAIEg0qfwCXfewvDbl0vEgxJzN8KhDNyvgo
7wCfbA90srm1xnmAwi0Izg+QHIMHnqU=
=F6Dx
-----END PGP SIGNATURE-----

--------------enig6E64FAFB75E2B2764E3B8998--
