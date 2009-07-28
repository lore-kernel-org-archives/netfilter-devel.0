From: "Christoph A." <casmls@gmail.com>
Subject: Re: nftables: problem with sets (Object not found)
Date: Tue, 28 Jul 2009 22:13:50 +0200
Message-ID: <4A6F5BFE.9070807@gmail.com>
References: <4A69FCC3.1070404@gmail.com> <4A6EEDBA.3010505@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig594EBB86F5B34F206D64E0AC"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	"Christoph A." <casmls@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63496 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZG1UQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:16:09 -0400
Received: by ewy26 with SMTP id 26so329256ewy.37
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2009 13:16:07 -0700 (PDT)
In-Reply-To: <4A6EEDBA.3010505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig594EBB86F5B34F206D64E0AC
Content-Type: multipart/mixed;
 boundary="------------090507070308070903090207"

This is a multi-part message in MIME format.
--------------090507070308070903090207
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 28.07.2009 14:23, Patrick McHardy wrote:
> I never pushed out the userspace changes for the new set API.
> I just pushed out all the changes that should be needed, please
> update your trees and try again.
>=20

pulled, compiled, works.

thanks!
Christoph A.

nft -f main1
insert: [c0a80100 c0a801ff]
insert: [2020202 2020202]
insert: [c0a83801 c0a83801]
iter: [2020202 2020202]
iter: [c0a80100 c0a801ff]
iter: [c0a83801 c0a83801]
list: [00000000 02020201]
list: [02020202 02020202]
list: [02020203 c0a800ff]
list: [c0a80100 c0a801ff]
list: [c0a80200 c0a83800]
list: [c0a83801 c0a83801]
list: [c0a83802 ffffffff]
{ 0.0.0.0, 2.2.2.2, 2.2.2.3, 192.168.1.0, 192.168.2.0, 192.168.56.1,
192.168.56.2}

(I guess the second IPs ...2.3, ..2.0, ..56.2 are the upper bound of the
range)

--------------090507070308070903090207
Content-Type: text/plain;
 name="main1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="main1"

define sshclient =3D 192.168.56.1
define foo =3D 2.2.2.2
define localnet =3D 192.168.1.0/24
define allowed_ssh_hosts =3D { $sshclient, $foo, $localnet }

define sshport =3D 22
define httpport =3D 999

flush table filter
delete table filter

table filter {
=09
	chain input {
		hook NF_INET_LOCAL_IN 0

		ct state related,established accept
		#ip saddr { $sshclient, $foo, $localnet } tcp dport $sshport ct state n=
ew accept
		ip saddr $allowed_ssh_hosts tcp dport $sshport ct state new accept
		ip saddr $sshclient tcp dport $httpport ct state new accept
		drop
	}

	chain output {
		hook NF_INET_LOCAL_OUT 0
		ct state related,established accept
		drop
	}
}

--------------090507070308070903090207--

--------------enig594EBB86F5B34F206D64E0AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkpvXAIACgkQrq+riTAIEg2UXgCfcA6E3DE0Taa5vIa/+KdGpKVM
hRcAn2rTxwCrdOvRra1ChUIyhjDnc77t
=CPy2
-----END PGP SIGNATURE-----

--------------enig594EBB86F5B34F206D64E0AC--
