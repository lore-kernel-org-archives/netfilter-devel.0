From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped packets
Date: Fri, 14 Jan 2011 10:26:42 -0500
Message-ID: <AANLkTi=Ndiks3Au1DOhJ0sQ0XqG4y0z6Ue_k21kkLUxE@mail.gmail.com>
References: <20110114152024.GA9654@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab1ANP0n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:26:43 -0500
Received: by iyj18 with SMTP id 18so2594872iyj.19
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jan 2011 07:26:42 -0800 (PST)
In-Reply-To: <20110114152024.GA9654@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 10:20 AM, Thomas Graf <tgraf@infradead.org> wro=
te:
> This patch adds a new netfilter target which creates audit records
> for packets traversing a certain chain.
>
> It can be used to record packets which are rejected administraively
> as follows:
>
> =A0-N AUDIT_DROP
> =A0-A AUDIT_DROP -j AUDIT --type DROP
> =A0-A AUDIT_DROP -j DROP
>
> a rule which would typically drop or reject a packet would then
> invoke the new chain to record packets before dropping them.
>
> =A0-j AUDIT_DROP
>
> The module is protocol independant and works for iptables, ip6tables
> and ebtables.
>
> The following information is logged:
> =A0- netfilter hook
> =A0- packet length
> =A0- incomming/outgoing interface
> =A0- MAC src/dst/proto for ethernet packets
> =A0- src/dst/protocol address for IPv4/IPv6
> =A0- src/dst port for TCP/UDP/UDPLITE
> =A0- icmp type/code
>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Thomas Graf <tgraf@redhat.com>

=46rom an audit PoV feel free to add

Acked-by: Eric Paris <eparis@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
