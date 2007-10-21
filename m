From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Set compile problem with kernel 2.6.23.1
Date: Sun, 21 Oct 2007 20:44:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710212043040.477@blackhole.kfki.hu>
References: <1192979789.4860.0.camel@steven.kity.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-2128734794-1192992296=:477"
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:53540 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbXJUSo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:44:58 -0400
In-Reply-To: <1192979789.4860.0.camel@steven.kity.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-2128734794-1192992296=:477
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Sun, 21 Oct 2007, Krzysztof Mo=B6cicki wrote:

> While trying to compile vanilla kernel 2.6.23.1 with
> patch-o-matic-ng-20070828 or patch-o-matic-ng-20071020 (using extension
> set) I'm getting following error:
>=20
>   CC [M]  net/ipv4/netfilter/ipt_SET.o
>   CC [M]  net/ipv4/netfilter/ip_set.o
> net/ipv4/netfilter/ip_set.c:1931: error: unknown field `use' specified
> in initializer

I have updated ipset in svn and added a new snapshot to=20
ipset.netfilter.org, please use that: a compatibility fix was required for=
=20
2.6.23 and upward.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-2128734794-1192992296=:477--
