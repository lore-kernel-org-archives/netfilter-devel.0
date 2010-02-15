From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Mon, 15 Feb 2010 21:04:47 +0100
Message-ID: <1266264287.2859.0.camel@edumazet-laptop>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40442 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0BOUEw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:04:52 -0500
Received: by bwz5 with SMTP id 5so1375360bwz.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 12:04:51 -0800 (PST)
In-Reply-To: <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 f=C3=A9vrier 2010 =C3=A0 11:30 -0800, Afi Gjermund a =C3=A9=
crit :
> root@titan ~# ./conntrack -L conntrack
> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 packe=
ts=3D89099
> bytes=3D12968758 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pack=
ets=3D110358
> bytes=3D17041625 [ASSURED] mark=3D0 use=3D1
> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 packe=
ts=3D87867
> bytes=3D12816098 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pack=
ets=3D107497
> bytes=3D16573614 [ASSURED] mark=3D0 use=3D1
> conntrack v0.9.14 (conntrack-tools): 2 flow entries have been shown.
>=20

This looks strange...


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
