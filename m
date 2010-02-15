From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 13:08:11 -0800
Message-ID: <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:59779 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab0BOVIM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:08:12 -0500
Received: by pzk35 with SMTP id 35so649789pzk.33
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 13:08:11 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2010 at 12:33 PM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
> On Monday 2010-02-15 21:04, Eric Dumazet wrote:
>>Le lundi 15 f=E9vrier 2010 =E0 11:30 -0800, Afi Gjermund a =E9crit :
>>> root@titan ~# ./conntrack -L conntrack
>>> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pac=
kets=3D89099
>>> bytes=3D12968758 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pa=
ckets=3D110358
>>> bytes=3D17041625 [ASSURED] mark=3D0 use=3D1
>>> udp      17 179 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pac=
kets=3D87867
>>> bytes=3D12816098 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 pa=
ckets=3D107497
>>> bytes=3D16573614 [ASSURED] mark=3D0 use=3D1
>>> conntrack v0.9.14 (conntrack-tools): 2 flow entries have been shown=
=2E
>>>
>>
>>This looks strange...
>
> Could it be that there are ct entries in other namespaces that
> conntrack -L and /proc/net/nf_conntrack does not show,
> but which nf_conntrack_count counts?
> If the procfs files are netns safe at all..
>
On my 2.6.26.5 kernel I do not have CONFIG_NAMESPACES set.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
