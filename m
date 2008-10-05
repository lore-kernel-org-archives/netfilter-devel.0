From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 23:51:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810052346110.17496@blackhole.kfki.hu>
References: <48E8B439.6030608@trash.net> <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-264467608-1223243472=:17496"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:46083 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbYJEVvN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:51:13 -0400
In-Reply-To: <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-264467608-1223243472=:17496
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 5 Oct 2008, Jan Engelhardt wrote:

> What I really certainly would like to see is that we somehow get rid
> of the oddness of naming L3 trackers and L4 trackers. Right now we
> have (two examples)
>=20
> -rw-r--r-- 1 15924 2008-09-09 20:34 nf_conntrack_ftp.c
> -rw-r--r-- 1 43369 2008-09-09 20:33 nf_conntrack_proto_tcp.c
>=20
> and in everybody's mind, FTP is a protocol too of course, =FF=FFso why
> does not ftp have a _proto part, and why does TCP?=FF=FF one might ask.
> We could just remove the _proto part (also helpful to reduce the
> name length), as there is no clash between L3 and L4 trackers
> except perhaps for proto_generic and l3proto_generic. Hm?

I'd regard it more odd if the _proto part would just be stripped off.=20
ICMP(v6)/TCP/UDP/STCP/etc. are fundamentally different from FTP/IRC/etc:
the latter are "just" helpers while the former ones build up the heart of=
=20
conntrack. Do not just mix the two things in the naming.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-264467608-1223243472=:17496--
