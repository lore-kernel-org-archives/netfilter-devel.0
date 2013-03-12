From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: Unable to get NPTv6 to work with kernel 3.8.2
Date: Tue, 12 Mar 2013 09:34:54 +0100
Message-ID: <513EE8AE.2090406@universe-factory.net>
References: <513DE42B.5070702@universe-factory.net> <20130312061101.GB7938@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2GXXMTQHJNGOPNHGKNONG"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([5.9.180.86]:54623 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab3CLIe6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:34:58 -0400
In-Reply-To: <20130312061101.GB7938@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GXXMTQHJNGOPNHGKNONG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/12/2013 07:11 AM, Florian Westphal wrote:
> Matthias Schiffer <mschiffer@universe-factory.net> wrote:
>> ip6tables -t nat -A OUTPUT -d fd00:0:0:3::/64 -j DNPT --src-pfx
>> fd00:0:0:3::/64 --dst-pfx fd00:0:0:1::/64
> [..]
>=20
> This won't work, DNPT is stateless, the nat table is only consulted
> for the first packet of a connection.
>=20
> Use mangle instead, this should also take care of possible new
> route due to changed dst address.
>=20

Ah, thanks for your pointer. Everything seems to work correctly now :)

Best regards,
Matthias Schiffer



------enig2GXXMTQHJNGOPNHGKNONG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlE+6K8ACgkQq3qIxbiQM9jTDACfSJxmOhzj6okvT1+dpdZ6oje6
YkMAoIEwoRlpG+VIAtsGkRNGfVCxd3mP
=1CTX
-----END PGP SIGNATURE-----

------enig2GXXMTQHJNGOPNHGKNONG--
