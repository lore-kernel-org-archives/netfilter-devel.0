From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] datatype: concat expression only releases dynamically
 allocated datatype
Date: Sat, 08 Jun 2013 12:13:41 +0200
Message-ID: <1370686421.5642.3.camel@ice-age.regit.org>
References: <1370518645-9812-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FMW6T0EkCNHcV0gs5VAz"
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53040 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3FHKNr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:13:47 -0400
In-Reply-To: <1370518645-9812-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-FMW6T0EkCNHcV0gs5VAz
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 06 juin 2013 =E0 13:37 +0200, Pablo Neira Ayuso a =E9crit :
> Eric Leblond reports a crash with the following invalid command:
>=20
>  nft add rule global filter ip daddr . tcp dport { 192.168.0.1 . 22\; 192=
.168.0.3 . 89 } drop

I confirm this patch fixes the issue.

BR,
--
Eric

--=-FMW6T0EkCNHcV0gs5VAz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRswPVnxA7CdMWjzIRAr0eAJ9mqUAeSMB67tjZUSeEsDEupe7u1wCfWLNC
UAGurwlejj/YMOFIxmFWRms=
=30Yu
-----END PGP SIGNATURE-----

--=-FMW6T0EkCNHcV0gs5VAz--

