From: "Christoph A." <casmls@gmail.com>
Subject: security impact of creating rulesets with iptables (cmd)
Date: Sun, 09 Aug 2009 23:43:58 +0200
Message-ID: <4A7F431E.70706@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig71A2A338355FD42FE0A92CC5"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42238 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZHIVql (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:46:41 -0400
Received: by ewy10 with SMTP id 10so2653093ewy.37
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Aug 2009 14:46:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig71A2A338355FD42FE0A92CC5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

I read Jan's "Towards the perfect ruleset" paper [1]

[1] http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf

and I would have a question about the mentioned security risk when
creating hole rulesets with the iptables command (chapter 3).

I understand why it is a bad idea to create n rules by using multiple
times iptables -A... (instead of iptables-restore) because it
"downloads" the entire table n-times and sets the entire table n-times
(performing n*2 operations) while passing n^2 rules between kernel and
userspace.

The second and more interesting point is that this would also introduce
a timeframe where packets could slip through while these exchanges
between kernel and userspace are happening. Why does setting the policy
to DROP not solve this problem?

I asume these commands are processed from top to bottom, I couldn't
imagine of a opportunity when packets could slip through

example
(presuming an empty INPUT chain)

1: iptables -P INPUT DROP
2: iptables -A INPUT -s 10.0.0.0/8 -j DROP
3: iptables -A INPUT -p tcp --dport 22 --syn -j ACCEPT

After (1) the chain would be empty
after (2):
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
    0     0 DROP     all  --  *      *       10.0.0.0/8
0.0.0.0/0

(3):
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
    0     0 DROP     all  --  *      *       10.0.0.0/8
0.0.0.0/0
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0
0.0.0.0/0           tcp dpt:22

I'm not using iptables -A sequences in scripts anymore but would be
curious about this security risk anyway.

curious
Christoph A.


--------------enig71A2A338355FD42FE0A92CC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkp/QyQACgkQrq+riTAIEg2HgwCgm5xNGjb6Hv4fiBi+cvQ0KN0X
FOkAni5WATA3wdjXWJLKr1AJWVOXbJMb
=H84S
-----END PGP SIGNATURE-----

--------------enig71A2A338355FD42FE0A92CC5--
