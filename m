From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Kernel 2.6.24 and ipset - problem
Date: Tue, 12 Feb 2008 11:06:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802121102410.17778@blackhole.kfki.hu>
References: <1202063681.6433.10.camel@steven.kity.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1119839562-1202810765=:17778"
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:38736 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810AbYBLKGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:06:08 -0500
In-Reply-To: <1202063681.6433.10.camel@steven.kity.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1119839562-1202810765=:17778
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Sun, 3 Feb 2008, Krzysztof Mo=B6cicki wrote:

> I have kernel 2.6.24 and ipset with patch-o-matic-ng-20080122.
>=20
> # ipset -V
> ipset v2.2.9a Protocol version 2.
>=20
> Below logs from syslog.
>=20
> Feb  2 13:05:11 cerber2h ipset: page allocation failure. order:7, mode:0x=
d0

I have just committed a fix in the patch-o-matic-ng svn. Could you give a=
=20
try to this version and report back whether it relaxes successfully the=20
hammering of the memory?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1119839562-1202810765=:17778--
