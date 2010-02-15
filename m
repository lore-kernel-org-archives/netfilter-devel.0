From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Mon, 15 Feb 2010 22:17:17 +0100
Message-ID: <1266268637.2859.26.camel@edumazet-laptop>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Afi Gjermund <afigjermund@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33550 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0BOVRY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:17:24 -0500
Received: by bwz5 with SMTP id 5so1425166bwz.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 13:17:21 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 f=C3=A9vrier 2010 =C3=A0 21:33 +0100, Jan Engelhardt a =C3=A9=
crit :
> On Monday 2010-02-15 21:04, Eric Dumazet wrote:
> >Le lundi 15 f=C3=A9vrier 2010 =C3=A0 11:30 -0800, Afi Gjermund a =C3=
=A9crit :
> >> root@titan ~# ./conntrack -L conntrack
> >> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pa=
ckets=3D89099
> >> bytes=3D12968758 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 p=
ackets=3D110358
> >> bytes=3D17041625 [ASSURED] mark=3D0 use=3D1
> >> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pa=
ckets=3D87867
> >> bytes=3D12816098 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 p=
ackets=3D107497
> >> bytes=3D16573614 [ASSURED] mark=3D0 use=3D1
> >> conntrack v0.9.14 (conntrack-tools): 2 flow entries have been show=
n.
> >>=20
> >
> >This looks strange...
>=20
> Could it be that there are ct entries in other namespaces that
> conntrack -L and /proc/net/nf_conntrack does not show,
> but which nf_conntrack_count counts?
> If the procfs files are netns safe at all..

Well, its an embedded platform, I doubt it is namespace enabled :)

(and kernel version is 2.6.26.5, not yet namespace ready for conntrack)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
