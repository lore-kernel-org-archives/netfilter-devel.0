From: "Christoph A." <casmls@gmail.com>
Subject: building nftables: =?UTF-8?B?4oCYbmZubF9uZnRfc2V0X2luaXTigJkgdW5k?=
 =?UTF-8?B?ZWNsYXJlZA==?=
Date: Sat, 18 Jul 2009 13:54:05 +0200
Message-ID: <4A61B7DD.9050201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig00DDCB195678539749BC44AB"
Cc: farchanjo@gmail.com, "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:37703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZGRL4N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:56:13 -0400
Received: by fg-out-1718.google.com with SMTP id e12so261995fga.17
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jul 2009 04:56:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig00DDCB195678539749BC44AB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi!

I'm building a enviroment where I can paly around with nftables.

Building libnl-nft I encountered the same problem as described here:

http://osdir.com/ml/general/2009-04/msg03933.html

I "resolved" that error by commenting these lines out (nft_data.c):

 22 enum nft_data_types {
 23         NFT_DATA_VALUE,
 24         NFT_DATA_VERDICT,
 25 };

Stepping to the next task, building nftables, I get the following errors:=


  CC		src/netlink_linearize.c
src/netlink_linearize.c: In function =E2=80=98netlink_gen_map=E2=80=99:
src/netlink_linearize.c:126: error: =E2=80=98nfnl_nft_set_init=E2=80=99 u=
ndeclared
(first use in this function)
src/netlink_linearize.c:126: error: (Each undeclared identifier is
reported only once
src/netlink_linearize.c:126: error: for each function it appears in.)
cc1: warnings being treated as errors
src/netlink_linearize.c:127: error: implicit declaration of function
=E2=80=98nfnl_nft_set_set_flags=E2=80=99
src/netlink_linearize.c:128: error: implicit declaration of function
=E2=80=98nfnl_nft_set_set_sreg=E2=80=99
src/netlink_linearize.c:129: error: implicit declaration of function
=E2=80=98nfnl_nft_set_set_klen=E2=80=99
src/netlink_linearize.c:130: error: implicit declaration of function
=E2=80=98nfnl_nft_set_set_dreg=E2=80=99
src/netlink_linearize.c:131: error: implicit declaration of function
=E2=80=98nfnl_nft_set_set_dlen=E2=80=99
src/netlink_linearize.c:156: error: implicit declaration of function
=E2=80=98nfnl_nft_set_add_mapping=E2=80=99
src/netlink_linearize.c: In function =E2=80=98netlink_gen_lookup=E2=80=99=
:
src/netlink_linearize.c:180: error: =E2=80=98nfnl_nft_set_init=E2=80=99 u=
ndeclared
(first use in this function)
src/netlink_linearize.c:196: error: implicit declaration of function
=E2=80=98nfnl_nft_set_add_elem=E2=80=99
make[1]: *** [src/netlink_linearize.o] Error 1
make: *** [src] Error 2

I was not able to resolve this errors.

I'm using the latest version from git:
git://git.netfilter.org/nftables.git

Any help would be appreciated!
Christoph


--------------enig00DDCB195678539749BC44AB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkpht/EACgkQrq+riTAIEg3GxACgusps61/QR5HNzYlPllkpZMZ+
YXEAoIrub/Cy9991hlvOqqNEcKRQb+eT
=lKbu
-----END PGP SIGNATURE-----

--------------enig00DDCB195678539749BC44AB--
