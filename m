From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Add seperated timeout for the connections that only receive
	packets in one direction
Date: Mon, 30 Nov 2009 12:39:17 +0800
Message-ID: <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:52728 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZK3EjQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2009 23:39:16 -0500
Received: by pzk1 with SMTP id 1so2237319pzk.33
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Nov 2009 20:39:22 -0800 (PST)
In-Reply-To: <4B0FBC5F.8030108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 27, 2009 at 7:47 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Changli Gao wrote:
>> It is not easy to spoof in both directions. Routers won't forward it=
 if the destination is at the same side.
>
> Please don't top post.

Sorry, I don't notice that G1 top posts.

>
> They don't need to forward anything, conntrack handles the packet bef=
ore
> routing.
>

Think about this topologic:

Attacker -> router1 -> router2 -> ... -> Linux Router -> Apache.

the packets in the other direction won't be sent to the Linux Router,
as the other routers will routed them to the other place.

Case 2:

Attacker ---+
                +-- Linux Router --> WAN
Victim-------+

If we do sth. like RPF before entering conntrack, the packets in the
other direction won't be in.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
