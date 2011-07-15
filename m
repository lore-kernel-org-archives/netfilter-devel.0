From: Philip Craig <philipjcraig@gmail.com>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 15:48:32 +1000
Message-ID: <4E1FD4B0.3030505@gmail.com>
References: <4E1F0F88.3090704@student.ulg.ac.be>	<alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>	<4E1F1902.9020605@student.ulg.ac.be>	<alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Terry_Mo=EBs?= <T.Moes@student.ulg.ac.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52432 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964770Ab1GOFsi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:48:38 -0400
Received: by gwaa18 with SMTP id a18so414005gwa.19
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2011 22:48:37 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 15, 2011 at 9:15 AM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Thursday 2011-07-14 18:27, Terry Mo=C3=ABs wrote:
>>Multi-Homing. One network can be a client of several ISPs in order to
>>ensure redundancy or in order to reduce costs. These different ISPs
>>will assign the client different prefixes. However, it can be desired
>>that the client does not have to modify the topology of his subnet ea=
ch
>>time he switches from one ISP to another.
>
> When switching the provider, consider:
>
> - If ISP2 blocks packets with source address SRC1, you are busted. NA=
T
> won't fix your problem:
>
> - reason 1: NAT is applied per CT and does not automatically change
> while a CT exists.
>
> - reason 2: Even if it did, packets of your connection would suddenly
> have SRC2, and the remote side would reject it with TCP RST, because =
it
> only knows a connection with SRC1.

I don't see how either of those reasons apply to the situation. The goa=
l
here is to have multiple ISP links, and use them for redundancy and/or
load balancing at a connection level, not to have the same connection g=
o
over both links.

So neither of those reasons stops you from:
- creating a new connection via ISP2 using SRC2
- using multiple connections from SRC1 and SRC2 simultaneously

IPv4 NAT allows you to do the above without needing multiple addresses
on your internal network, and without needing each client on your
internal network to choose which ISP to use for each connection.
It also ensures that the reply packets come back on the same link.

Maybe IPv6 has solved that problem, but I'm not aware of how.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
