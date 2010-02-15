From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 14:00:36 -0800
Message-ID: <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:54706 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0BOWAk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:00:40 -0500
Received: by pxi29 with SMTP id 29so1331354pxi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 14:00:39 -0800 (PST)
In-Reply-To: <1266270757.2859.27.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2010 at 1:52 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le lundi 15 f=E9vrier 2010 =E0 13:08 -0800, Afi Gjermund a =E9crit :
>> >
>> On my 2.6.26.5 kernel I do not have CONFIG_NAMESPACES set.
>
> could you post the result of 'netstat -s' ?
>
>
>

Unfortunately the Busybox version of netstat doesn't have the statistic=
s option.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
