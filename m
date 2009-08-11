From: "Christoph A." <casmls@gmail.com>
Subject: [nft] numeric ip protocol values and omitting filter tablename
Date: Tue, 11 Aug 2009 23:52:01 +0200
Message-ID: <4A81E801.606@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig25BEBDFF905EF9E0246E15F6"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:52385 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZHKVy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:54:58 -0400
Received: by fxm28 with SMTP id 28so1804715fxm.17
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2009 14:54:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25BEBDFF905EF9E0246E15F6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Is the default table (filter) also mandatory?

# nft add rule filter input meta iifname eth0 accept  (works)
# nft add rule input meta iifname eth0 accept
<cmdline>:1:16-19: Error: syntax error, unexpected meta, expecting string=

add rule input meta iifname eth0 accept
               ^^^^


just in case this is not expected:

# nft add rule filter input ip protocol 6 accept
<cmdline>:1:35-35: Error: Could not resolve protocol name
add rule filter input ip protocol 6 accept

ip protocol TCP accept (works)

kind regards,
Christoph


--------------enig25BEBDFF905EF9E0246E15F6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkqB6BQACgkQrq+riTAIEg3bPACeLZ7TP0eL35oZJL3pfYBTeX47
T6EAniOy9Y9FlccDRQyI4j15WoaJvWwo
=G6Hv
-----END PGP SIGNATURE-----

--------------enig25BEBDFF905EF9E0246E15F6--
