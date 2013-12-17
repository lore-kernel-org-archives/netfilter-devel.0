From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Tue, 17 Dec 2013 22:46:32 +0800
Message-ID: <CABa6K_F1iUXHq6kDi4QEX-w=kO+Gy9em8G34r44=Qtce1A77Tw@mail.gmail.com>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com> <2247276.HWz9edslhi@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: xiaosuo@gmail.xom,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48683 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3LQOqx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:46:53 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so8033074ieb.8
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2013 06:46:52 -0800 (PST)
In-Reply-To: <2247276.HWz9edslhi@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 15, 2013 at 2:57 PM, Oliver
<oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> wrote:
>
> I don't think that's universally the case; whether or not a port unreachable
> happens is going to depend on the configured behaviour;

I know the rate of ICMP error packets is limited by default, but in
many cases, the rate of ICMP packets isn't very large, so this may not
a problem.

> it may very well just
> silently drop the packet.
>

Yes. I know it is also a solution, but it requires the explicit configuration.

> Perhaps I'm mistaken here so please correct me if so:
>
> Firstly, I don't see why this is necessary as once the client does hole punch,
> the conntrack entry should still be good to go providing the other end is
> adhering to the port it's supposed to use. UDP is unreliable so an application
> shouldn't be expecting perfect delivery; once Client B finally does their
> initial transmit, a retransmit on the part of Client A should succeed without
> any special behaviour on the part of Netfilter.
>

Strictly speaking, Linux's NAT implementation isn't a Port Restricted
Cone NAT but based on conntrack, so once the first packets is
delivered locally, the following packets will be delivered locally too
until the conntrack is timed out due to idle. So UDP hole punching
doesn't work.

> Secondly; I see this as a great opportunity for a DoS attack if someone can
> spam ICMP errors down the pipe at you.

I don't think so, because the attacker must get the correct 5 tuples
before the reply packets pass through the linux box.

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
