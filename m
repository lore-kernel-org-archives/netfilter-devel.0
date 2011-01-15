From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv4] netfilter: audit target to record accepted/dropped
 packets
Date: Sat, 15 Jan 2011 17:07:12 +0100
Message-ID: <4D31C630.7090100@trash.net>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org> <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr> <20110114222429.GB22508@canuck.infradead.org> <20110114234823.GD22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60165 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1AOQHS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:07:18 -0500
In-Reply-To: <20110114234823.GD22508@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.01.2011 00:48, schrieb Thomas Graf:
> [Save the planet and make Jan happy by returning EDOM instead of ERANGE]
> 
> This patch adds a new netfilter target which creates audit records
> for packets traversing a certain chain.
> 
> It can be used to record packets which are rejected administraively
> as follows:
> 
>   -N AUDIT_DROP
>   -A AUDIT_DROP -j AUDIT --type DROP
>   -A AUDIT_DROP -j DROP
> 
> a rule which would typically drop or reject a packet would then
> invoke the new chain to record packets before dropping them.
> 
>   -j AUDIT_DROP
> 
> The module is protocol independant and works for iptables, ip6tables
> and ebtables.
> 
> The following information is logged:
>  - netfilter hook
>  - packet length
>  - incomming/outgoing interface
>  - MAC src/dst/proto for ethernet packets
>  - src/dst/protocol address for IPv4/IPv6
>  - src/dst port for TCP/UDP/UDPLITE
>  - icmp type/code

Looks fine to me, if there are no further objections, I'll apply this
tommorrow.

> 

