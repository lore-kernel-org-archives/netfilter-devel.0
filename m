From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to l4proto->packet
Date: Thu, 12 Mar 2009 16:49:03 +0100
Message-ID: <200903121649.07014.christoph.paasch@gmail.com>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com> <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13603152.0ynvLJkX3S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:41378 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZCLPtL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:49:11 -0400
Received: by ewy25 with SMTP id 25so404111ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2009 08:49:09 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart13603152.0ynvLJkX3S
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


On Thu March 12 2009 wrote Jan Engelhardt:
> On Thursday 2009-03-12 16:13, Christoph Paasch wrote:
> >As NF_DROP =3D 0, no packets would ever have been dropped.
>
> Mh would not it be safer to actually give NF_DROP a real value so that
> -NF_DROP also makes sense?
Yes, why not...

> (Might need checking places where NF_DROP is used.)
NF_DROP is used only in tcp_packet (as far as I can see, no other l4 proto=
=20
uses it in *_packet)


=2D-
Christoph Paasch

www.rollerbulls.be
=2D-

--nextPart13603152.0ynvLJkX3S
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm5Lu8ACgkQLHtZTroOLZumcwCgntJu3iYT4Igx0MfLQc88aEeG
8/AAmwV1SRk2RpD1/dDSaOlB1m85Afxe
=c0TZ
-----END PGP SIGNATURE-----

--nextPart13603152.0ynvLJkX3S--
