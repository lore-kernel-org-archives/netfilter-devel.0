From: Maxim Britov <maxim.britov@gmail.com>
Subject: Re: iptables 1.4.1 + iprange fails for me
Date: Fri, 13 Jun 2008 13:24:04 +0300
Message-ID: <20080613132404.3c7e2543@maxim.office.modum.by>
References: <20080613090236.417411cd@maxim.office.modum.by>
	<alpine.LNX.1.10.0806131047070.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EN=vX8SaKJFhvbhr+rCLfpW";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.office.modum.by ([212.98.173.82]:54514 "EHLO
	mail.office.modum.by" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYFMKYk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:24:40 -0400
In-Reply-To: <alpine.LNX.1.10.0806131047070.23098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/EN=vX8SaKJFhvbhr+rCLfpW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jun 2008 10:47:40 +0200 (CEST)
 Jan Engelhardt wrote:

> On Friday 2008-06-13 08:02, Maxim Britov wrote:
>=20
> >I updated yesterday kernel + iptables on my router (into Internet) box.
> >Kernel from kernel.org 2.6.25.6 + iptables 1.4.1-1 from fedora rawhide.
> >I'm use kernel without modules on that box.
> >
> >I found troubles with iprange:
> ># iptables -A INPUT -m iprange --src-range 1.1.1.1-2.2.2.2 -j DROP
> ># iptables-save |fgrep range
> >-A INPUT -m iprange -j DROP
> >
> >iptables -L -n show it as:
> >DROP       all  --  0.0.0.0/0            0.0.0.0/0          =20
> >
>=20
> commit 5aba9d57d07b3f5474f3c0e71e9309a841e932ae
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Jun 13 10:43:01 2008 +0200

Thanks. Seems fixed for me.


--=20
Maxim Britov

GnuPG KeyID 0x4580A6D66F3DB1FB              xmpp:maxim@modum.by
Fingerprint:  4059 B5C5 8985 5A47 8F5A 8623 4580 A6D6 6F3D B1FB
GnuPG-ru Team (http://lists.gnupg.org/mailman/listinfo/gnupg-ru
               xmpp:gnupg-ru@conference.jabber.ru)

--Sig_/EN=vX8SaKJFhvbhr+rCLfpW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJIUkrNAAoJEOS1BTjOtE8G2WcP/jSqXTcxRRoiBe71N69+2cse
tGmAHpH1JOS99H48Csso3HW6q2KFefpeQ41Z39wHrYnyowqGRzpynip5EoUEbWwi
wC38CXPqVj13gIC2wEkSZ/UNEk7SKO2n1DdqXsB3EkoE09CJKJcnkDEHy9+qqmj4
Lz1oEqdBHE9aOEX4kj1N06ws7YxJsF7IdLHkV2ABFda9GN+oKMRonh2BoQrogj3J
KHMcqjAv8DaQYu90K29kO8UwNfNuXXfhY1MODWceKoKX8MmoqxJWprZ9ehGz6YIt
mrv6gige43ftO1Ybj/GDvcEcY0AQrwB7Sv1SvveYzVItf10+4cQ6fntxbmD/7/Sz
cWZTm+IdY+Q/l9oqxEL+LDq74xnF0Nf35FD9oMMN2W2SLL7vSwzo5MnFtPw2L5rB
lDsIM1W98sgXSFiUqbA1k7H/ule28jZO8ATehgSvniCoynsRRRrEH+wljVg0x+WA
t35+9OGmsRemmnQlEb3csL3JuAtnniRVSY3F35YgrU/ez7FDlidUkcWVCwwsDfBJ
c1B1asXpNB+I/xM7FvQdYhXfBqHB+ROFvYDpJfWrFk3BdteOeTx4fwuZYiYNhG/S
zpqL/hJJEqspExnU64G+AtDwv50LVSxOicH/CwWFDddxXj3XXT9OuvKdDucvmWW3
c8zTJZYoba1tyJd4k8hf
=fHSN
-----END PGP SIGNATURE-----

--Sig_/EN=vX8SaKJFhvbhr+rCLfpW--
