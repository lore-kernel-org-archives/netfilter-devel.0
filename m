From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 13:47:08 +0100
Message-ID: <20141218134708.3b990466@turingmachine>
References: <20141218133524.4d6e2539@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vQ5J=rxRliNw8muMhGqV8xV"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:35502 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaLRMrK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:47:10 -0500
Received: from turingmachine (unknown [141.56.66.51])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id D169D78E4
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2014 13:47:08 +0100 (CET)
In-Reply-To: <20141218133524.4d6e2539@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/vQ5J=rxRliNw8muMhGqV8xV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I refactor the patch based on your feedback, however:
 =20
  $ nft flush ruleset

fails with:

  <cmdline>:1:1-13: Error: Could not process rule: Address family not suppo=
rted by protocol=20
  flush ruleset
  ^^^^^^^^^^^^^

  $ nft --version    =20
  nftables v0.4 (Support Edward Snowden)

  $ uname -a
  Linux turingmachine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2=
014 x86_64 GNU/Linux

--Sig_/vQ5J=rxRliNw8muMhGqV8xV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUkszMAAoJEMpBBrjXzHn6BNAH/3sl+GBVYpCLxaZ3yveW1iyg
mzUb+IpXPrRk+XyegHximOtySu3IL3SHyaxADIsDszG6/rOpAafozBYv5HLDZQQi
e3lcy6t5qDf4hbQkZmhyXw1FU8+zx0hJ4bihxApef8b1Z0GUWgr6vAahiQrDpZtr
ICHHFfDbGkD9lgh3CSjmOMXkz0NIK1HjyT+X2AhId5R77UoUDzyFQDr/zZzd32ER
AMXEYGh8o3MezWUut0qv4IRFQbB7cSuo/yATicUrpQLlX66huyLDFd/TGC6/nLd+
+LwzjAEdEnk6xOiS/Cj7LMgiXdV9GEOiCGtc6P8tijblE6ZMPpu3uFziS71Bmtw=
=/bmM
-----END PGP SIGNATURE-----

--Sig_/vQ5J=rxRliNw8muMhGqV8xV--
