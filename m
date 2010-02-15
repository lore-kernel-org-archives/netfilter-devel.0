From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Mon, 15 Feb 2010 22:52:37 +0100
Message-ID: <1266270757.2859.27.camel@edumazet-laptop>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61188 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab0BOVwm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:52:42 -0500
Received: by bwz5 with SMTP id 5so1448735bwz.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 13:52:40 -0800 (PST)
In-Reply-To: <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 f=C3=A9vrier 2010 =C3=A0 13:08 -0800, Afi Gjermund a =C3=A9=
crit :
> >
> On my 2.6.26.5 kernel I do not have CONFIG_NAMESPACES set.

could you post the result of 'netstat -s' ?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
