From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Unable to get NPTv6 to work with kernel 3.8.2
Date: Mon, 11 Mar 2013 15:03:23 +0100
Message-ID: <513DE42B.5070702@universe-factory.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2OKOIPRLRJUXTPFEKJWOS"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([5.9.180.86]:52124 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab3CKOJM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:09:12 -0400
Received: from [IPv6:2001:6f8:1d26:0:3c48:5598:9865:c1a0] (unknown [IPv6:2001:6f8:1d26:0:3c48:5598:9865:c1a0])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chaos.universe-factory.net (Postfix) with ESMTPSA id 023021848FC
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2013 15:03:24 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2OKOIPRLRJUXTPFEKJWOS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
we are currently trying to switch from an own NPTv6 implementation [1]
to the new in-tree one.

The rules we've been trying out are:

ip6tables -t mangle -A PREROUTING -d fd00:0:0:3::/64 -j MARK --set-xmark
0x2a/0xffffffff
ip6tables -t mangle -A OUTPUT -d fd00:0:0:3::/64 -j MARK --set-xmark
0x2a/0xffffffff

ip6tables -t nat -A OUTPUT -d fd00:0:0:3::/64 -j DNPT --src-pfx
fd00:0:0:3::/64 --dst-pfx fd00:0:0:1::/64
ip6tables -t nat -A PREROUTING -d fd00:0:0:3::/64 -j DNPT --src-pfx
fd00:0:0:3::/64 --dst-pfx fd00:0:0:1::/64

ip6tables -t nat -A INPUT -s fd00:0:0:1::/64 -m mark --mark 0x2a -j SNPT
--src-pfx fd00:0:0:1::/64 --dst-pfx fd00:0:0:3::/64
ip6tables -t nat -A POSTROUTING -s fd00:0:0:1::/64 -m mark --mark 0x2a
-j SNPT --src-pfx fd00:0:0:1::/64 --dst-pfx fd00:0:0:3::/64
ip6tables -t nat -A POSTROUTING -s fd00:0:0:1::/64 -o test0 -j SNPT
--src-pfx fd00:0:0:1::/64 --dst-pfx fd00:0:0:3::/64

(With our old module, which worked complely in the mangle table, we
needed these complex rules to archieve the hairpinning behaviour
required by RFC6296, are such rules still necessary with the in-tree
implementation?)

We are seeing the strange behaviour that the first packet of a new flow
is translated correctly (tested with ICMP echo packets), regardless of
the direction of the first packet, but the reply and all subsequent
packets don't get translated at all.

This is the output of conntrack after starting a ping in both
directions, showing the untranslated addresses in both cases:

# conntrack -f ipv6 -L
icmpv6   58 10 src=3Dfd00:0:0:2::2 dst=3Dfd00::3:fffd:0:0:2 type=3D128 co=
de=3D0
id=3D811 [UNREPLIED] src=3Dfd00::3:fffd:0:0:2 dst=3Dfd00:0:0:2::2 type=3D=
129
code=3D0 id=3D811 mark=3D0 use=3D1
icmpv6   58 28 src=3Dfd00:0:0:1::2 dst=3Dfd00:0:0:2::2 type=3D128 code=3D=
0
id=3D1131 [UNREPLIED] src=3Dfd00:0:0:2::2 dst=3Dfd00:0:0:1::2 type=3D129 =
code=3D0
id=3D1131 mark=3D0 use=3D1
conntrack v1.4.1 (conntrack-tools): 2 flow entries have been shown.

Is there anything wrong with the rules? What can I do to debug the
problem? Please let me know if there is any more information I can
provide you to help you understand the issue.

Thanks in advance,
Matthias Schiffer


[1] http://git.universe-factory.net/NPTv6/


------enig2OKOIPRLRJUXTPFEKJWOS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlE95CsACgkQq3qIxbiQM9hUhgCgnMEGwndGPcXSaYbQk2CqdWqA
/gsAn2R9QnHhb0WBkYly2zvZgkkahVRS
=EtyE
-----END PGP SIGNATURE-----

------enig2OKOIPRLRJUXTPFEKJWOS--
