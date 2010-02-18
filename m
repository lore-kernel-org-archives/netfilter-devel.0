From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Thu, 18 Feb 2010 18:51:03 +0100
Message-ID: <1266515463.2877.10.camel@edumazet-laptop>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44534 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab0BRRvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:51:10 -0500
Received: by bwz1 with SMTP id 1so400145bwz.21
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 09:51:08 -0800 (PST)
In-Reply-To: <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 18 f=C3=A9vrier 2010 =C3=A0 09:40 -0800, Afi Gjermund a =C3=A9=
crit :
> I am still trying to figure out why the nf_conntrack_count differs
> from the table system.  I decided I would use the conntrack userspace
> tools.
> Both of my NICs are unplugged with no other userspace applications
> running to affect connection tracking counts.
>=20
>=20
> root@titan ~# date
> Thu Feb 18 17:35:21 UTC 2010
>=20
> root@titan ~# ./conntrack -C conntrack
> 351
>=20
> root@titan ~# date
> Thu Feb 18 17:35:24 UTC 2010
>=20
> root@titan ~# ./conntrack -F conntrack
> conntrack v0.9.14 (conntrack-tools): connection tracking table has be=
en emptied.
>=20
> root@titan ~# date
> Thu Feb 18 17:35:31 UTC 2010
>=20
> root@titan ~# ./conntrack -C conntrack
> 351
>=20
> root@titan ~# date
> Thu Feb 18 17:35:36 UTC 2010
>=20
> Shouldn't the value after the flush be 0? The traffic that has create=
d
> this mess is from a REDIRECT rule in the PREROUTING chain of the 'nat=
'
> table.

Could you post a copy of these rules ?

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
