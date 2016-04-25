From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ipset set type - hash:ip,mac
Date: Mon, 25 Apr 2016 11:18:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1604251117280.5773@blackhole.kfki.hu>
References: <8357c05ce35b35c21e8e06dd43f4d5b8@chilan.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-948068085-1461575892=:5773"
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-2?Q?Tomasz_Chili=F1ski?= <tomasz.chilinski@chilan.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:45742 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbcDYJRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 05:17:13 -0400
In-Reply-To: <8357c05ce35b35c21e8e06dd43f4d5b8@chilan.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-948068085-1461575892=:5773
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 24 Apr 2016, Tomasz Chili=C5=84ski wrote:

> First - thanks a lot for excellent ipset toolkit!
> Second - Sorry for posting directly to you, but didn't get reply from
> netfilter-devel
> mailing list after trying to subscribe there.
>=20
> I've created lately my own very missed set type hash:ip,mac
> which stored any ipv4/ipv6 - mac pairs using hashing structures.
> It allows to create only single set with all addresses and macs
> used in quite large lans without bothering with separated sets
> for different ip segments.
>=20
> I've attached patches for kernel 4.1 and ipset 6.29.
> I could also prepare for newer kernel versions if one would be
> interested in it ;-)
>=20
> Any feedback or small review would be very appreciated!

Thanks your patch, I'll review and report back.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-948068085-1461575892=:5773--
