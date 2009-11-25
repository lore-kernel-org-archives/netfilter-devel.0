From: Olivier Mehani <olivier.mehani@inria.fr>
Subject: [xtables-addons] "unknown option `--gw'" for target TEE
Date: Wed, 25 Nov 2009 09:34:34 +0100
Message-ID: <20091125083434.GC4295@lxiv.inria.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Cc: Sebastian =?iso-8859-15?Q?Cla=DFen?=
	<sebastian.classen@freenet.de>, Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:37853 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbZKYIop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:44:45 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm trying to copy the IPv6 traffic a router sees on eth0 to a logging
machine on eth1's netmork:

[LOG]eth0--(PFX1::/64)--eth1[ROUTER]eth0---(PFX2::/64)


I installed xtables-addons 1.20 on top of iptables 1.4.5 and kernel
2.6.30 (x86_64) and want to use the TEE target. I however get an error
when trying to use it.

# ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gw PFX1:46ff:fee0:dfcc
ip6tables v1.4.5: unknown option `--gw'
Try `ip6tables -h' or 'ip6tables --help' for more information.

As far as my understanding of the doc goes, my command is valid, but it
doesn't work.

What am I doing wrong/misunderstanding?

Thanks in advance.

--=20
Olivier Mehani <olivier.mehani@inria.fr>
PGP fingerprint: 4435 CF6A 7C8D DD9B E2DE  F5F9 F012 A6E2 98C6 6655

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLDOwaAAoJEPASpuKYxmZVWPwH/0pEMokzvVomkc/QFfPDasOO
o2EfoMdiP+3T4J+whADheJjzkUX3MEsCmz+Xdq5B1Ijzb8P2G1Jo/t8MpHNSgWHs
n2MwhTNPINlfUrGrAJYnO0Ut1DnjsC113k5lWWod1YK09khRHwadLyXmGWceC9hN
w/LZyvl/hihVnYcIht+X8sdqcmP8sp21+5Tvf1eEwf+9DLliipbmFsj8pGUicgvi
FvbZ9ic/87ZpNSG5R5Nspn0LOB/TBOxOluNdPWHWayVPCWnBe3IxGR+z6wv5C92T
ndyPHjSXmqtt/98K4Wzk3Oe4jzq/3HHDNc+Gdsuazh3RXhESow8pIenyNyzufUA=
=X16M
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
