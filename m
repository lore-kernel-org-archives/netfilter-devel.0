From: "Christoph A." <casmls@gmail.com>
Subject: [nftables] optimization steps before rules get send to the kernel
Date: Thu, 13 Aug 2009 23:33:43 +0200
Message-ID: <4A8486B7.2070308@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig72D0E5BCD88A0BD28DFF02A5"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:55544 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZHMVgi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:36:38 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1052138fga.17
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2009 14:36:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig72D0E5BCD88A0BD28DFF02A5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

from the nftables announcement:

> Redundant information might get lost before it is sent to the kernel,
> but both the kernel and the reconstructed ruleset are semantically
> equivalent.

As I'm currently not aware of a possibility to dump the actual rules
currently used by the kernel, to investigate this myself, I would have
another question:

Does the optimization which removes redundant information also remove
entire redundant rules or redundant checks within rules?

example:

ip saddr 1.1.1.1 tcp dport 22 accept
tcp dport 22 accept

would become
tcp dport 22 accept


tcp sport 0-65535 tcp dport 80 accept
would become
tcp dport 80 accept

if not: is something like this planed for the future or will the
stupidity of big rulesets never be removed by nftables? ;)

thanks,
Christoph





--------------enig72D0E5BCD88A0BD28DFF02A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkqEhrwACgkQrq+riTAIEg3/5wCeO0mf0sgl71JVALWp6ZRXFMB+
A2QAnjAeoyQnpNfsfD7ze2T2RWy7r1+u
=RDrO
-----END PGP SIGNATURE-----

--------------enig72D0E5BCD88A0BD28DFF02A5--
