From: "Christoph A." <casmls@gmail.com>
Subject: nftables: logging
Date: Wed, 29 Jul 2009 23:49:05 +0200
Message-ID: <4A70C3D1.7040809@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigD231E164BC4139B7C1B3C897"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:41778 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZG2Vv2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:51:28 -0400
Received: by ewy10 with SMTP id 10so324939ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2009 14:51:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD231E164BC4139B7C1B3C897
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

from iptables I'm used to see the logging output in the default syslog
files, with nftables this seams to be different.
My rule looks like this:

[...]
ct state new log prefix "start: " accept

but there are no log entries in the syslog file.
Where does nftables writes its logs?

The nft_log module is loaded:
lsmod|grep nft_l
nft_log                 1952  1
nf_tables              25540  43
nft_meta,nft_log,nft_payload,nft_ct,nft_rbtree,nft_hash,nf_tables_ipv4

For testing it would be very handy to have a working logging setup.

Is there already a way to dump the current rules from the kernel to
stdout (like iptables -vnL) - if this is even possible?

thanks,
Christoph A.


--------------enigD231E164BC4139B7C1B3C897
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkpww9YACgkQrq+riTAIEg1vowCgyZh6Cpg12wu6Yrgmhb07dMll
cXcAoOT0Y85z7SxVS4b3sXtRNu6+5355
=ND45
-----END PGP SIGNATURE-----

--------------enigD231E164BC4139B7C1B3C897--
