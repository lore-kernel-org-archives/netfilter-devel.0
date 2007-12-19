From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] iptables and NO_SHARED_LIBS/dlfcn.h
Date: Wed, 19 Dec 2007 07:49:39 -0500
Message-ID: <200712190749.40184.vapier@gentoo.org>
References: <200712190715.46466.vapier@gentoo.org> <Pine.LNX.4.64.0712191318100.12329@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1304201.WOoo2TJuEf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42012 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbXLSMtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:49:41 -0500
In-Reply-To: <Pine.LNX.4.64.0712191318100.12329@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart1304201.WOoo2TJuEf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 19 December 2007, Jan Engelhardt wrote:
> On Dec 19 2007 07:15, Mike Frysinger wrote:
> >if NO_SHARED_LIBS is defined, then iptables shouldnt even include
> >dlfcn.h. otherwise you hit a build failure when using toolchains
> >that do not provide dlfcn.h because they do not support shared
> >objects.
>
> Ideally such things would be done by autotools. Patch still floating :)

i agree 100%, but i work with what i've got, and what i've got is svn trunk=
=20
which is still just a Makefile ;)
=2Dmike

--nextPart1304201.WOoo2TJuEf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR2kTZEFjO5/oN/WBAQKADw//WEQBL6C3/Wmkwlz05P1Uadf6l0ZlX8a7
+oieinbF7ylDqaS09HWAgzdlOkU8I+zzoWvqJEgnwmpCwqRm8h8xuFUbsf7n+cql
IXEgT7DPwCxRm+j4oFOR/xok/4e8pUMEy9XxdxW06fELMov3LGVlzfB/nRFSaeqQ
m5yPiPRSGRgQLbm3k6K++11Ly20O0gkkrmKKSxNzCjwFj95nr33UVWGVVMGrSjZ9
YmRCbkHHYzERC9QX2a+EroM5HhBOrY+5BqQJnytacpVls106ArEPGkZ8CAS/b9eZ
flBjMSMKdD6YkYPRORWA/Mi+YtRJSPnT5plWjYGABNtwY41ccL2v8wzu9EiACq5v
CalTf8EGGfnlvMsk3c0bpzgJqCmZcGKQplZTBxc0Ow5XKfIhDZQuu4HT23Vog8kY
S9GWqrcqNrPjn4t4bIs1Q0cTK/8b+hSTsn6kVTBz+ynDtQMX49CjOYswihpj3wDa
7P8Zk/rVuterawu3deKL/uBaIEbu9iT1FAzZpFy31MrvsoFAkGrukdLpB6nNkEiH
CG94yUWoEylrcFHWh+OlN/KPCd003Mr3fGq2gfPaX7hzj6bBgSf11j25Kx5dnuwH
57oaiBHJkkhK/hJ3iCLFetChwEiWazcCcxlSnnbYBvDpeiopg82xhGwK46yEMd83
aRpKxO8VRRg=
=trdn
-----END PGP SIGNATURE-----

--nextPart1304201.WOoo2TJuEf--
