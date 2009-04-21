From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: iptables specify path to kernel headers
Date: Tue, 21 Apr 2009 16:44:02 +0200
Message-ID: <200904211644.06139.christoph.paasch@gmail.com>
References: <200904211613.45467.christoph.paasch@gmail.com> <alpine.LSU.2.00.0904211615040.26689@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart65286618.A0e9sOOFNx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58304 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZDUOoR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:44:17 -0400
Received: by ewy24 with SMTP id 24so1624732ewy.37
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2009 07:44:16 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0904211615040.26689@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart65286618.A0e9sOOFNx
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


On Tue April 21 2009 wrote Jan Engelhardt:
> On Tuesday 2009-04-21 16:13, Christoph Paasch wrote:
> >is there a way to specify a custom path to the kernel headers when
> > compiling iptables?
>
> iptables does not rely on external kernel headers anymore.
Ups, right...

I was asking myself, how libip6t_ipv6header.c knows IPPROTO_HOPOPTS. It com=
es=20
from <netinet/in.h>. :-)

Thanks...

=2D-
Christoph Paasch

www.rollerbulls.be
=2D-

--nextPart65286618.A0e9sOOFNx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknt27MACgkQLHtZTroOLZtMkgCfbaAXFeq9vOa9deUZ/b9MzXWA
2n4An3fH3km5IT3qgWc3u6H72rPUDLpk
=+Y5D
-----END PGP SIGNATURE-----

--nextPart65286618.A0e9sOOFNx--
