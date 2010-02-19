From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Fri, 19 Feb 2010 15:29:43 +0100
Message-ID: <4B7EA057.10008@trash.net>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>	 <1266271377.2859.28.camel@edumazet-laptop>	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>	 <1266515463.2877.10.camel@edumazet-laptop>	 <48ceaa831002180955v4fd87e20o4e116c87f4f4b259@mail.gmail.com>	 <1266516452.2877.12.camel@edumazet-laptop>	 <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>	 <4B7D84C6.2040102@trash.net>	 <48ceaa831002181139k134dadbp2bc65857eac6af59@mail.gmail.com>	 <48ceaa831002181653o549964c3w76bc27dd66864f8b@mail.gmail.com> <1266588761.3136.12.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Afi Gjermund <afigjermund@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0BSO3p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:29:45 -0500
In-Reply-To: <1266588761.3136.12.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le jeudi 18 f=E9vrier 2010 =E0 16:53 -0800, Afi Gjermund a =E9crit :
>=20
> Thanks Afi for providing us more info :)
>=20
> Patrick, If a user application asks NF_STOLEN, we leak the skb.
> As the entry is freed, there is no way this skb can be found again.
>=20
> What do you think of following patch ?
> Or should we ignore NF_STOLEN status from user, to let packet still
> queued ?

I think dropping the packet is the expected behaviour.

> [PATCH] nf_queue: fix NF_STOLEN skb leak
>=20
> commit 3bc38712e3a6e059 (handle NF_STOP and unknown verdicts in
> nf_reinject) was a partial fix to packet leaks.
>=20
> If user asks NF_STOLEN status, we must free the skb as well.
>=20
>

Applied, thanks Eric.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
